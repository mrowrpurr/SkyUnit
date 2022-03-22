#include "TestHelper.h"

go_bandit([](){
    describe("HELLO CHARMED THESE ARE TESTS!", [](){
       it("69?", [&](){ AssertThat(69, Equals(69)); });
       it("Kills Braith", [&](){ AssertThat("Braith", Equals("Is dead!")); });
       it("is fucking dope, yo!", [&](){});
    });
});
