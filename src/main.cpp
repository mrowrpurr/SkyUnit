#include <format>

#include "RE/C/ConsoleLog.h"
#include "RE/T/TESObjectWEAP.h"

// TODO - Question for Charmed! - *Filter* / Find Match in a BSString or ? Case insensitive?

std::vector<std::string> FindWeaponNames(const std::string& filter) {
    std::vector<std::string> weaponNames;
    auto& allWeapons = RE::TESDataHandler::GetSingleton()->GetFormArray<RE::TESObjectWEAP>();
    for (const auto& weapon : allWeapons) {
        auto weaponName = std::string(weapon->GetFullName());
        if (weaponName.find(filter) != std::string::npos)
            weaponNames.emplace_back(weaponName);
    }
    return weaponNames;
}

extern "C" __declspec(dllexport) constinit auto SKSEPlugin_Version = []() {
	SKSE::PluginVersionData v;

	v.PluginVersion(Plugin::VERSION);
	v.PluginName(Plugin::NAME);

	v.UsesAddressLibrary(true);
	v.CompatibleVersions({ SKSE::RUNTIME_LATEST });

	return v;
}();

extern "C" __declspec(dllexport) bool SKSEAPI SKSEPlugin_Query(const SKSE::QueryInterface* skse, SKSE::PluginInfo* a_info) {
	a_info->infoVersion = SKSE::PluginInfo::kVersion;
	a_info->name = Plugin::NAME.data();
	a_info->version = Plugin::VERSION.pack();
	if (skse->IsEditor()) { return false; }
	return true;
}

extern "C" __declspec(dllexport) bool SKSEAPI SKSEPlugin_Load(const SKSE::LoadInterface* skse) {
	SKSE::Init(skse);

    SKSE::GetMessagingInterface()->RegisterListener([](SKSE::MessagingInterface::Message* message){
        if (message->type == SKSE::MessagingInterface::kDataLoaded) {
            auto* consoleLog = RE::ConsoleLog::GetSingleton();
            consoleLog->Print("Hello ladies and jellyspoons!");
            auto weaponNames = FindWeaponNames("Dagger");
            if (weaponNames.empty()) {
                consoleLog->Print("No matching weapons found.");
            } else {
                for (const auto& weaponName : weaponNames) {
                    consoleLog->Print(std::format("Found weapon: {}", weaponName).c_str());
                }
            }
        }
    });

	return true;
}
