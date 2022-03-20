#include "TestRunnerInterface.h"
#include "TestHelper.h"
#include "TestRunner.h"
#include <RE/C/Console.h>
#include <Windows.h>

namespace {
    void RunTests() {
        auto *consoleLog = RE::ConsoleLog::GetSingleton();
        consoleLog->Print("THIS WILL RUN THE TESTS!");

        bandit::detail::controller_t controller;
        controller.set_report_timing(true);
        controller.set_policy(new bandit::run_policy::bandit({}, false, false));
        bandit::detail::register_controller(&controller);

        auto reporter = new SkyUnitExampleTestRunner::WebSocketReporter();
        controller.set_reporter(reporter);
        controller.get_reporter().test_run_starting();

        bool hard_skip = false;
        context::bandit global_context("", hard_skip);
        controller.get_contexts().push_back(&global_context);

        for (const auto &func: bandit::detail::specs()) {
            func();
        };

        controller.get_reporter().test_run_complete();

        SkyUnitExampleTestRunner::Server->send(*SkyUnitExampleTestRunner::Connection, std::format("Complete"), websocketpp::frame::opcode::text);
    }

    void on_open(connection_hdl hdl) {
        SkyUnitExampleTestRunner::Connection = &hdl;
    }

    void on_close(connection_hdl hdl) {
        RE::ConsoleLog::GetSingleton()->Print("Connection closed!");
    }

    void on_fail(connection_hdl hdl) {
        RE::ConsoleLog::GetSingleton()->Print("Connection failed!");
    }

    void on_message(server<config::asio> *s, connection_hdl hdl, message_ptr msg) {
        auto messageText = msg->get_payload();
        if (messageText == "RunTests") {
            SkyUnitExampleTestRunner::Connection = &hdl;
            RunTests();
        } else if (messageText == "Quit") {
            ExitProcess(0);
        } else {
            s->send(hdl, std::format("Unknown message '{}'", messageText), websocketpp::frame::opcode::text);
        }
    }
}

void SkyUnitExampleTestRunner::RunWebSocketServer() {
    webSocketServer server;
    SkyUnitExampleTestRunner::Server = &server;
    try {
        server.set_access_channels(websocketpp::log::alevel::all);
        server.clear_access_channels(websocketpp::log::alevel::frame_payload);
        server.init_asio();
        server.set_open_handler(bind(&on_open, ::_1));
        server.set_message_handler(bind(&on_message, &server, ::_1, ::_2));
        server.set_close_handler(bind(&on_close, ::_1));
        server.set_fail_handler(bind(&on_fail, ::_1));
        server.listen(6969);
        server.start_accept();
        server.run();
    } catch (websocketpp::exception const & e) {
        std::cout << e.what() << std::endl;
    } catch (...) {
        std::cout << "other exception" << std::endl;
    }
}

extern "C" __declspec(dllexport) bool SKSEAPI SKSEPlugin_Load(const SKSE::LoadInterface* skse) {
    SKSE::Init(skse);

    SKSE::GetMessagingInterface()->RegisterListener([](SKSE::MessagingInterface::Message* message){
        if (message->type == SKSE::MessagingInterface::kDataLoaded) {
            auto* consoleLog = RE::ConsoleLog::GetSingleton();
            consoleLog->Print("Hello ladies and jellyspoons!");
            std::thread t(SkyUnitExampleTestRunner::RunWebSocketServer);
            t.detach();
//            auto weaponNames = FindWeaponNames("Dagger");
//            if (weaponNames.empty()) {
//                consoleLog->Print("No matching weapons found.");
//            } else {
//                for (const auto& weaponName : weaponNames) {
//                    consoleLog->Print(std::format("Found weapon: {}", weaponName).c_str());
//                }
//            }
        }
    });

    return true;
}
