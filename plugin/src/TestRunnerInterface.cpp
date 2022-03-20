#include "TestRunnerInterface.h"
#include "TestHelper.h"
#include "TestRunner.h"

void SkyUnitExampleTestRunner::RunTests() {
    auto* consoleLog = RE::ConsoleLog::GetSingleton();
    consoleLog->Print("THIS WILL RUN THE TESTS!");

    bandit::detail::controller_t controller;
    controller.set_report_timing(true);
    controller.set_policy(new bandit::run_policy::bandit({}, false, false));
    bandit::detail::register_controller(&controller);

    webSocketServer server;
    auto reporter = new SkyUnitExampleTestRunner::WebSocketReporter(server);
    SkyUnitExampleTestRunner::WebSocketReporter::Instance = reporter;
    controller.set_reporter(reporter);
    controller.get_reporter().test_run_starting();

    bool hard_skip = false;
    context::bandit global_context("", hard_skip);
    controller.get_contexts().push_back(&global_context);

    for (const auto& func : bandit::detail::specs()) {
      func();
    };

    controller.get_reporter().test_run_complete();
  }

extern "C" __declspec(dllexport) bool SKSEAPI SKSEPlugin_Load(const SKSE::LoadInterface* skse) {
    SKSE::Init(skse);

    SKSE::GetMessagingInterface()->RegisterListener([](SKSE::MessagingInterface::Message* message){
        if (message->type == SKSE::MessagingInterface::kDataLoaded) {
            auto* consoleLog = RE::ConsoleLog::GetSingleton();
            consoleLog->Print("Hello ladies and jellyspoons!");
            std::thread t(SkyUnitExampleTestRunner::RunTests);
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
