namespace SkyUnit {
    __declspec(dllexport) void AddCallback(std::string_view name, std::function<std::string_view()>&& callback);
}
