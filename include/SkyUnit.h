namespace SkyUnit {
    __declspec(dllexport) std::vector<std::string>& GetStringVector();
    __declspec(dllexport) void AddCallback(const std::string* name, const std::function<void()>* callback);

	extern std::unordered_map<const std::string*, const std::function<void()>*> Callbacks;
}
