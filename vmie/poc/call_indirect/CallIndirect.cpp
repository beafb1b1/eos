#include <eosio/eosio.hpp>
#include <functional>

using namespace eosio;

void f1() {
   print("Here are f1.");
}

class [[eosio::contract]] CallIndirect : public contract {
  public:
      using contract::contract;

      [[eosio::action]]
      void hi( name user ) {
         print( "Hello, ", user);
         std::function<void()> f = f1;
         f();
      }
};
