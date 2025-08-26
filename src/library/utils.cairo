//! Utility functions and data structures for Cartesian Merkle Trees.
//!
//! This module provides the core building blocks for CMT operations:
//!
//! * Node structure representing individual tree elements
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
//! Creating and managing nodes:
//!
//! ```
//! let key = 42;
//! let priority = CMTUtilsTrait::calculate_priority(key);
//! let mut node = CMTNodeTrait::new(key, priority);
//! node.update_merkle_hash();
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

/// A node in the Cartesian Merkle Tree containing key, priority, hash, and child references.
///
/// Each node maintains the three essential properties of the CMT:
/// * **Key**: Used for BST ordering and proof generation
/// * **Priority**: Randomized value for heap property maintenance
/// * **Merkle Hash**: Cryptographic commitment to this node and its subtree
/// * **Children**: References to left and right child nodes
#[derive(Drop, Copy, Debug)]
pub struct CMTNode {
    /// The key value for BST ordering and identification
    pub key: felt252,
    /// Randomized priority for heap property (derived from key)
    pub priority: felt252,
    /// Merkle hash commitment to this node and its children
    pub merkle_hash: felt252,
    /// Reference to the left child node (keys < this.key)
    pub left_child: Option<Box<CMTNode>>,
    /// Reference to the right child node (keys > this.key)
    pub right_child: Option<Box<CMTNode>>,
}

#[generate_trait]
pub impl CMTNodeImpl of CMTNodeTrait {
    /// Creates a new CMT node with the specified key and priority.
    ///
    /// The node is initialized with no children and a zero Merkle hash.
    /// The hash should be updated using `update_merkle_hash()` after creation.
    ///
    /// ## Arguments
    ///
    /// * `key` - The key value for this node
    /// * `priority` - The priority value for heap ordering
    ///
    /// ## Returns
    ///
    /// A new `CMTNode` with the specified key and priority
    ///
    /// ## Examples
    ///
    /// ```
    /// let key = 42;
    /// let priority = CMTUtilsTrait::calculate_priority(key);
    /// let node = CMTNodeTrait::new(key, priority);
    /// assert_eq!(node.key, key);
    /// assert_eq!(node.merkle_hash, 0);
    /// ```
    fn new(key: felt252, priority: felt252) -> CMTNode {
        CMTNode {
            key, priority, merkle_hash: 0, left_child: Option::None, right_child: Option::None,
        }
    }

    /// Creates a new CMT node with the specified key, priority, and children.
    ///
    /// The Merkle hash is automatically calculated based on the key and children hashes.
    /// This is typically used during tree rotations or reconstruction.
    ///
    /// ## Arguments
    ///
    /// * `key` - The key value for this node
    /// * `priority` - The priority value for heap ordering
    /// * `left_child` - Optional left child node
    /// * `right_child` - Optional right child node
    ///
    /// ## Returns
    ///
    /// A new `CMTNode` with calculated Merkle hash
    ///
    /// ## Examples
    ///
    /// ```
    /// let node = CMTNodeTrait::new_with_children(
    ///     50, priority, Some(left_box), Some(right_box)
    /// );
    /// assert!(node.merkle_hash != 0);
    /// ```
    fn new_with_children(
        key: felt252,
        priority: felt252,
        left_child: Option<Box<CMTNode>>,
        right_child: Option<Box<CMTNode>>,
    ) -> CMTNode {
        let merkle_hash = CMTUtilsTrait::calculate_merkle_hash(
            key,
            CMTUtilsTrait::get_child_hash(@left_child),
            CMTUtilsTrait::get_child_hash(@right_child),
        );

        CMTNode { key, priority, merkle_hash, left_child, right_child }
    }

    /// Updates the Merkle hash of this node based on its key and current children.
    ///
    /// This method should be called whenever the node's children change to maintain
    /// the cryptographic integrity of the tree. The hash is computed deterministically
    /// using the node's key and its children's hashes.
    ///
    /// ## Examples
    ///
    /// ```
    /// let mut node = CMTNodeTrait::new(key, priority);
    /// node.left_child = Some(left_child_box);
    /// node.update_merkle_hash(); // Hash now reflects the new child
    /// ```
    fn update_merkle_hash(ref self: CMTNode) {
        self
            .merkle_hash =
                CMTUtilsTrait::calculate_merkle_hash(
                    self.key,
                    CMTUtilsTrait::get_child_hash(@self.left_child),
                    CMTUtilsTrait::get_child_hash(@self.right_child),
                );
    }
}

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
    use super::{CMTNodeTrait, CMTUtilsTrait};

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

    #[test]
    fn test_node_creation() {
        let key: felt252 = 100;
        let priority: felt252 = 200;

        let node = CMTNodeTrait::new(key, priority);
        assert_eq!(node.key, key, "Key should match");
        assert_eq!(node.priority, priority, "Priority should match");
        assert_eq!(node.merkle_hash, 0, "Initial merkle hash should be 0");
    }

    #[test]
    fn test_update_merkle_hash() {
        let key: felt252 = 50;
        let priority = CMTUtilsTrait::calculate_priority(key);

        let mut node = CMTNodeTrait::new(key, priority);
        node.update_merkle_hash();

        assert!(node.merkle_hash != 0, "Merkle hash should be updated");
    }
}
