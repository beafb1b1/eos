#include <eosio/eosio.hpp>

using namespace eosio;

class growmemory : public eosio::contract
{
  public:
    using contract::contract;

    growmemory(name receiver, name code, datastream<const char*> ds): contract(receiver, code, ds) {}

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

    [[eosio::action]]
    void insert(name user) {
      dict_index instace(get_self(), get_first_receiver().value);
      char* buf = (char*)malloc(0x30000);
      int value = buf[0x20000];
      instace.emplace(user, [&](auto& row) {
        row.key = user;
        row.value = value;
      });
      print("insert:", value);
    }


  private:
    struct [[eosio::table]] dict {
      name key;
      int value;
      uint64_t primary_key() const { return key.value;}
    };
    typedef eosio::multi_index<"dict"_n, dict> dict_index;

};