namespace SkyUnit {
	namespace {
		std::unordered_map<std::string, std::function<std::string_view()>> _testCallbacks;
	}

	namespace Private {
		std::unordered_map<std::string, std::function<std::string_view ()>>& GetTestCallbacks() {
			return _testCallbacks;
		}

		std::vector<std::string_view> GetTestNames() {
			std::vector<std::string_view> testNames;
			for (auto& [key, value] : _testCallbacks) {
				testNames.push_back(key);
			}
			return testNames;
		}
	}
	void AddTest(std::string_view name, std::function<std::string_view()>&& callback) {
		Private::GetTestCallbacks().try_emplace(std::string(name), callback);
	}
}