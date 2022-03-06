namespace SkyUnit {

    __declspec(dllexport) void AddCallback(std::string_view name, std::function<void()>&& callback);

	extern std::unordered_map<std::string_view, std::function<void()>>& GetCallbacks();

}
