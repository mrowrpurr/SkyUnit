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

    auto response = createResponse(Status::CODE_200, "<h1>Hello world!</h1><a href=\"http://mrowrpurr.com\">Mrowr Purr</a>");
    response->putHeader(Header::CONTENT_TYPE, "text/html");
    return response;

    // return response(std::format("Hey! This is SkyUnit! Let's have some Vitamin C and then continue!", now));
  }
  
  ENDPOINT("GET", "/spells/{spellName}", searchSpells, PATH(String, spellName)) {
    const auto nameQuery = spellName->data();
    const auto dataHandler = RE::TESDataHandler::GetSingleton();
    const auto& spells = dataHandler->GetFormArray<RE::SpellItem>();
    int found = 0;

    for (const auto& spell : spells) {
      std::string name(spell->GetName());
      if (name.find(nameQuery) != std::string::npos)
        found++;
    }

    return response(std::format("Found {} spells", found)); // 
  }
  
  std::shared_ptr<oatpp::web::protocol::http::outgoing::Response> response(std::string text) {
    auto response = TextDto::createShared();
    response->text = text;
    return createDtoResponse(Status::CODE_200, response);
  }
};

#include OATPP_CODEGEN_END(ApiController) 