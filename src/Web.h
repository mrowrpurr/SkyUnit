#pragma once

#include "Web/controllers/IndexController.h"
#include "Web/AppComponent.h"

#include "oatpp/network/Server.hpp"

#include <iostream>
#include <stdint.h>

namespace Web {
    void Routes(std::shared_ptr<oatpp::web::server::HttpRouter>& router) {
        router->addController(std::make_shared<IndexController>());
    }

    void Run() {
        oatpp::base::Environment::init();
        AppComponent components;
        OATPP_COMPONENT(std::shared_ptr<oatpp::web::server::HttpRouter>, router);
        Routes(router);
        OATPP_COMPONENT(std::shared_ptr<oatpp::network::ConnectionHandler>, connectionHandler);
        OATPP_COMPONENT(std::shared_ptr<oatpp::network::ServerConnectionProvider>, connectionProvider);
        oatpp::network::Server server(connectionProvider, connectionHandler);
        logger::info("SkyUnit: Begin web server on port 8000");
        server.run();
        auto* consoleLog = RE::ConsoleLog::GetSingleton();
        consoleLog->Print("SkyUnit running at http://localhost:8000");
        logger::info("SkyUnit: End web server run");
        oatpp::base::Environment::destroy();
    }

    void RunThread() {
        std::thread thread(Run);
        thread.detach();
    }
}
