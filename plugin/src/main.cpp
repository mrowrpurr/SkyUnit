// TODO - Question for Charmed! - *Filter* / Find Match in a BSString or ? Case insensitive?

#include <format>

#include <RE/C/ConsoleLog.h>
#include <RE/T/TESObjectWEAP.h>

#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/server.hpp>

#include <websocketpp/common/connection_hdl.hpp>

typedef websocketpp::server<websocketpp::config::asio> server;

using websocketpp::lib::placeholders::_1;
using websocketpp::lib::placeholders::_2;
using websocketpp::lib::bind;

// pull out the type of messages sent by our config
typedef server::message_ptr message_ptr;
typedef server::message_handler message_handler;

void on_message(server* s, websocketpp::connection_hdl hdl, message_ptr msg) {
    RE::ConsoleLog::GetSingleton()->Print(std::format("Received a message! '{}'", msg->get_payload()).c_str());
    s->send(hdl, "Sweet, we can hear you. Thanks!",  websocketpp::frame::opcode::text);
}

void RunWebSocketServer() {
    server server;
    server.set_access_channels(websocketpp::log::alevel::all);
    server.clear_access_channels(websocketpp::log::alevel::frame_payload);
    server.set_message_handler(bind(&on_message,&server,::_1,::_2));
    server.init_asio();
    server.listen(6969);
    server.start_accept();
    server.run();
}

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

    std::thread t(RunWebSocketServer);
    t.detach();

	return true;
}
