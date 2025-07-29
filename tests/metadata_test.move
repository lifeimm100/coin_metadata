#[test_only]
module coin_metadata::metadata_tests {
    use sui::test_scenario::{Self, Scenario};
    use sui::tx_context;
    use std::string;
    use coin_metadata::metadata::{Self, CoinCustomMetadata};

    // Test helper to create a test scenario with initial setup
    fun create_test_scenario(): Scenario {
        let mut scenario = test_scenario::begin(@0x1);
        test_scenario::next_tx(&mut scenario, @0x1);
        scenario
    }

    #[test]
    fun test_create_metadata() {
        let mut scenario = create_test_scenario();
        let ctx = test_scenario::ctx(&mut scenario);
        
        // Test creating new metadata
        let json = string::utf8(b"{\"name\": \"Test Coin\"}");
        let metadata = metadata::new<u64>(json, ctx);
        
        assert!(metadata.json == json, 0);
        
        test_scenario::return_shared(metadata);
        test_scenario::end(scenario);
    }

    #[test]
    fun test_update_metadata() {
        let mut scenario = create_test_scenario();
        let ctx = test_scenario::ctx(&mut scenario);
        
        // Create initial metadata
        let json = string::utf8(b"{\"name\": \"Test Coin\"}");
        let mut metadata = metadata::new<u64>(json, ctx);
        
        // Update metadata
        let new_json = string::utf8(b"{\"name\": \"Updated Test Coin\"}");
        metadata::update_metadata(&mut metadata, new_json, ctx);
        
        assert!(metadata.json == new_json, 0);
        
        test_scenario::return_shared(metadata);
        test_scenario::end(scenario);
    }
}
