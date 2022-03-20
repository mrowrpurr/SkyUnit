#include "TestHelper.h"

go_bandit([](){
    describe("Different Tests", [](){
       it("this test should pass", [&](){
           AssertThat(69, Equals(69));
       });
        it("this test should fail", [&](){
            AssertThat(69, Equals(420));
        });
    });
});
