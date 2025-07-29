#[test_only]
module coin_metadata::metadata_tests {
    use sui::test_scenario::{Self, Scenario};
    use std::string;
    use coin_metadata::metadata::Self;


const ADMIN: address = @0xAD;
    // // Test helper to create a test scenario with initial setup
    // fun create_test_scenario(): Scenario {
    //     let mut scenario = test_scenario::begin(ADMIN);
    //     test_scenario::next_tx(&mut scenario, ADMIN);
    //     metadata::test_init(test_scenario::ctx(&mut scenario));
    //     scenario
    // }

    fun setup(s: &mut Scenario) {
        test_scenario::next_tx(s, ADMIN);
        metadata::test_init(test_scenario::ctx(s));
        test_scenario::next_tx(s, ADMIN);
    }

    #[test]
    fun test_create_metadata() {
        let mut s = test_scenario::begin(ADMIN);
        setup(&mut s);
        let metadata = test_scenario::take_from_sender<metadata::CoinCustomMetadata<u64>>(&s);
        let json = string::utf8(b"{\"name\": \"Test Coin\"}");
        assert!(metadata::json(&metadata) == json, 0);
        test_scenario::return_to_sender(&s, metadata);
        test_scenario::end(s);
    }

    #[test]
    fun test_update_metadata() {
        let mut s = test_scenario::begin(ADMIN);
        setup(&mut s);
        let mut metadata = test_scenario::take_from_sender<metadata::CoinCustomMetadata<u64>>(&s);
        let json = string::utf8(b"{\"name\": \"Test Coin\"}");
        assert!(metadata::json(&metadata) == json, 0);
        let json_new = string::utf8(b"{\"name\": \"Updated Test Coin\"}");
        metadata::update_metadata(&mut metadata, json_new, test_scenario::ctx(&mut s));
        assert!(metadata::json(&metadata) == json_new, 1);
        test_scenario::return_to_sender(&s, metadata);
        test_scenario::end(s);
    }
}
