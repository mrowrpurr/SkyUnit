#include "../include/SkyUnit.h"

namespace SkyUnit {
	std::unordered_map<std::string_view, std::function<void()>> _callbacks;

    void AddCallback(std::string_view name, std::function<void()>&& callback) {
		_callbacks.try_emplace(name, callback);
    }

	std::unordered_map<std::string_view, std::function<void()>>& GetCallbacks() {
		return _callbacks;
	}
}