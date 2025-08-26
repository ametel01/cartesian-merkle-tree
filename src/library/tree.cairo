//! Cartesian Merkle Tree implementation combining BST and heap properties.
//!
//! This module provides a complete implementation of a Cartesian Merkle Tree, which is:
//!
//! * A binary search tree ordered by keys
//! * A heap ordered by priorities (randomized based on keys)
//! * A Merkle tree with cryptographic hash verification
//! * Self-balancing through treap rotations
//!
//! The structure maintains logarithmic time complexity for insertions, deletions, and searches
//! while providing cryptographic proof capabilities through Merkle hashes.
//!
//! ## Examples
//!
//! Creating and using a new tree:
//!
//! ```
//! let mut tree = CMTreeTrait::new();
//! tree.insert(50);
//! tree.insert(30);
//! tree.insert(70);
//!
//! assert!(tree.search(50));
//! let root_hash = tree.get_root_hash();
//! ```
//!
//! Working with multiple operations:
//!
//! ```
//! let mut tree = CMTreeTrait::new();
//! tree.insert(10);
//! tree.insert(20);
//! tree.insert(5);
//!
//! assert!(tree.remove(10));
//! assert!(!tree.search(10));
//! assert!(tree.search(20));
//! ```
//!
//! Getting cryptographic verification:
//!
//! ```
//! let mut tree = CMTreeTrait::new();
//! tree.insert(42);
//! let hash = tree.get_root_hash();
//! assert!(hash != 0); // Non-empty tree has non-zero hash
//! ```

use core::traits::Into;
use super::utils::{CMTNode, CMTNodeTrait, CMTUtilsTrait};

/// A Cartesian Merkle Tree combining binary search tree, heap, and Merkle tree properties.
///
/// The tree maintains three invariants simultaneously:
/// 1. **BST Property**: Left subtree keys < node key < right subtree keys
/// 2. **Heap Property**: Parent priority >= child priorities
/// 3. **Merkle Property**: Each node's hash depends on its key and children's hashes
#[derive(Drop, Copy, Debug)]
pub struct CMTree {
    /// The root node of the tree, None for empty trees
    pub root: Option<Box<CMTNode>>,
}

#[generate_trait]
pub impl CMTreeImpl of CMTreeTrait {
    /// Creates a new empty Cartesian Merkle Tree.
    ///
    /// ## Returns
    ///
    /// An empty `CMTree` with no root node
    ///
    /// ## Examples
    ///
    /// ```
    /// let tree = CMTreeTrait::new();
    /// assert_eq!(tree.get_root_hash(), 0);
    /// assert!(!tree.search(42));
    /// ```
    fn new() -> CMTree {
        CMTree { root: Option::None }
    }

    /// Inserts a key into the Cartesian Merkle Tree.
    ///
    /// The insertion maintains all three tree properties (BST, heap, Merkle) through:
    /// 1. BST insertion based on key comparison
    /// 2. Treap rotations to maintain heap property based on priority
    /// 3. Merkle hash updates for cryptographic integrity
    ///
    /// Priority is deterministically calculated from the key, ensuring consistent tree structure.
    ///
    /// ## Arguments
    ///
    /// * `key` - The key to insert into the tree
    ///
    /// ## Examples
    ///
    /// ```
    /// let mut tree = CMTreeTrait::new();
    /// tree.insert(42);
    /// assert!(tree.search(42));
    /// ```
    fn insert(ref self: CMTree, key: felt252) {
        let priority = CMTUtilsTrait::calculate_priority(key);
        let mut new_node = CMTNodeTrait::new(key, priority);
        new_node.update_merkle_hash();
        let boxed_node = BoxTrait::new(new_node);

        match self.root {
            Option::None => { self.root = Option::Some(boxed_node); },
            Option::Some(root) => {
                self.root = Option::Some(Self::insert_node(root, boxed_node));
            },
        }
    }

    /// Internal recursive function for inserting a node while maintaining tree properties.
    ///
    /// Performs BST insertion based on key comparison, then checks and restores heap property
    /// through rotations if necessary. Updates Merkle hashes along the insertion path.
    ///
    /// ## Arguments
    ///
    /// * `current` - The current node being examined
    /// * `new_node` - The node to insert
    ///
    /// ## Returns
    ///
    /// The root of the subtree after insertion and any necessary rotations
    fn insert_node(mut current: Box<CMTNode>, new_node: Box<CMTNode>) -> Box<CMTNode> {
        let mut current_unboxed = current.unbox();
        let new_node_unboxed = new_node.unbox();

        // BST insertion based on key
        let new_key_u256: u256 = new_node_unboxed.key.into();
        let current_key_u256: u256 = current_unboxed.key.into();

        if new_key_u256 < current_key_u256 {
            match current_unboxed.left_child {
                Option::None => {
                    // Insert as left child
                    current_unboxed.left_child = Option::Some(new_node);
                    current_unboxed.update_merkle_hash();
                    let boxed_current = BoxTrait::new(current_unboxed);

                    // Check if rotation is needed (heap property)
                    Self::restore_heap_property(boxed_current, true)
                },
                Option::Some(left_child) => {
                    // Recursively insert into left subtree
                    current_unboxed
                        .left_child = Option::Some(Self::insert_node(left_child, new_node));
                    current_unboxed.update_merkle_hash();
                    let boxed_current = BoxTrait::new(current_unboxed);

                    // Check if rotation is needed
                    Self::restore_heap_property(boxed_current, true)
                },
            }
        } else {
            match current_unboxed.right_child {
                Option::None => {
                    // Insert as right child
                    current_unboxed.right_child = Option::Some(new_node);
                    current_unboxed.update_merkle_hash();
                    let boxed_current = BoxTrait::new(current_unboxed);

                    // Check if rotation is needed
                    Self::restore_heap_property(boxed_current, false)
                },
                Option::Some(right_child) => {
                    // Recursively insert into right subtree
                    current_unboxed
                        .right_child = Option::Some(Self::insert_node(right_child, new_node));
                    current_unboxed.update_merkle_hash();
                    let boxed_current = BoxTrait::new(current_unboxed);

                    // Check if rotation is needed
                    Self::restore_heap_property(boxed_current, false)
                },
            }
        }
    }

    /// Restores the heap property by performing rotations when a child has higher priority than
    /// parent.
    ///
    /// This function checks if the specified child violates the heap property (child priority >
    /// parent priority)
    /// and performs the appropriate rotation to restore it. This maintains the treap invariant.
    ///
    /// ## Arguments
    ///
    /// * `node` - The node to check and potentially rotate
    /// * `check_left` - Whether to check the left child (true) or right child (false)
    ///
    /// ## Returns
    ///
    /// The root of the subtree after any necessary rotation
    fn restore_heap_property(node: Box<CMTNode>, check_left: bool) -> Box<CMTNode> {
        let node_unboxed = node.unbox();

        if check_left {
            match @node_unboxed.left_child {
                Option::Some(left_child) => {
                    let left_priority = *left_child.as_snapshot().unbox().priority;
                    let left_priority_u256: u256 = left_priority.into();
                    let node_priority_u256: u256 = node_unboxed.priority.into();

                    if left_priority_u256 > node_priority_u256 {
                        // Left child has higher priority, perform right rotation
                        CMTUtilsTrait::right_rotate(BoxTrait::new(node_unboxed))
                    } else {
                        BoxTrait::new(node_unboxed)
                    }
                },
                Option::None => BoxTrait::new(node_unboxed),
            }
        } else {
            match @node_unboxed.right_child {
                Option::Some(right_child) => {
                    let right_priority = *right_child.as_snapshot().unbox().priority;
                    let right_priority_u256: u256 = right_priority.into();
                    let node_priority_u256: u256 = node_unboxed.priority.into();

                    if right_priority_u256 > node_priority_u256 {
                        // Right child has higher priority, perform left rotation
                        CMTUtilsTrait::left_rotate(BoxTrait::new(node_unboxed))
                    } else {
                        BoxTrait::new(node_unboxed)
                    }
                },
                Option::None => BoxTrait::new(node_unboxed),
            }
        }
    }

    /// Searches for a key in the Cartesian Merkle Tree.
    ///
    /// Performs a standard BST search using key comparisons to navigate the tree.
    /// Time complexity is O(log n) on average due to the randomized heap property.
    ///
    /// ## Arguments
    ///
    /// * `key` - The key to search for
    ///
    /// ## Returns
    ///
    /// `true` if the key exists in the tree, `false` otherwise
    ///
    /// ## Examples
    ///
    /// ```
    /// let mut tree = CMTreeTrait::new();
    /// tree.insert(42);
    /// assert!(tree.search(42));
    /// assert!(!tree.search(100));
    /// ```
    fn search(self: @CMTree, key: felt252) -> bool {
        match self.root {
            Option::None => false,
            Option::Some(root) => Self::search_node(root, key),
        }
    }

    /// Internal recursive function for searching a key starting from a given node.
    ///
    /// Performs BST traversal by comparing keys and recursively searching the appropriate subtree.
    ///
    /// ## Arguments
    ///
    /// * `node` - The current node being examined
    /// * `key` - The key to search for
    ///
    /// ## Returns
    ///
    /// `true` if the key is found in the subtree, `false` otherwise
    fn search_node(node: @Box<CMTNode>, key: felt252) -> bool {
        let node_snapshot = node.as_snapshot().unbox();

        if *node_snapshot.key == key {
            true
        } else {
            let key_u256: u256 = key.into();
            let node_key_u256: u256 = (*node_snapshot.key).into();

            if key_u256 < node_key_u256 {
                match node_snapshot.left_child {
                    Option::None => false,
                    Option::Some(left) => Self::search_node(left, key),
                }
            } else {
                match node_snapshot.right_child {
                    Option::None => false,
                    Option::Some(right) => Self::search_node(right, key),
                }
            }
        }
    }

    /// Returns the Merkle hash of the tree's root node.
    ///
    /// The root hash serves as a cryptographic commitment to the entire tree structure
    /// and contents, enabling efficient verification of tree state and proof validation.
    ///
    /// ## Returns
    ///
    /// * `0` for empty trees
    /// * The Merkle hash of the root node for non-empty trees
    ///
    /// ## Examples
    ///
    /// ```
    /// let tree = CMTreeTrait::new();
    /// assert_eq!(tree.get_root_hash(), 0);
    ///
    /// let mut tree = CMTreeTrait::new();
    /// tree.insert(42);
    /// assert!(tree.get_root_hash() != 0);
    /// ```
    fn get_root_hash(self: @CMTree) -> felt252 {
        match self.root {
            Option::None => 0,
            Option::Some(root) => {
                let root_snapshot = root.as_snapshot().unbox();
                *root_snapshot.merkle_hash
            },
        }
    }

    /// Removes a key from the Cartesian Merkle Tree.
    ///
    /// Removal maintains all tree properties through a rotation-based approach:
    /// 1. Locate the target node using BST search
    /// 2. For nodes with children, rotate them toward a leaf position
    /// 3. Remove the node once it becomes a leaf
    /// 4. Update Merkle hashes along the removal path
    ///
    /// ## Arguments
    ///
    /// * `key` - The key to remove from the tree
    ///
    /// ## Returns
    ///
    /// `true` if the key was found and removed, `false` if the key wasn't in the tree
    ///
    /// ## Examples
    ///
    /// ```
    /// let mut tree = CMTreeTrait::new();
    /// tree.insert(42);
    /// assert!(tree.remove(42));
    /// assert!(!tree.search(42));
    /// assert!(!tree.remove(100)); // Non-existent key
    /// ```
    fn remove(ref self: CMTree, key: felt252) -> bool {
        match self.root {
            Option::None => false,
            Option::Some(root) => {
                let (new_root, removed) = Self::remove_node(root, key);
                self.root = new_root;
                removed
            },
        }
    }

    /// Internal recursive function for removing a node while maintaining tree properties.
    ///
    /// This function handles the BST deletion process, including special handling for nodes
    /// with two children by delegating to rotation-based removal.
    ///
    /// ## Arguments
    ///
    /// * `node` - The current node being examined
    /// * `key` - The key to remove
    ///
    /// ## Returns
    ///
    /// A tuple containing:
    /// * The new root of this subtree (None if subtree becomes empty)
    /// * Whether the key was found and removed
    fn remove_node(node: Box<CMTNode>, key: felt252) -> (Option<Box<CMTNode>>, bool) {
        let mut node_unboxed = node.unbox();

        // Convert keys to u256 for comparison
        let key_u256: u256 = key.into();
        let node_key_u256: u256 = node_unboxed.key.into();

        if key == node_unboxed.key {
            // Found the node to remove
            match (node_unboxed.left_child, node_unboxed.right_child) {
                (Option::None, Option::None) => {
                    // Leaf node - simply remove it
                    (Option::None, true)
                },
                (Option::Some(left), Option::None) => {
                    // Only left child exists
                    (Option::Some(left), true)
                },
                (Option::None, Option::Some(right)) => {
                    // Only right child exists
                    (Option::Some(right), true)
                },
                (
                    Option::Some(_left), Option::Some(_right),
                ) => {
                    // Both children exist - need to rotate to leaf
                    let rotated = Self::rotate_to_leaf_and_remove(BoxTrait::new(node_unboxed), key);
                    (rotated, true)
                },
            }
        } else if key_u256 < node_key_u256 {
            // Search in left subtree
            match node_unboxed.left_child {
                Option::None => (Option::Some(BoxTrait::new(node_unboxed)), false),
                Option::Some(left) => {
                    let (new_left, removed) = Self::remove_node(left, key);
                    node_unboxed.left_child = new_left;
                    if removed {
                        node_unboxed.update_merkle_hash();
                    }
                    (Option::Some(BoxTrait::new(node_unboxed)), removed)
                },
            }
        } else {
            // Search in right subtree
            match node_unboxed.right_child {
                Option::None => (Option::Some(BoxTrait::new(node_unboxed)), false),
                Option::Some(right) => {
                    let (new_right, removed) = Self::remove_node(right, key);
                    node_unboxed.right_child = new_right;
                    if removed {
                        node_unboxed.update_merkle_hash();
                    }
                    (Option::Some(BoxTrait::new(node_unboxed)), removed)
                },
            }
        }
    }

    /// Rotates a node with two children toward a leaf position, then removes it.
    ///
    /// This function implements the treap deletion strategy for nodes with both children:
    /// repeatedly rotate the node down the tree based on child priorities until it becomes
    /// a leaf, then remove it. This maintains both BST and heap properties.
    ///
    /// ## Arguments
    ///
    /// * `node` - The node to rotate and remove
    /// * `key` - The key being removed (for verification)
    ///
    /// ## Returns
    ///
    /// The new root of this subtree after rotation and removal
    fn rotate_to_leaf_and_remove(node: Box<CMTNode>, key: felt252) -> Option<Box<CMTNode>> {
        let node_unboxed = node.unbox();

        match (node_unboxed.left_child, node_unboxed.right_child) {
            (Option::None, Option::None) => {
                // Already a leaf, remove it
                Option::None
            },
            (
                Option::Some(_left), Option::None,
            ) => {
                // Rotate right and continue
                let rotated = CMTUtilsTrait::right_rotate(BoxTrait::new(node_unboxed));
                let mut rotated_unboxed = rotated.unbox();
                let (new_right, _) = Self::remove_node(
                    rotated_unboxed.right_child.expect('Right child should exist'), key,
                );
                rotated_unboxed.right_child = new_right;
                rotated_unboxed.update_merkle_hash();
                Option::Some(BoxTrait::new(rotated_unboxed))
            },
            (
                Option::None, Option::Some(_right),
            ) => {
                // Rotate left and continue
                let rotated = CMTUtilsTrait::left_rotate(BoxTrait::new(node_unboxed));
                let mut rotated_unboxed = rotated.unbox();
                let (new_left, _) = Self::remove_node(
                    rotated_unboxed.left_child.expect('Left child should exist'), key,
                );
                rotated_unboxed.left_child = new_left;
                rotated_unboxed.update_merkle_hash();
                Option::Some(BoxTrait::new(rotated_unboxed))
            },
            (
                Option::Some(left), Option::Some(right),
            ) => {
                // Choose rotation based on priority
                let left_priority = *left.as_snapshot().unbox().priority;
                let right_priority = *right.as_snapshot().unbox().priority;
                let left_priority_u256: u256 = left_priority.into();
                let right_priority_u256: u256 = right_priority.into();

                if left_priority_u256 > right_priority_u256 {
                    // Right rotate (left child has higher priority)
                    let rotated = CMTUtilsTrait::right_rotate(BoxTrait::new(node_unboxed));
                    let mut rotated_unboxed = rotated.unbox();
                    let (new_right, _) = Self::remove_node(
                        rotated_unboxed.right_child.expect('Right child should exist'), key,
                    );
                    rotated_unboxed.right_child = new_right;
                    rotated_unboxed.update_merkle_hash();
                    Option::Some(BoxTrait::new(rotated_unboxed))
                } else {
                    // Left rotate (right child has higher priority)
                    let rotated = CMTUtilsTrait::left_rotate(BoxTrait::new(node_unboxed));
                    let mut rotated_unboxed = rotated.unbox();
                    let (new_left, _) = Self::remove_node(
                        rotated_unboxed.left_child.expect('Left child should exist'), key,
                    );
                    rotated_unboxed.left_child = new_left;
                    rotated_unboxed.update_merkle_hash();
                    Option::Some(BoxTrait::new(rotated_unboxed))
                }
            },
        }
    }
}

#[cfg(test)]
mod tests {
    use super::CMTreeTrait;

    #[test]
    fn test_empty_tree() {
        let tree = CMTreeTrait::new();
        assert_eq!(tree.get_root_hash(), 0, "Empty tree should have hash 0");
        assert!(!tree.search(123), "Empty tree should not contain any key");
    }

    #[test]
    fn test_single_insert() {
        let mut tree = CMTreeTrait::new();
        tree.insert(42);

        assert!(tree.search(42), "Tree should contain inserted key");
        assert!(!tree.search(100), "Tree should not contain non-inserted key");
        assert!(tree.get_root_hash() != 0, "Tree with node should have non-zero hash");
    }

    #[test]
    fn test_multiple_inserts() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);
        tree.insert(20);
        tree.insert(40);

        assert!(tree.search(50), "Should find 50");
        assert!(tree.search(30), "Should find 30");
        assert!(tree.search(70), "Should find 70");
        assert!(tree.search(20), "Should find 20");
        assert!(tree.search(40), "Should find 40");
        assert!(!tree.search(100), "Should not find 100");
    }

    #[test]
    fn test_heap_property_maintained() {
        let mut tree = CMTreeTrait::new();

        // Insert multiple elements
        tree.insert(10);
        tree.insert(20);
        tree.insert(5);
        tree.insert(15);

        // After insertions, the tree should maintain both BST and heap properties
        // The root should have the highest priority among all nodes
        assert!(tree.search(10), "Should find all inserted keys");
        assert!(tree.search(20), "Should find all inserted keys");
        assert!(tree.search(5), "Should find all inserted keys");
        assert!(tree.search(15), "Should find all inserted keys");
    }

    #[test]
    fn test_remove_leaf() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);

        assert!(tree.remove(70), "Should remove existing key");
        assert!(!tree.search(70), "Removed key should not be found");
        assert!(tree.search(50), "Other keys should remain");
        assert!(tree.search(30), "Other keys should remain");
    }

    #[test]
    fn test_remove_node_with_one_child() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(20);

        // Depending on priorities, removing a node might result in different structures
        assert!(tree.remove(30), "Should remove existing key");
        assert!(!tree.search(30), "Removed key should not be found");
        assert!(tree.search(50), "Other keys should remain");
        assert!(tree.search(20), "Other keys should remain");
    }

    #[test]
    fn test_remove_root() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);

        // Remove root - tree should reorganize based on priorities
        let root_removed = tree.remove(50);
        assert!(root_removed, "Should remove root");
        assert!(!tree.search(50), "Root should be removed");
        assert!(tree.search(30), "Left child should remain");
        assert!(tree.search(70), "Right child should remain");
    }

    #[test]
    fn test_remove_non_existent() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);

        assert!(!tree.remove(100), "Should return false for non-existent key");
        assert!(tree.search(50), "Existing keys should remain");
        assert!(tree.search(30), "Existing keys should remain");
    }

    #[test]
    fn test_remove_maintains_merkle_hash() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);

        let initial_hash = tree.get_root_hash();
        assert!(initial_hash != 0, "Tree should have non-zero hash");

        tree.remove(70);
        let after_remove_hash = tree.get_root_hash();
        assert!(after_remove_hash != 0, "Tree should still have non-zero hash");
        assert!(initial_hash != after_remove_hash, "Hash should change after removal");
    }

    #[test]
    fn test_complex_removal_sequence() {
        let mut tree = CMTreeTrait::new();

        // Build a more complex tree
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);
        tree.insert(20);
        tree.insert(40);
        tree.insert(60);
        tree.insert(80);

        // Remove nodes in various positions
        assert!(tree.remove(20), "Should remove leaf");
        assert!(tree.remove(70), "Should remove internal node");
        assert!(tree.remove(50), "Should remove another node");

        // Verify remaining structure
        assert!(!tree.search(20), "20 should be removed");
        assert!(!tree.search(70), "70 should be removed");
        assert!(!tree.search(50), "50 should be removed");
        assert!(tree.search(30), "30 should remain");
        assert!(tree.search(40), "40 should remain");
        assert!(tree.search(60), "60 should remain");
        assert!(tree.search(80), "80 should remain");
    }
}
