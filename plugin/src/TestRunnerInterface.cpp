#include "TestRunnerInterface.h"
#include "TestHelper.h"
#include "TestRunner.h"

void SkyUnitExampleTestRunner::RunTests() {
    auto* consoleLog = RE::ConsoleLog::GetSingleton();
    consoleLog->Print("THIS WILL RUN THE TESTS!");
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
