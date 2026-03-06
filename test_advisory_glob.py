#!/usr/bin/python3
# https://dnf5.readthedocs.io/en/latest/dnf_daemon/dnf5daemon_dbus_api.8.html
# install dependencies: dnf install -y dnf5 dnf5-plugins dnf5daemon-server dnf5daemon-client
# Run `dnf5 clean all` to force a refresh of the metadata

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
import sys

# set up main loop
DBusGMainLoop(set_as_default=True)
loop = GLib.MainLoop()

bus = dbus.SystemBus()
# The SessionManager interface is on the /org/rpm/dnf/v0 object path
i_session_manager = dbus.Interface(bus.get_object('org.rpm.dnf.v0', '/org/rpm/dnf/v0'), 'org.rpm.dnf.v0.SessionManager')


def create_session():
    try:
        session_path = i_session_manager.open_session({'load_system_repo': True, 'load_available_repos': True})
        print("got session:", session_path)
        return session_path, bus.get_object('org.rpm.dnf.v0', session_path)
    except Exception as e:
        print(f"Failed to create session: {e}")
        sys.exit(1)


def handle_error(error):
    print("error:", error)
    loop.quit()

# list advisories


def handle_adv_reply(advs):
    print(f"Found {len(advs)} advisories")
    for adv in advs:
        # Print whatever ID/Name key is available
        adv_id = adv.get('advisoryid', adv.get('name', 'unknown'))
        title = adv.get('title', 'no title')
        print(f" - {adv_id}: {title}")
    loop.quit()


def run_test(proxy, label, options):
    print(f"\n>>> TEST: {label}")
    # Explicitly request some attributes to be sure
    if "advisory_attrs" not in options:
        options["advisory_attrs"] = ["advisoryid", "title"]
    print(f"Options: {options}")
    proxy.list(options,
               dbus_interface='org.rpm.dnf.v0.Advisory',
               reply_handler=handle_adv_reply,
               error_handler=handle_error,
               timeout=120)
    loop.run()


# Initialize session
session_path, session_proxy = create_session()

# Make sure repos are loaded (optional but helpful)
print("Loading repositories...")
session_proxy.read_all_repos(dbus_interface='org.rpm.dnf.v0.Base', timeout=120)

# 1. names WITHOUT glob (Should find exact match)
# Using 'buildah' as per user script, but let's try an actual advisory ID if we can find one.
# If 'buildah' is passed to 'names', it should find NOTHING because 'buildah' is a package name, not an advisory ID.
run_test(session_proxy, "names WITHOUT glob (Package name in names field)",
         {"availability": "all", "names": ["buildah"]})

run_test(session_proxy, "names WITHOUT glob (Package name in names field)",
         {"availability": "all", "names": ["FEDORA-2026-dbf30aad2f"]})

# 2. names WITH glob (Should find nothing as IDs don't support globs)
run_test(session_proxy, "names WITH glob",
         {"availability": "all", "names": ["FEDORA-*"]})

# 3. contains_pkgs WITHOUT glob (Should find exact match)
run_test(session_proxy, "contains_pkgs WITHOUT glob",
         {"availability": "all", "contains_pkgs": ["buildah"]})

# 4. contains_pkgs WITH glob (Should find matches)
run_test(session_proxy, "contains_pkgs WITH glob",
         {"availability": "all", "contains_pkgs": ["build*"]})

i_session_manager.close_session(session_path)
print("\nVerification complete.")
