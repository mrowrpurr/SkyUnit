namespace SkyUnit {

    __declspec(dllexport) void AddCallback(std::string&& name, std::function<void()>&& callback);

	extern std::unordered_map<std::string, std::function<void()>>& GetCallbacks();

}
