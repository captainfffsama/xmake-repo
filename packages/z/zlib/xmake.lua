package("zlib")

    set_homepage("http://www.zlib.net")
    set_description("A Massively Spiffy Yet Delicately Unobtrusive Compression Library")

    add_urls("https://github.com/madler/zlib/archive/$(version).tar.gz",
             "https://github.com/madler/zlib.git")
    add_versions("v1.2.10", "42cd7b2bdaf1c4570e0877e61f2fdc0bce8019492431d054d3d86925e5058dc5")
    add_versions("v1.2.11", "629380c90a77b964d896ed37163f5c3a34f6e6d897311f1df2a7016355c45eff")
    add_versions("v1.2.12", "d8688496ea40fb61787500e863cc63c9afcbc524468cedeb478068924eb54932")

    if is_plat("mingw") and is_subhost("msys") then
        add_extsources("pacman::zlib")
    elseif is_plat("linux") then
        add_extsources("pacman::zlib", "apt::zlib1g-dev")
    elseif is_plat("macosx") then
        add_extsources("brew::zlib")
    end

    on_install(function (package)
        io.writefile("xmake.lua", [[
            includes("check_cincludes.lua")
            add_rules("mode.debug", "mode.release")
            target("zlib")
                set_kind("$(kind)")
                if not is_plat("windows") then
                    set_basename("z")
                end
                add_files("adler32.c")
                add_files("compress.c")
                add_files("crc32.c")
                add_files("deflate.c")
                add_files("gzclose.c")
                add_files("gzlib.c")
                add_files("gzread.c")
                add_files("gzwrite.c")
                add_files("inflate.c")
                add_files("infback.c")
                add_files("inftrees.c")
                add_files("inffast.c")
                add_files("trees.c")
                add_files("uncompr.c")
                add_files("zutil.c")
                add_headerfiles("zlib.h", "zconf.h")
                check_cincludes("Z_HAVE_UNISTD_H", "unistd.h")
                check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
                check_cincludes("HAVE_STDINT_H", "stdint.h")
                check_cincludes("HAVE_STDDEF_H", "stddef.h")
                if is_plat("windows") then
                    add_defines("_CRT_SECURE_NO_DEPRECATE")
                    add_defines("_CRT_NONSTDC_NO_DEPRECATE")
                    if is_kind("shared") then
                        add_files("win32/zlib1.rc")
                        add_defines("ZLIB_DLL")
                    end
                else
                    add_defines("ZEXPORT=__attribute__((visibility(\"default\")))")
                    add_defines("_LARGEFILE64_SOURCE=1")
                end
        ]])
        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        elseif not package:is_plat("windows", "mingw") and package:config("pic") ~= false then
            configs.cxflags = "-fPIC"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("inflate", {includes = "zlib.h"}))
    end)
