#include "../include/SkyUnit.h"

namespace SkyUnit {
	std::unordered_map<std::string, std::function<std::string_view()>> _callbacks;

    void AddCallback(std::string_view name, std::function<std::string_view()>&& callback) {
		_callbacks.try_emplace(std::string(name), callback);
    }

	std::unordered_map<std::string, std::function<std::string_view ()>>& GetCallbacks() {
		return _callbacks;
	}
}