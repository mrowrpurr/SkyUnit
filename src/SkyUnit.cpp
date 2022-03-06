#include "../include/SkyUnit.h"

std::unordered_map<const std::string*, const std::function<void()>*> SkyUnit::Callbacks;

namespace SkyUnit {
    std::vector<std::string> _texts = {};

    std::vector<std::string>& GetStringVector() {
        return _texts;
    }

    void AddCallback(const std::string* name, const std::function<void()>* callback) {
		Callbacks.try_emplace(name, callback);
    }
}