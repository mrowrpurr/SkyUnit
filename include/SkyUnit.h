namespace SkyUnit {
    std::vector<std::string> _texts = {};

    void AddText(std::string text) {
        return _texts.push_back(text);
    }

    std::vector<std::string_view> GetTexts() {
        std::vector<std::string_view> copy = {};
        for (const auto text : _texts) {
            copy.push_back(text);
        }
        return copy;
    }
}