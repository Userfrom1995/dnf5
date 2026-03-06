#include <langinfo.h>
#include <locale.h>

#include <iostream>

int main() {
    // Test different locales
    const char * locales[] = {"C", "en_US.UTF-8", "de_DE.UTF-8", "fr_FR.UTF-8", "cs_CZ.UTF-8"};

    for (const char * loc : locales) {
        if (setlocale(LC_ALL, loc)) {
            std::cout << "Locale: " << loc << std::endl;
            std::cout << "  YESEXPR: '" << nl_langinfo(YESEXPR) << "'" << std::endl;
            std::cout << "  NOEXPR:  '" << nl_langinfo(NOEXPR) << "'" << std::endl;
            std::cout << std::endl;
        }
    }

    return 0;
}
