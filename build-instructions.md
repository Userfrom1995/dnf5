# DNF5 Build Instructions

## Prerequisites

First, ensure you're on Fedora 42 and have basic development tools:

```bash
sudo dnf install -y cmake gcc-c++ make git rpm-build
```

## Install Build Dependencies

### Method 1: Use builddep (Recommended)

```bash
# This installs most dependencies from the spec file
sudo dnf builddep /home/myuser/dnf5/dnf5.spec --define '_without_plugin_manifest 1'
```

### Method 2: Install manually

If builddep doesn't work, install these core dependencies:

```bash
sudo dnf install -y \
  bash-completion-devel \
  cmake \
  doxygen \
  gettext \
  gcc-c++ \
  pkgconfig \
  check-devel \
  fmt-devel \
  json-c-devel \
  openssl-devel \
  librepo-devel \
  libsolv-devel \
  rpm-devel \
  sqlite-devel \
  zlib-devel \
  libcomps-devel \
  libmodulemd-devel \
  sdbus-cpp-devel \
  systemd-devel \
  libsmartcols-devel \
  createrepo_c \
  cppunit-devel \
  swig
```

## Install toml11

```bash
# toml11 is a header-only library
sudo dnf install -y toml11-devel toml11-static

# If not available, install from source:
cd /tmp
git clone https://github.com/ToruNiina/toml11.git
cd toml11
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
sudo make install
```

## Build DNF5

### Option 1: Full Build (if all dependencies are met)

```bash
cd /home/myuser/dnf5
rm -rf build
mkdir build
cd build

cmake ..
make -j$(nproc)
```

### Option 2: Minimal Build (recommended if dependencies are missing)

```bash
cd /home/myuser/dnf5
rm -rf build
mkdir build
cd build

cmake .. \
  -DWITH_PLUGIN_MANIFEST=OFF \
  -DWITH_PLUGIN_RHSM=OFF \
  -DWITH_DNF5DAEMON_SERVER=OFF \
  -DWITH_DNF5DAEMON_CLIENT=OFF \
  -DWITH_TESTS=OFF

make -j$(nproc)
```

### Option 3: Build without optional plugins

```bash
cd /home/myuser/dnf5
rm -rf build
mkdir build
cd build

cmake .. \
  -DWITH_PLUGIN_MANIFEST=OFF

make -j$(nproc)
```

## Run Tests

```bash
cd /home/myuser/dnf5/build
CTEST_OUTPUT_ON_FAILURE=1 make test
```

## Install

To install (not recommended for development):

```bash
cd /home/myuser/dnf5/build
sudo make install
```

Or build an RPM:

```bash
cd /home/myuser/dnf5
tito build --rpm --test
```

## Troubleshooting

### Missing toml11
- Install `toml11-static` or `toml11-devel` package
- Or build from source (see instructions above)

### Missing libpkgmanifest-devel
- Build with `-DWITH_PLUGIN_MANIFEST=OFF`
- This is optional and not needed for core functionality

### Missing other dependencies
- Check error message for specific package
- Install with: `sudo dnf install <package-name>-devel`

## Contributing

Once you've built successfully, you can:

1. Make your changes
2. Test locally
3. Build RPM for testing: `tito build --rpm --test`
4. Create a PR following CONTRIBUTING.md guidelines

## Common CMake Options

- `-DWITH_DNF5=ON/OFF` - Build dnf5 command
- `-DWITH_DNF5_PLUGINS=ON/OFF` - Build dnf5 plugins
- `-DWITH_PLUGIN_MANIFEST=ON/OFF` - Build manifest plugin
- `-DWITH_PLUGIN_RHSM=ON/OFF` - Build RHSM plugin
- `-DWITH_DNF5DAEMON_SERVER=ON/OFF` - Build daemon server
- `-DWITH_DNF5DAEMON_CLIENT=ON/OFF` - Build daemon client
- `-DWITH_TESTS=ON/OFF` - Build tests
- `-DWITH_MAN=ON/OFF` - Build man pages
