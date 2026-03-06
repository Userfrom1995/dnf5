#include <langinfo.h>
#include <locale.h>
#include <regex.h>

#include <iostream>

void test_pattern(const char * pattern, const char * input) {
    regex_t regex;
    if (regcomp(&regex, pattern, REG_EXTENDED | REG_NOSUB) == 0) {
        int result = regexec(&regex, input, 0, nullptr, 0);
        std::cout << "  Pattern '" << pattern << "' vs '" << input << "': " << (result == 0 ? "MATCH" : "NO MATCH")
                  << std::endl;
        regfree(&regex);
    }
}

int main() {
    setlocale(LC_ALL, "cs_CZ.UTF-8");

    const char * yesexpr = nl_langinfo(YESEXPR);
    std::cout << "Czech YESEXPR: '" << yesexpr << "'" << std::endl;

    // Test current pattern
    std::cout << "\nTesting current pattern:" << std::endl;
    test_pattern(yesexpr, "a");
    test_pattern(yesexpr, "ano");
    test_pattern(yesexpr, "A");
    test_pattern(yesexpr, "Ano");

    // Test fixed pattern
    std::cout << "\nTesting fixed pattern (with .*):" << std::endl;
    test_pattern("^[+1aAyY].*", "a");
    test_pattern("^[+1aAyY].*", "ano");
    test_pattern("^[+1aAyY].*", "A");
    test_pattern("^[+1aAyY].*", "Ano");

    return 0;
}
