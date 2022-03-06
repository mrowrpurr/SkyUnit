#pragma once

#include <iostream>
#include <format>
#include <thread>
#include <exception>
#include <oatpp/web/server/api/ApiController.hpp>
#include <oatpp/core/macro/codegen.hpp>
#include <oatpp/core/macro/component.hpp>
#include <inja/inja.hpp>

#include "Web/dtos/TextDto.h"

#include OATPP_CODEGEN_BEGIN(ApiController)

class IndexController : public oatpp::web::server::api::ApiController {
public:
  explicit IndexController(OATPP_COMPONENT(std::shared_ptr<ObjectMapper>, objectMapper)) : oatpp::web::server::api::ApiController(objectMapper) {}

  ENDPOINT("GET", "/", root) {
	const auto htmlTemplate = R"(<h1>Available Callbacks CHANGED</h1>
<ul>
## for callback in callbacks
	<li><a href="/callbacks/{{ callback }}>{{ callback }}</a></li>
## endfor
</ul>
)";

	inja::json data;
	data["callbacks"] = SkyUnit::Private::GetTestNames();

	const auto html = inja::render(htmlTemplate, data);
    return HtmlResponse(html);
  }

	ENDPOINT("GET", "/callbacks/{callbackName}", invokeCallback, PATH(String, callbackNameString)) {
		const auto callbackName = callbackNameString->c_str();
		auto callbacks = SkyUnit::Private::GetTestCallbacks();
		if (callbacks.contains((callbackName))) {
			auto fn = callbacks[callbackName];
			try {
				auto result = fn();
				return TextResponse(std::format("Callback {} returned {}", callbackName, result));
			} catch (...) {
				return TextResponse(std::format("Callback blew up: {}", callbackName));
			}
		} else {
			return TextResponse(std::format("No callback defined with this name: {}", callbackName));
		}
	}

	std::shared_ptr<oatpp::web::protocol::http::outgoing::Response> HtmlResponse(const std::string& text) {
		auto response = createResponse(Status::CODE_200, text);
		response->putHeader(Header::CONTENT_TYPE, "text/html");
		return response;
	}

	std::shared_ptr<oatpp::web::protocol::http::outgoing::Response> TextResponse(const std::string& text) {
    auto response = TextDto::createShared();
    response->text = text;
    return createDtoResponse(Status::CODE_200, response);
  }
};

#include OATPP_CODEGEN_END(ApiController)
