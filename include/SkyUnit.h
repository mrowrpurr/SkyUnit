namespace SkyUnit {
    __declspec(dllexport) void AddTest(std::string_view name, std::function<std::string_view()>&& callback);

	namespace Private {
		extern std::vector<std::string_view> GetTestNames();
		extern std::unordered_map<std::string, std::function<std::string_view()>>& GetTestCallbacks();
	}
}
