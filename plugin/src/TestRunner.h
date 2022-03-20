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

    // lol.
    webSocketServer* Server;
    connection_hdl* Connection;

    struct WebSocketReporter : public bandit::reporter::interface {
    public:
        ~WebSocketReporter() override = default;

        void test_run_starting() override {
            RE::ConsoleLog::GetSingleton()->Print("Tests started!");
            Server->send(*Connection, "Tests started!", frame::opcode::text);
        }

        void test_run_complete() override {
            RE::ConsoleLog::GetSingleton()->Print("Tests complete!");
            Server->send(*Connection, "Tests complete!", frame::opcode::text);
        }

        void context_starting(const std::string &desc) override {
            RE::ConsoleLog::GetSingleton()->Print(std::format("Starting context: {}", desc).c_str());
            Server->send(*Connection, std::format("Starting context: {}", desc), frame::opcode::text);
        }

        void context_ended(const std::string &desc) override {}

        void test_run_error(const std::string &desc, const bandit::detail::test_run_error &error) override {}

        void it_starting(const std::string &desc) override {
//            RE::ConsoleLog::GetSingleton()->Print(std::format("Starting test: {}", desc).c_str());
        }

        void it_succeeded(const std::string &desc) override {
            RE::ConsoleLog::GetSingleton()->Print(std::format("{} PASSED", desc).c_str());
            Server->send(*Connection, std::format("{} PASSED", desc), frame::opcode::text);
        }

        void it_failed(const std::string &desc, const bandit::detail::assertion_exception &ex) override {
            RE::ConsoleLog::GetSingleton()->Print(std::format("{} FAILED", desc).c_str());
            Server->send(*Connection, std::format("{} FAILED", desc), frame::opcode::text);
        }

        void it_unknown_error(const std::string &desc) override {}

        void it_skip(const std::string &desc) override {}

        bool did_we_pass() const override {
            return true; // why is this my responsibility? lol.
        }
    };
}
