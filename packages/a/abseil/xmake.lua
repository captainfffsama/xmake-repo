package("abseil")

    set_homepage("https://abseil.io")
    set_description("C++ Common Libraries")
    set_license("Apache-2.0")

    add_urls("https://git.chiebot.com:10000/Chiebot-Mirror/abseil-cpp.git")
    add_versions("20200225.1", "df3ea785d8c30a9503321a3d35ee7d35808f190d")
    add_versions("20200923.3", "6f9d96a1f41439ac172ee2ef7ccd8edf0e5d068c")
    add_versions("20210324.1", "e1d388e7e74803050423d035e4374131b9b57919")
    add_versions("20210324.2", "278e0a071885a22dcd2fd1b5576cc44757299343")
    add_versions("20211102.0", "215105818dfde3174fe799600bb0f3cae233d0bf")
    add_versions("20220623.0", "273292d1cfc0a94a65082ee350509af1d113344d")

    add_deps("cmake")

    on_install("macosx", "linux", "windows", function (package)
        local configs = {"-DCMAKE_CXX_STANDARD=17"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DCMAKE_POSITION_INDEPENDENT_CODE=TRUE")
        import("package.tools.cmake").install(package, configs, {buildir = os.tmpfile() .. ".dir"})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <iostream>
            #include <string>
            #include <vector>
            void test () {
                std::vector<std::string> v = {"foo","bar","baz"};
                std::string s = absl::StrJoin(v, "-");
                std::cout << "Joined string: " << s << "\\n";
            }
        ]]}, {configs = {languages = "c++17"}, includes = "absl/strings/str_join.h"}))
    end)
