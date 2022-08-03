package("meson")

    set_kind("binary")
    set_homepage("https://mesonbuild.com/")
    set_description("Fast and user friendly build system.")
    set_license("Apache-2.0")

    add_urls("https://git.chiebot.com:10000/Chiebot-Mirror/meson.git")
    add_versions("0.62.1", "bb91cea0d66d8d036063dedec1f194d663399cdf")
    add_versions("0.61.2", "b2b78b8ec76f5a9a287d78e2c9e18604d7197ef0")
    add_versions("0.60.1", "4859d7039b05d31216ddeda3fbc528991bc95cac")

    add_deps("ninja", "python 3.x", {kind = "binary"})

    on_install("@macosx", "@linux", "@windows", function (package)
        local envs = {PYTHONPATH = package:installdir()}
        local python = package:is_plat("windows") and "python" or "python3"
        os.vrunv(python, {"-m", "pip", "install", "--target=" .. package:installdir(), "."}, {envs = envs})
        package:addenv("PYTHONPATH", envs.PYTHONPATH)
    end)

    on_test(function (package)
        os.vrun("meson --version")
    end)
