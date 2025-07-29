// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module coin_metadata::metadata {
    use std::string;
    use std::ascii;

    public struct CoinCustomMetadata<phantom T> has key, store {
        id: UID,
        json: string::String,
    }

    /// Event emitted when metadata is updated
    public struct MetadataUpdateEvent has copy, drop {
        coin_type: ascii::String,
        new_json: string::String
    }

    /// Create a new CoinCustomMetadata object
    public fun new<T>(json: string::String, ctx: &mut TxContext): CoinCustomMetadata<T> {
        CoinCustomMetadata {
            id: object::new(ctx),
            json
        }
    }

    /// Update the json metadata of a CoinCustomMetadata object
    public fun update_metadata<T>(
        metadata: &mut CoinCustomMetadata<T>,
        new_json: string::String,
        _ctx: &mut TxContext
    ) {
        metadata.json = new_json;
        sui::event::emit(MetadataUpdateEvent {
            coin_type: std::type_name::into_string(std::type_name::get<T>()),
            new_json
        });
    }

    /// Get the json metadata of a CoinCustomMetadata object
    public fun json<T>(metadata: &CoinCustomMetadata<T>): string::String {
        metadata.json
    }

    
}
