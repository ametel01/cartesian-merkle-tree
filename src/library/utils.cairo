//! Utility functions for Cartesian Merkle Trees.
//!
//! This module provides the core utility functions for CMT operations:
//!
//! * Priority calculation using cryptographic hashing
//! * Merkle hash computation with consistent ordering
//! * Tree rotation operations for maintaining heap property
//! * Helper functions for child node management
//!
//! The utilities ensure deterministic behavior and cryptographic security through
//! the use of Poseidon hashing for both priorities and Merkle commitments.
//!
//! ## Examples
//!
//! Computing priorities:
//!
//! ```
//! let key = 42;
//! let priority = CMTUtilsTrait::calculate_priority(key);
//! ```
//!
//! Computing Merkle hashes:
//!
//! ```
//! let hash = CMTUtilsTrait::calculate_merkle_hash(key, left_hash, right_hash);
//! assert!(hash != 0);
//! ```
//!
//! Performing tree rotations:
//!
//! ```
//! let rotated = CMTUtilsTrait::right_rotate(node_box);
//! // Tree structure is now rotated while maintaining properties
//! ```

use core::hash::HashStateTrait;
use core::poseidon::PoseidonTrait;
use core::traits::Into;
use super::node::{CMTNode, CMTNodeTrait};


#[generate_trait]
pub impl CMTUtilsImpl of CMTUtilsTrait {
    /// Calculates a deterministic priority for a given key using Poseidon hashing.
    ///
    /// The priority is used to maintain the heap property in the treap structure.
    /// Using cryptographic hashing ensures the priorities are effectively randomized
    /// while remaining deterministic for the same key.
    ///
    /// ## Arguments
    ///
    /// * `key` - The key to calculate priority for
    ///
    /// ## Returns
    ///
    /// A `felt252` priority value derived from the key
    ///
    /// ## Examples
    ///
    /// ```
    /// let priority1 = CMTUtilsTrait::calculate_priority(42);
    /// let priority2 = CMTUtilsTrait::calculate_priority(42);
    /// assert_eq!(priority1, priority2); // Deterministic
    ///
    /// let priority3 = CMTUtilsTrait::calculate_priority(43);
    /// assert!(priority1 != priority3); // Different keys give different priorities
    /// ```
    fn calculate_priority(key: felt252) -> felt252 {
        let mut state = PoseidonTrait::new();
        state = state.update(key);
        state.finalize()
    }

    /// Calculates the Merkle hash for a node given its key and children hashes.
    ///
    /// The hash is computed using Poseidon with consistent ordering: the key is hashed first,
    /// followed by the children hashes in sorted order (smaller hash first). This ensures
    /// deterministic hashing regardless of the tree's structure.
    ///
    /// ## Arguments
    ///
    /// * `key` - The key of the node
    /// * `left_child_mh` - Merkle hash of the left child (0 if None)
    /// * `right_child_mh` - Merkle hash of the right child (0 if None)
    ///
    /// ## Returns
    ///
    /// The computed Merkle hash for the node
    ///
    /// ## Examples
    ///
    /// ```
    /// let hash = CMTUtilsTrait::calculate_merkle_hash(50, 100, 200);
    /// assert!(hash != 0);
    ///
    /// // Hash is independent of child order
    /// let same_hash = CMTUtilsTrait::calculate_merkle_hash(50, 200, 100);
    /// assert_eq!(hash, same_hash);
    /// ```
    fn calculate_merkle_hash(
        key: felt252, left_child_mh: felt252, right_child_mh: felt252,
    ) -> felt252 {
        let mut state = PoseidonTrait::new();
        state = state.update(key);

        let left_u256: u256 = left_child_mh.into();
        let right_u256: u256 = right_child_mh.into();

        if left_u256 < right_u256 {
            state = state.update(left_child_mh);
            state = state.update(right_child_mh);
        } else {
            state = state.update(right_child_mh);
            state = state.update(left_child_mh);
        }

        state.finalize()
    }

    /// Extracts the Merkle hash from an optional child node.
    ///
    /// This helper function safely retrieves the hash from a child node reference,
    /// returning 0 for None children (representing empty subtrees).
    ///
    /// ## Arguments
    ///
    /// * `child` - Reference to an optional boxed child node
    ///
    /// ## Returns
    ///
    /// The child's Merkle hash, or 0 if the child is None
    ///
    /// ## Examples
    ///
    /// ```
    /// let hash = CMTUtilsTrait::get_child_hash(@Some(child_box));
    /// let zero_hash = CMTUtilsTrait::get_child_hash(@Option::None);
    /// assert_eq!(zero_hash, 0);
    /// ```
    fn get_child_hash(child: @Option<Box<CMTNode>>) -> felt252 {
        match child {
            Option::Some(node) => node.merkle_hash,
            Option::None => 0,
        }
    }

    /// Performs a right rotation on the given node to maintain heap property.
    ///
    /// Right rotation moves the left child up to become the new root of this subtree,
    /// with the original node becoming the right child. This operation maintains both
    /// BST ordering and is used to restore heap property when needed.
    ///
    /// ```
    ///     X                    Y
    ///    / \    right_rotate  / \
    ///   Y   C   ----------->  A   X
    ///  / \                       / \
    ///  A   B                     B   C
    /// ```
    ///
    /// ## Arguments
    ///
    /// * `node` - The node to rotate (becomes right child after rotation)
    ///
    /// ## Returns
    ///
    /// The new root of the subtree (originally the left child)
    ///
    /// ## Panics
    ///
    /// Panics if the node has no left child
    ///
    /// ## Examples
    ///
    /// ```
    /// let rotated = CMTUtilsTrait::right_rotate(node_box);
    /// // Tree structure is now rotated while preserving BST and heap properties
    /// ```
    fn right_rotate(node: Box<CMTNode>) -> Box<CMTNode> {
        let mut unboxed_node = node.unbox();
        match unboxed_node.left_child {
            Option::Some(left_child_box) => {
                let mut unboxed_left = left_child_box.unbox();

                // Store the right child of left node
                let new_left_child = unboxed_left.right_child;

                // Update the original node's left child
                unboxed_node.left_child = new_left_child;
                unboxed_node.update_merkle_hash();

                // Set the original node as the right child of left node
                unboxed_left.right_child = Option::Some(BoxTrait::new(unboxed_node));
                unboxed_left.update_merkle_hash();

                BoxTrait::new(unboxed_left)
            },
            Option::None => { panic!("Cannot right rotate without left child") },
        }
    }

    /// Performs a left rotation on the given node to maintain heap property.
    ///
    /// Left rotation moves the right child up to become the new root of this subtree,
    /// with the original node becoming the left child. This operation maintains both
    /// BST ordering and is used to restore heap property when needed.
    ///
    /// ```
    ///   X                        Y
    ///  / \      left_rotate     / \
    /// A   Y     ----------->   X   C
    ///    / \                  / \
    ///   B   C                A   B
    /// ```
    ///
    /// ## Arguments
    ///
    /// * `node` - The node to rotate (becomes left child after rotation)
    ///
    /// ## Returns
    ///
    /// The new root of the subtree (originally the right child)
    ///
    /// ## Panics
    ///
    /// Panics if the node has no right child
    ///
    /// ## Examples
    ///
    /// ```
    /// let rotated = CMTUtilsTrait::left_rotate(node_box);
    /// // Tree structure is now rotated while preserving BST and heap properties
    /// ```
    fn left_rotate(node: Box<CMTNode>) -> Box<CMTNode> {
        let mut unboxed_node = node.unbox();
        match unboxed_node.right_child {
            Option::Some(right_child_box) => {
                let mut unboxed_right = right_child_box.unbox();

                // Store the left child of right node
                let new_right_child = unboxed_right.left_child;

                // Update the original node's right child
                unboxed_node.right_child = new_right_child;
                unboxed_node.update_merkle_hash();

                // Set the original node as the left child of right node
                unboxed_right.left_child = Option::Some(BoxTrait::new(unboxed_node));
                unboxed_right.update_merkle_hash();

                BoxTrait::new(unboxed_right)
            },
            Option::None => { panic!("Cannot left rotate without right child") },
        }
    }
}

#[cfg(test)]
mod tests {
    use super::CMTUtilsTrait;

    #[test]
    fn test_calculate_priority() {
        let key: felt252 = 123;
        let priority = CMTUtilsTrait::calculate_priority(key);
        assert!(priority != 0, "Priority should not be zero");

        let same_priority = CMTUtilsTrait::calculate_priority(key);
        assert_eq!(priority, same_priority, "Priority should be deterministic");
    }

    #[test]
    fn test_calculate_merkle_hash() {
        let key: felt252 = 456;
        let left_mh: felt252 = 789;
        let right_mh: felt252 = 101112;

        let hash1 = CMTUtilsTrait::calculate_merkle_hash(key, left_mh, right_mh);
        let hash2 = CMTUtilsTrait::calculate_merkle_hash(key, right_mh, left_mh);

        assert_eq!(hash1, hash2, "Hash should be independent of child order");
    }
}
