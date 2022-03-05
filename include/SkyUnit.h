namespace SkyUnit {
    std::string _hello = "Hi there";

    std::string* GetHello() {
        return &_hello;
    }
}