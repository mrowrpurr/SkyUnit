#pragma once

#include <iostream>
#include <format>
#include <thread>
#include <windows.h>
#include <oatpp/web/server/api/ApiController.hpp>
#include <oatpp/core/macro/codegen.hpp>
#include <oatpp/core/macro/component.hpp>
#include <RE/C/ConsoleLog.h>
#include <exception>

#include "Web/dtos/TextDto.h"

#include OATPP_CODEGEN_BEGIN(ApiController)

class IndexController : public oatpp::web::server::api::ApiController {
public:
  IndexController(OATPP_COMPONENT(std::shared_ptr<ObjectMapper>, objectMapper)) : oatpp::web::server::api::ApiController(objectMapper) {}

  ENDPOINT("GET", "/", root) {
    auto now = std::chrono::system_clock::now();

    auto html = std::string("<h1>List of registered callbacks:</h1><ul>");
	auto callbacks = SkyUnit::GetCallbacks();
	for (auto& [key, value] : callbacks) {
		html = std::format("{}<li><a href=\"/callback/{}\">{}</a></li>", html, key, key);
	}
    html = std::format("{}</ul>", html);

    auto response = createResponse(Status::CODE_200, html);
    response->putHeader(Header::CONTENT_TYPE, "text/html");
    return response;

    // return response(std::format("Hey! This is SkyUnit! Let's have some Vitamin C and then continue!", now));
  }

	ENDPOINT("GET", "/callback/{callbackName}", invokeCallback, PATH(String, callbackName)) {
		auto callbacks = SkyUnit::GetCallbacks();
		if (callbacks.contains((callbackName->c_str()))) {
			auto fn = callbacks[callbackName->c_str()];
			try {
				auto result = fn();
				return response(std::format("Callback {} returned {}", callbackName->c_str(), result));
			} catch (...) {
				return response(std::format("Callback blew up: {}", callbackName->c_str()));
			}
		} else {
			return response(std::format("No callback defined with this name: {}", callbackName->c_str()));
		}
	}

  std::shared_ptr<oatpp::web::protocol::http::outgoing::Response> response(std::string text) {
    auto response = TextDto::createShared();
    response->text = text;
    return createDtoResponse(Status::CODE_200, response);
  }
};

#include OATPP_CODEGEN_END(ApiController) 