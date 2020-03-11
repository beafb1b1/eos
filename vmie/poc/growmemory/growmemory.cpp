#include <eosio/eosio.hpp>

using namespace eosio;


class growmemory : public eosio::contract
{
  public:
    using contract::contract;

    [[eosio::action]]
    void add()
    {
      print("your call to add");
    }


    [[eosio::action]]
    void setmem() {
      char* buf = (char*)malloc(0x30000);
      buf[0x20000] = 0x42;
    }

    [[eosio::action]]
    void readmem() {
      char* buf = (char*)malloc(0x30000);
      print(buf[0x20000]);
    }
};