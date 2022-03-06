namespace SkyUnit {

    __declspec(dllexport) void AddTest(std::string_view name, std::function<void()>&& callback);

	extern std::unordered_map<std::string, std::function<void()>>& GetCallbacks();

}
