
package("grpc")

    set_homepage("https://grpc.io/")
    set_description("The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)")
    set_license("Apache-2.0")

    add_urls("https://git.chiebot.com:10000/Chiebot-Mirror/grpc.git")
    add_versions("1.48.0", "d2054ec6c6e8abcecf0e24b0b4ee75035d80c3cc")
    add_versions("1.37.0", "44c40ac23023b7b3dd82744372c06817cc203898")

    -- add_configs("usemirror", {description = "Build 3rd-party libraries by mirror.", default = true, type = "boolean"})

    on_download(function (package,opt)
        local packge_tmp_dir=package:cachedir() .. "/source/grpc"
        os.tryrm(packge_tmp_dir)
        import("devel.git")
        git.clone(package:urls()[1],{branch = "v"..package:version_str(),depth=1,outputdir=packge_tmp_dir})
        import("net.http")
        http.download("https://soft.chiebot.com:10000/code_mirror/gitmodules/gitmodules_grpc",packge_tmp_dir .."/.gitmodules")
        local third_party_mirror="https://git.chiebot.com:10000/HuQiong/grpc_3rd.git"
        os.tryrm(packge_tmp_dir .."/third_party")
        git.clone(third_party_mirror,{branch = "v"..package:version_str(),depth=1,outputdir=packge_tmp_dir .. "/third_party"})
    end)

    on_install("linux","windows",function (package)
        local configs = {}
        table.insert(configs,"-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs,"-DCMAKE_BUILD_TYPE=" .. (package:config("debug") and "Debug" or "Release"))
        import("package.tools.cmake").install(package, configs)

        for _, link in ipairs({"absl_bad_any_cast_impl","absl_bad_optional_access",
        "absl_bad_variant_access","absl_base","absl_city","absl_civil_time","absl_cord",
        "absl_cord_internal","absl_cordz_functions","absl_cordz_handle","absl_cordz_info",
        "absl_cordz_sample_token","absl_debugging_internal","absl_demangle_internal","absl_examine_stack",
        "absl_exponential_biased","absl_failure_signal_handler","absl_flags","absl_flags_commandlineflag",
        "absl_flags_commandlineflag_internal","absl_flags_config","absl_flags_internal",
        "absl_flags_marshalling","absl_flags_parse","absl_flags_private_handle_accessor",
        "absl_flags_program_name","absl_flags_reflection","absl_flags_usage","absl_flags_usage_internal",
        "absl_graphcycles_internal","absl_hash","absl_hashtablez_sampler","absl_int128","absl_leak_check",
        "absl_log_severity","absl_low_level_hash","absl_malloc_internal","absl_periodic_sampler",
        "absl_random_distributions","absl_random_internal_distribution_test_util",
        "absl_random_internal_platform","absl_random_internal_pool_urbg","absl_random_internal_randen",
        "absl_random_internal_randen_hwaes","absl_random_internal_randen_hwaes_impl",
        "absl_random_internal_randen_slow","absl_random_internal_seed_material",
        "absl_random_seed_gen_exception","absl_random_seed_sequences","absl_raw_hash_set",
        "absl_raw_logging_internal","absl_scoped_set_env","absl_spinlock_wait","absl_stacktrace",
        "absl_status","absl_statusor","absl_strerror","absl_str_format_internal","absl_strings",
        "absl_strings_internal","absl_symbolize","absl_synchronization","absl_throw_delegate","absl_time",
        "absl_time_zone","address_sorting","cares","crypto","gpr","grpc++","grpc","grpc++_alts",
        "grpc++_error_details","grpc_plugin_support","grpcpp_channelz","grpc++_reflection","grpc++_unsecure",
        "grpc_unsecure","protobuf","protobuf-lite","protoc","re2","ssl","upb","z"}) do
            local reallink=link
            if package:is_plat("windows", "mingw") then
                reallink = reallink .. package:version():gsub("%.", "")
            end
            if xmake.version():le("2.5.7") and package:is_plat("mingw") and package:config("shared") then
                reallink = reallink .. ".dll"
            end
            package:add("links", reallink)
        end
        package:addenv("PATH", "bin")

    end)


    -- on_test(function (package)
    --     assert(package:has_cxxincludes("grpcpp/grpcpp.h"))
    -- end)

