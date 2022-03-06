namespace SkyUnit {
	namespace Private {
		namespace Data {
			extern std::unordered_map<std::string, std::function<std::string_view()>>& GetCallbacks();
		}
	}
}