#include "SkyUnit/Data.h"

namespace SkyUnit {
    void AddCallback(std::string_view name, std::function<std::string_view()>&& callback) {
		SkyUnit::Private::Data::GetCallbacks().try_emplace(std::string(name), callback);
    }
}