namespace SkyUnit::Private::Data {
	std::unordered_map<std::string, std::function<std::string_view()>> _callbacks;
	std::unordered_map<std::string, std::function<std::string_view ()>>& GetCallbacks() {
		return _callbacks;
	}
}
