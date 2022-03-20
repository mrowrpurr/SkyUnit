#include <websocketpp/config/asio_no_tls_client.hpp>
#include <websocketpp/client.hpp>
#include <Windows.h>
#include <iostream>

typedef websocketpp::client<websocketpp::config::asio_client> client;

using websocketpp::lib::placeholders::_1;
using websocketpp::lib::placeholders::_2;
using websocketpp::lib::bind;

typedef websocketpp::config::asio_client::message_type::ptr message_ptr;

void on_open(client* c, websocketpp::connection_hdl hdl) {
    websocketpp::lib::error_code ec;
    c->send(hdl, "RunTests", websocketpp::frame::opcode::text, ec);
}

void on_close(client* c, websocketpp::connection_hdl hdl) {
}

void on_message(client* c, websocketpp::connection_hdl hdl, message_ptr msg) {
    auto messageText = msg->get_payload();
    if (messageText == "Complete") {
        c->send(hdl, "Quit", websocketpp::frame::opcode::text);
        Sleep(100);
        c->close(hdl, websocketpp::close::status::going_away, "");
    } else {
        std::cout << messageText + "\n";
    }
}

int main(int argc, char* argv[]) {
    std::system(R"(C:\Modding\MO2\ModOrganizer.exe "moshortcut://Authoring - AE:SKSE")");
    Sleep(4000);
    client c;

    std::string uri = "ws://localhost:6969";

    try {
        // Set logging to be pretty verbose (everything except message payloads)
//        c.set_access_channels(websocketpp::log::alevel::all);
//        c.clear_access_channels(websocketpp::log::alevel::frame_payload);

        c.set_open_handler(bind(&on_open, &c, ::_1));
        c.set_close_handler(bind(&on_close, &c, ::_1));

        // Initialize ASIO
        c.init_asio();

        c.set_access_channels(websocketpp::log::alevel::none);
        c.clear_access_channels(websocketpp::log::alevel::all);
        c.set_error_channels(websocketpp::log::alevel::none);
        c.clear_error_channels(websocketpp::log::alevel::all);

        // Register our message handler
        c.set_message_handler(bind(&on_message,&c,::_1,::_2));

        websocketpp::lib::error_code ec;
        client::connection_ptr con = c.get_connection(uri, ec);
        if (ec) {
            std::cout << "could not create connection because: " << ec.message() << std::endl;
            return 0;
        }

        // Note that connect here only requests a connection. No network messages are
        // exchanged until the event loop starts running in the next line.
        c.connect(con);

        // Start the ASIO io_service run loop
        // this will cause a single connection to be made to the server. c.run()
        // will exit when this connection is closed.
        c.run();
    } catch (websocketpp::exception const & e) {
        std::cout << std::format("ERROR! {}\n", e.what());
    }
}