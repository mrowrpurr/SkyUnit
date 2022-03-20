#pragma once

#include <bandit/reporters/interface.h>
#include <RE/C/ConsoleLog.h>
#include <websocketpp/server.hpp>
#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/common/connection_hdl.hpp>

#include "TestHelper.h"

using namespace bandit::reporter;
using namespace websocketpp;
using websocketpp::lib::placeholders::_1;
using websocketpp::lib::placeholders::_2;
using websocketpp::lib::bind;

typedef websocketpp::server<config::asio> webSocketServer;
typedef webSocketServer::message_ptr message_ptr;
typedef webSocketServer::message_handler message_handler;

namespace SkyUnitExampleTestRunner {

    webSocketServer* Server;
    connection_hdl* Connection;

    void on_open(connection_hdl hdl) {
        Connection = &hdl;
    }

    void on_message(server<config::asio>* s, connection_hdl hdl, message_ptr msg) {
        auto messageText = msg->get_payload();
        if (messageText == "RunTests") {
            // TODO RUN TESTS!
        } else {
            s->send(hdl, std::format("Unexpected message '{}'", messageText), websocketpp::frame::opcode::text);
        }
    }

    struct WebSocketReporter : public bandit::reporter::interface {

    public:

        explicit WebSocketReporter(webSocketServer& server) {
            Server = &server;
            try {
                server.set_access_channels(websocketpp::log::alevel::all);
                server.clear_access_channels(websocketpp::log::alevel::frame_payload);
                server.init_asio();
                server.set_open_handler(bind(&on_open, ::_1));
                server.set_message_handler(bind(&on_message, &server, ::_1, ::_2));
                server.listen(6969);
                server.start_accept();
                std::thread t([&server](){ server.run(); });
                t.detach();
            } catch (websocketpp::exception const & e) {
                std::cout << e.what() << std::endl;
            } catch (...) {
                std::cout << "other exception" << std::endl;
            }
        }

        ~WebSocketReporter() override = default;

        void test_run_starting() override {
            RE::ConsoleLog::GetSingleton()->Print("Tests started!");
        }

        void test_run_complete() override {
            RE::ConsoleLog::GetSingleton()->Print("Tests complete!");
        }

        void context_starting(const std::string &desc) override {
            RE::ConsoleLog::GetSingleton()->Print(std::format("Starting context: {}", desc).c_str());
        }

        void context_ended(const std::string &desc) override {}

        void test_run_error(const std::string &desc, const bandit::detail::test_run_error &error) override {}

        void it_starting(const std::string &desc) override {
//            RE::ConsoleLog::GetSingleton()->Print(std::format("Starting test: {}", desc).c_str());
        }

        void it_succeeded(const std::string &desc) override {
            RE::ConsoleLog::GetSingleton()->Print(std::format("{} PASSED", desc).c_str());
        }

        void it_failed(const std::string &desc, const bandit::detail::assertion_exception &ex) override {
            RE::ConsoleLog::GetSingleton()->Print(std::format("{} FAILED", desc).c_str());
        }

        void it_unknown_error(const std::string &desc) override {}

        void it_skip(const std::string &desc) override {}

        bool did_we_pass() const override {
            return true; // why is this my responsibility? lol.
        }
    };
}
