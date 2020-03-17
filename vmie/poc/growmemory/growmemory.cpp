#include <eosio/eosio.hpp>
#include <eosio/permission.hpp>
#include <eosio/asset.hpp>
#include <eosio/symbol.hpp>

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
    void setmem(name user) {
      char* buf = (char*)malloc(0x30000);
      buf[0x20000] = 0x42;
      require_auth(user);
    }

    [[eosio::action]]
    void readmem() {
      char* buf = (char*)malloc(0x30000);
      print(buf[0x20000]);
    }

    [[eosio::action]]
    void insert(name user) {
      dict_index instance(get_self(), get_first_receiver().value);
      char* buf = (char*)malloc(0x30000);
      int value = buf[0x20000];
      auto it = instance.find(user.value);
      if (it != instance.end()) {
        instance.erase(it);
      }
      instance.emplace(user, [&](auto& row) {
        row.key = user;
        row.value = value;
      });
      print("insert:", value);
    }

    [[eosio::action]]
    void dotransfer(name from, name to) {
      dict_index instance(get_self(), get_first_receiver().value);
      auto it = instance.find(from.value);
      eosio::check(it != instance.end(), "Record does not exist");
      print(it->value);
      if (it->value != 0) {
        print("!!!!!!!! transfer !!!!!!!");
        eosio::transaction txn{};
        std::string memo = "memo";
        txn.actions.emplace_back(
          eosio::permission_level(from, "active"_n),
          "eosio.token"_n,
          "transfer"_n,
          std::make_tuple(from, to, eosio::asset(10000, eosio::symbol(eosio::symbol_code("SYS"), 4)), memo)
        );
        txn.send(eosio::name(memo).value, from);
      }

    }


  private:
    struct [[eosio::table]] dict {
      name key;
      int value;
      uint64_t primary_key() const { return key.value;}
    };
    typedef eosio::multi_index<"dict"_n, dict> dict_index;

};