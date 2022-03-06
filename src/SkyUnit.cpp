#include "../include/SkyUnit.h"

namespace SkyUnit {
	std::unordered_map<std::string, std::function<void()>> _callbacks;

    void AddTest(std::string_view name, std::function<void()>&& callback) {
		_callbacks.try_emplace(std::string(name), callback);
    }

	std::unordered_map<std::string, std::function<void()>>& GetCallbacks() {
		return _callbacks;
	}
}