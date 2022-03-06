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

    auto html = std::string("<h1>Tests:</h1><p><a href=\"/run-all\">Run all</a></p><ul>");
	auto callbacks = SkyUnit::GetCallbacks();
	for (auto& [key, value] : callbacks) {
		html = std::format("{}<li><a href=\"/test/{}\">{}</a></li>", html, key, key);
	}
    html = std::format("{}</ul>", html);

	return responseHtml(html);
  }

	ENDPOINT("GET", "/test/{callbackNameString}", runTest, PATH(String, callbackNameString)) {
		const auto callbackName = urlDecode(callbackNameString->c_str());
		auto callbacks = SkyUnit::GetCallbacks();
		if (callbacks.contains((callbackName.data()))) {
			auto fn = callbacks[callbackName];
			try {
				fn();
				return responseHtml(std::format("<strong style=\"color: #127339;\">Test {} passed</strong>", callbackName));
			} catch (const snowhouse::AssertionException& e) {
				return responseHtml(std::format("<strong style=\"color: #b00c6c\">Test {} failed with message: {}</strong>", callbackName, e.what()));
			} catch (...) {
				return responseHtml(std::format("<strong style=\"color: #b00c6c\">Test {} failed with unexpected error</strong>", callbackName));
			}
		} else {
			return responseHtml(std::format("No test defined with this name: {}", callbackName));
		}
	}

	ENDPOINT("GET", "/run-all", runAll) {
		bool anyFailed = false;
		std::string results = "<ul>";
		auto callbacks = SkyUnit::GetCallbacks();
		for (const auto& [testName, fn] : callbacks) {
			try {
				fn();
				results += std::format("<li style=\"color: #127339;\">Test {} passed</li>", testName);
			} catch (const snowhouse::AssertionException& e) {
				results += std::format("<li style=\"color: #b00c6c\">Test {} failed with message: {}</li>", testName, e.what());
				anyFailed = true;
			} catch (...) {
				results += std::format("<li style=\"color: #b00c6c\">Test {} failed with unexpected error</li>", testName);
				anyFailed = true;
			}
		}
		results += "</ul>";
		if (anyFailed) {
			results = std::format("<h1 style=\"color: #b00c6c\">Tests Failed</h1>{}", results);
		} else {
			results = std::format("<h1 style=\"color: #127339;\">Tests Passed</h1>{}", results);
		}
		return responseHtml(results);
	}

	std::shared_ptr<oatpp::web::protocol::http::outgoing::Response> responseHtml(std::string text) {
		auto response = createResponse(Status::CODE_200, text);
		response->putHeader(Header::CONTENT_TYPE, "text/html");
		return response;
	}

	std::shared_ptr<oatpp::web::protocol::http::outgoing::Response> response(std::string text) {
		auto response = TextDto::createShared();
		response->text = text;
		return createDtoResponse(Status::CODE_200, response);
	}
};

#include OATPP_CODEGEN_END(ApiController) 