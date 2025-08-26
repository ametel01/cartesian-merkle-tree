//! Node structure and implementation for Cartesian Merkle Trees.
//!
//! This module provides the core `CMTNode` structure that represents individual
//! nodes in the tree, containing key, priority, hash, and child references.

use super::utils::CMTUtilsTrait;

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

#[cfg(test)]
mod tests {
    use super::CMTNodeTrait;
    use super::super::utils::CMTUtilsTrait;

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
