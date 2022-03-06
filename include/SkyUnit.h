namespace SkyUnit {

    __declspec(dllexport) void AddTest(std::string_view name, std::function<std::string_view()>&& callback);

	extern std::unordered_map<std::string, std::function<std::string_view()>>& GetCallbacks();

}
