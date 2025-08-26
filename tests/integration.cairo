//! Tests for the on-chain Cartesian Merkle Tree contract
//!
//! These tests mirror the unit tests from utils.cairo, tree.cairo, and proof.cairo
//! to ensure the contract behaves identically to the in-memory implementation.

use cartesian_merkle_tree::CMTUtilsTrait;
use cartesian_merkle_tree::components::cmtree_component::{
    ICMTreeDispatcher, ICMTreeDispatcherTrait,
};
use core::array::ArrayTrait;
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

// Helper function to deploy the example CMTree contract
fn deploy_cmt_contract() -> ICMTreeDispatcher {
    let contract = declare("CMTreeExampleContract").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    ICMTreeDispatcher { contract_address }
}

//
// Tests mirroring utils.cairo unit tests
//

#[test]
fn test_contract_calculate_priority() {
    // Test that priority calculation is deterministic and consistent with utils
    let key: felt252 = 123;
    let _expected_priority = CMTUtilsTrait::calculate_priority(key);

    // The contract should use the same priority calculation
    let dispatcher = deploy_cmt_contract();
    dispatcher.insert(key);

    // We can't directly access the priority, but we can verify the tree works
    assert!(dispatcher.search(key), "Key should be found after insertion");
}

#[test]
fn test_contract_merkle_hash_determinism() {
    let dispatcher = deploy_cmt_contract();

    // Insert the same keys in different contracts
    dispatcher.insert(50);
    dispatcher.insert(30);
    dispatcher.insert(70);

    let hash1 = dispatcher.get_root_hash();

    let dispatcher2 = deploy_cmt_contract();
    dispatcher2.insert(50);
    dispatcher2.insert(30);
    dispatcher2.insert(70);

    let hash2 = dispatcher2.get_root_hash();

    assert_eq!(hash1, hash2, "Same tree structure should have same root hash");
}

//
// Tests mirroring tree.cairo unit tests
//

#[test]
fn test_contract_insert_single() {
    let dispatcher = deploy_cmt_contract();

    let key: felt252 = 42;
    dispatcher.insert(key);

    assert!(dispatcher.search(key), "Inserted key should be found");
    assert!(dispatcher.get_root_hash() != 0, "Root hash should be non-zero");
}

#[test]
fn test_contract_insert_multiple() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(30);
    dispatcher.insert(70);
    dispatcher.insert(20);
    dispatcher.insert(40);

    assert!(dispatcher.search(50), "Should find 50");
    assert!(dispatcher.search(30), "Should find 30");
    assert!(dispatcher.search(70), "Should find 70");
    assert!(dispatcher.search(20), "Should find 20");
    assert!(dispatcher.search(40), "Should find 40");
}

#[test]
fn test_contract_insert_duplicate() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(42);
    let hash_before = dispatcher.get_root_hash();

    // Insert the same key again - this creates a duplicate node in the tree
    dispatcher.insert(42);
    let hash_after = dispatcher.get_root_hash();

    // Hash will change because a new node is added (duplicates are allowed)
    assert!(hash_before != hash_after, "Duplicate insert creates new node");
    assert!(dispatcher.search(42), "Key should still be found");
}

#[test]
fn test_contract_search_empty() {
    let dispatcher = deploy_cmt_contract();

    assert!(!dispatcher.search(42), "Search in empty tree should return false");
}

#[test]
fn test_contract_search_not_found() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(30);

    assert!(!dispatcher.search(100), "Should not find non-existent key");
}

#[test]
fn test_contract_remove_leaf() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(30);
    dispatcher.insert(70);

    let removed = dispatcher.remove(70);
    assert!(removed, "Remove should return true for existing key");
    assert!(!dispatcher.search(70), "Removed key should not be found");
    assert!(dispatcher.search(50), "Other keys should still exist");
    assert!(dispatcher.search(30), "Other keys should still exist");
}

#[test]
fn test_contract_remove_node_with_one_child() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(30);
    dispatcher.insert(20);

    let removed = dispatcher.remove(30);
    assert!(removed, "Remove should return true");
    assert!(!dispatcher.search(30), "Removed key should not be found");
    assert!(dispatcher.search(50), "Root should still exist");
    assert!(dispatcher.search(20), "Remaining child should still exist");
}

#[test]
fn test_contract_remove_root() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    let removed = dispatcher.remove(50);

    assert!(removed, "Remove should return true");
    assert!(!dispatcher.search(50), "Removed root should not be found");
    assert_eq!(dispatcher.get_root_hash(), 0, "Tree should be empty");
}

#[test]
fn test_contract_remove_nonexistent() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    let removed = dispatcher.remove(100);

    assert!(!removed, "Remove should return false for non-existent key");
    assert!(dispatcher.search(50), "Existing key should still be found");
}

#[test]
fn test_contract_complex_operations() {
    let dispatcher = deploy_cmt_contract();

    // Build a larger tree
    let keys = array![50, 30, 70, 20, 40, 60, 80, 10, 25, 35, 45];
    let mut i = 0;
    while i < keys.len() {
        dispatcher.insert(*keys.at(i));
        i += 1;
    }

    // Verify all keys are present
    i = 0;
    while i < keys.len() {
        assert!(dispatcher.search(*keys.at(i)), "All inserted keys should be found");
        i += 1;
    }

    // Remove some keys
    assert!(dispatcher.remove(20), "Should remove 20");
    assert!(dispatcher.remove(40), "Should remove 40");
    assert!(dispatcher.remove(70), "Should remove 70");

    // Verify removed keys are gone and others remain
    assert!(!dispatcher.search(20), "20 should be removed");
    assert!(!dispatcher.search(40), "40 should be removed");
    assert!(!dispatcher.search(70), "70 should be removed");

    assert!(dispatcher.search(50), "50 should remain");
    assert!(dispatcher.search(30), "30 should remain");
    assert!(dispatcher.search(60), "60 should remain");
    assert!(dispatcher.search(80), "80 should remain");
}

//
// Tests mirroring proof.cairo unit tests
//

#[test]
fn test_contract_generate_proof_existing() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(30);
    dispatcher.insert(70);

    let proof = dispatcher.generate_proof(30);
    assert!(proof.existence, "Proof should indicate existence");
    assert_eq!(proof.key, 30, "Proof should be for requested key");
    assert!(proof.siblings_length > 0, "Proof should have siblings");
}

#[test]
fn test_contract_generate_proof_non_existing() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(70);

    let proof = dispatcher.generate_proof(60);
    assert!(!proof.existence, "Proof should indicate non-existence");
    assert!(proof.non_existence_key != 0, "Should have non-existence key");
}

#[test]
fn test_contract_verify_proof_valid() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(30);
    dispatcher.insert(70);
    dispatcher.insert(20);

    let proof = dispatcher.generate_proof(30);
    let root_hash = dispatcher.get_root_hash();

    let is_valid = dispatcher.verify_proof(proof, root_hash, 30);
    assert!(is_valid, "Valid proof should verify successfully");
}

#[test]
fn test_contract_verify_proof_invalid_root() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(30);

    let proof = dispatcher.generate_proof(30);
    let wrong_root = 12345; // Invalid root hash

    let is_valid = dispatcher.verify_proof(proof, wrong_root, 30);
    assert!(!is_valid, "Proof with wrong root should fail verification");
}

#[test]
fn test_contract_verify_proof_wrong_key() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(30);

    let proof = dispatcher.generate_proof(30);
    let root_hash = dispatcher.get_root_hash();

    let is_valid = dispatcher.verify_proof(proof, root_hash, 40); // Wrong key
    assert!(!is_valid, "Proof for wrong key should fail verification");
}

#[test]
fn test_contract_proof_after_modifications() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(30);
    dispatcher.insert(70);

    let proof_before = dispatcher.generate_proof(30);
    let root_before = dispatcher.get_root_hash();

    // Modify tree
    dispatcher.insert(20);
    let root_after = dispatcher.get_root_hash();

    // Old proof should not verify with new root
    let is_valid_old = dispatcher.verify_proof(proof_before.clone(), root_after, 30);
    assert!(!is_valid_old, "Old proof should not verify with new root");

    // New proof should verify
    let proof_after = dispatcher.generate_proof(30);
    let is_valid_new = dispatcher.verify_proof(proof_after, root_after, 30);
    assert!(is_valid_new, "New proof should verify with new root");

    // But old proof should still verify with old root to ensure consistency
    let is_valid_original = dispatcher.verify_proof(proof_before, root_before, 30);
    assert!(is_valid_original, "Original proof should verify with original root");
}

#[test]
fn test_contract_non_existence_proof() {
    let dispatcher = deploy_cmt_contract();

    dispatcher.insert(50);
    dispatcher.insert(70);

    let proof = dispatcher.generate_proof(60); // Key between 50 and 70
    let root_hash = dispatcher.get_root_hash();

    assert!(!proof.existence, "Should be non-existence proof");

    let is_valid = dispatcher.verify_proof(proof, root_hash, 60);
    assert!(is_valid, "Non-existence proof should verify");
}

#[test]
fn test_contract_empty_tree_proof() {
    let dispatcher = deploy_cmt_contract();

    let proof = dispatcher.generate_proof(42);
    let root_hash = dispatcher.get_root_hash();

    assert!(!proof.existence, "Proof in empty tree should be non-existence");
    assert_eq!(root_hash, 0, "Empty tree should have zero root");

    let is_valid = dispatcher.verify_proof(proof, root_hash, 42);
    assert!(is_valid, "Empty tree non-existence proof should verify");
}

//
// Additional contract-specific tests
//

#[test]
fn test_contract_state_persistence() {
    let dispatcher = deploy_cmt_contract();

    // Insert keys
    dispatcher.insert(100);
    dispatcher.insert(50);
    dispatcher.insert(150);

    let hash1 = dispatcher.get_root_hash();

    // Make more operations
    dispatcher.insert(25);
    dispatcher.remove(50);

    let hash2 = dispatcher.get_root_hash();
    assert!(hash1 != hash2, "Hash should change after modifications");

    // Verify final state
    assert!(dispatcher.search(100), "Should find 100");
    assert!(!dispatcher.search(50), "Should not find removed 50");
    assert!(dispatcher.search(150), "Should find 150");
    assert!(dispatcher.search(25), "Should find 25");
}

#[test]
fn test_contract_large_tree() {
    let dispatcher = deploy_cmt_contract();

    // Insert many keys
    let mut i = 1_u32;
    while i <= 20 {
        dispatcher.insert(i.into());
        i += 1;
    }

    // Verify all keys
    i = 1;
    while i <= 20 {
        assert!(dispatcher.search(i.into()), "Should find all inserted keys");
        i += 1;
    }

    // Remove some keys
    i = 5;
    while i <= 15 {
        assert!(dispatcher.remove(i.into()), "Should remove keys");
        i += 2; // Remove every other key
    }

    // Verify final state
    assert!(dispatcher.search(1.into()), "Should find 1");
    assert!(dispatcher.search(3.into()), "Should find 3");
    assert!(!dispatcher.search(5.into()), "Should not find removed 5");
    assert!(dispatcher.search(16.into()), "Should find 16");
    assert!(dispatcher.search(20.into()), "Should find 20");
}

#[test]
fn test_contract_proof_consistency() {
    let dispatcher = deploy_cmt_contract();

    // Build tree
    dispatcher.insert(50);
    dispatcher.insert(25);
    dispatcher.insert(75);
    dispatcher.insert(12);
    dispatcher.insert(37);

    // Generate proofs for all keys
    let proof_50 = dispatcher.generate_proof(50);
    let proof_25 = dispatcher.generate_proof(25);
    let proof_75 = dispatcher.generate_proof(75);
    let proof_12 = dispatcher.generate_proof(12);
    let proof_37 = dispatcher.generate_proof(37);

    let root = dispatcher.get_root_hash();

    // All proofs should verify
    assert!(dispatcher.verify_proof(proof_50, root, 50), "Proof 50 should verify");
    assert!(dispatcher.verify_proof(proof_25, root, 25), "Proof 25 should verify");
    assert!(dispatcher.verify_proof(proof_75, root, 75), "Proof 75 should verify");
    assert!(dispatcher.verify_proof(proof_12, root, 12), "Proof 12 should verify");
    assert!(dispatcher.verify_proof(proof_37, root, 37), "Proof 37 should verify");
}
