#include <langinfo.h>
#include <locale.h>

#include <iostream>

void show_yesexpr(const char * locale_name) {
    if (setlocale(LC_ALL, locale_name)) {
        std::cout << "Locale: " << locale_name << std::endl;
        std::cout << "  YESEXPR: '" << nl_langinfo(YESEXPR) << "'" << std::endl;
        std::cout << "  NOEXPR:  '" << nl_langinfo(NOEXPR) << "'" << std::endl;
    } else {
        std::cout << "Failed to set locale: " << locale_name << std::endl;
    }
    std::cout << std::endl;
}

int main() {
    std::cout << "=== Testing nl_langinfo() dependency on C locale ===" << std::endl;

    // Test 1: Start with C locale
    std::cout << "1. Default/C locale:" << std::endl;
    show_yesexpr("C");

    // Test 2: Change to German
    std::cout << "2. After setting German locale:" << std::endl;
    show_yesexpr("de_DE.UTF-8");

    // Test 3: Change to Czech
    std::cout << "3. After setting Czech locale:" << std::endl;
    show_yesexpr("cs_CZ.UTF-8");

    // Test 4: Back to English
    std::cout << "4. Back to English locale:" << std::endl;
    show_yesexpr("en_US.UTF-8");

    // Test 5: What happens with invalid locale?
    std::cout << "5. Invalid locale (should fail):" << std::endl;
    show_yesexpr("invalid_locale");

    return 0;
}
