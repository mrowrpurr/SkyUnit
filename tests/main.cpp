#include <iostream>
//#include <cstdlib>
#include <boost/process.hpp>

int main(int, char*) {
    auto skseLoaderPath = R"("C:\Program Files (x86)\Steam\steamapps\common\Skyrim AE with Creation Kit\skse64_loader.exe")";
//    auto skseLoaderPath = R"("C:\Program Files (x86)\Steam\steamapps\common\Skyrim AE with Creation Kit\SkyrimSE.exe")";
//    std::system(skseLoaderPath);

    boost::process::spawn(skseLoaderPath);

//    boost::process::child skyrim(skseLoaderPath);
//    std::cout << std::format("PID: {}\n", skyrim.id());
//    std::cout << std::format("Running?: {}\n", skyrim.running());
    std::cout << "Hello, this will boot up Skyrim!";
}
