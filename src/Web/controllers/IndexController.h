#pragma once

#include <iostream>
#include <format>
#include <thread>
#include <stdio.h>

#include <oatpp/web/server/api/ApiController.hpp>
#include <oatpp/core/macro/codegen.hpp>
#include <oatpp/core/macro/component.hpp>

#include <snowhouse/snowhouse.h>

#include "Web/dtos/TextDto.h"

#include OATPP_CODEGEN_BEGIN(ApiController)

class IndexController : public oatpp::web::server::api::ApiController {
public:
  IndexController(OATPP_COMPONENT(std::shared_ptr<ObjectMapper>, objectMapper)) : oatpp::web::server::api::ApiController(objectMapper) {}

  // https://stackoverflow.com/a/4823686
  std::string urlDecode(std::string uriComponent) {
    std::string ret;
    char ch;
    int i, ii;
    for (i=0; i<uriComponent.length(); i++) {
        if (int(uriComponent[i])==37) {
            sscanf_s(uriComponent.substr(i+1,2).c_str(), "%x", &ii);
            ch=static_cast<char>(ii);
            ret+=ch;
            i=i+2;
        } else {
            ret+=uriComponent[i];
        }
    }
    return (ret);
  }

  ENDPOINT("GET", "/", root) {
    auto now = std::chrono::system_clock::now();

    auto html = std::string("<h1>Tests:</h1><ul>");
	auto callbacks = SkyUnit::GetCallbacks();
	for (auto& [key, value] : callbacks) {
		html = std::format("{}<li><a href=\"/test/{}\">{}</a></li>", html, key, key);
	}
    html = std::format("{}</ul>", html);

    auto response = createResponse(Status::CODE_200, html);
    response->putHeader(Header::CONTENT_TYPE, "text/html");
    return response;

    // return response(std::format("Hey! This is SkyUnit! Let's have some Vitamin C and then continue!", now));
  }

  // RENAME TO TEST!
	ENDPOINT("GET", "/test/{callbackNameString}", invokeCallback, PATH(String, callbackNameString)) {
		const auto callbackName = urlDecode(callbackNameString->c_str());
		auto callbacks = SkyUnit::GetCallbacks();
		if (callbacks.contains((callbackName.data()))) {
			auto fn = callbacks[callbackName];
			try {
				fn();
				return response(std::format("Test {} passed", callbackName));
			} catch (const snowhouse::AssertionException& e) {
				return response(std::format("Test {} failed with message: {}", callbackName, e.what()));
			} catch (...) {
				return response(std::format("Test {} failed with unexpected error", callbackName));
			}
		} else {
			return response(std::format("No test defined with this name: {}", callbackName));
		}
	}

  std::shared_ptr<oatpp::web::protocol::http::outgoing::Response> response(std::string text) {
    auto response = TextDto::createShared();
    response->text = text;
    return createDtoResponse(Status::CODE_200, response);
  }
};

#include OATPP_CODEGEN_END(ApiController) 