#pragma once

#include <iostream>
#include <format>
#include <thread>
#include <windows.h>
#include <oatpp/web/server/api/ApiController.hpp>
#include <oatpp/core/macro/codegen.hpp>
#include <oatpp/core/macro/component.hpp>
#include <RE/C/ConsoleLog.h>

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

	ENDPOINT("GET", "/callback/{callbackName}", searchSpells, PATH(String, callbackName)) {
		return response(std::format("Hello, the callback is {}", callbackName->c_str()));
	}

  std::shared_ptr<oatpp::web::protocol::http::outgoing::Response> response(std::string text) {
    auto response = TextDto::createShared();
    response->text = text;
    return createDtoResponse(Status::CODE_200, response);
  }
};

#include OATPP_CODEGEN_END(ApiController) 