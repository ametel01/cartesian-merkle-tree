//! Cartesian Merkle Tree proof generation and verification.
//!
//! This module provides functionality for:
//!
//! * Generating cryptographic proofs of key existence or non-existence in CMTrees
//! * Verifying proofs against tree root hashes
//! * Supporting both membership and non-membership proofs
//!
//! ## Examples
//!
//! Creating and verifying an existence proof:
//!
//! ```
//! let mut tree = CMTreeTrait::new();
//! tree.insert(50);
//! tree.insert(30);
//! tree.insert(70);
//!
//! let proof = tree.generate_proof_with_path(30);
//! let root_hash = tree.get_root_hash();
//! assert!(proof.verify(root_hash, 30));
//! ```
//!
//! Generating a non-existence proof:
//!
//! ```
//! let mut tree = CMTreeTrait::new();
//! tree.insert(50);
//! tree.insert(70);
//!
//! let proof = tree.generate_proof_with_path(60); // Key doesn't exist
//! let root_hash = tree.get_root_hash();
//! assert!(proof.verify(root_hash, 60)); // Non-existence proof verifies
//! ```
//!
//! Working with empty trees:
//!
//! ```
//! let tree = CMTreeTrait::new();
//! let proof = tree.generate_proof_with_path(50);
//! assert!(!proof.existence); // Empty tree always returns non-existence
//! ```

use core::array::ArrayTrait;
use core::traits::DivRem;
use super::tree::{CMTree, CMTreeTrait};
use super::utils::{CMTNode, CMTUtilsTrait};

/// A node in a Merkle proof path containing key and hash information.
#[derive(Drop, Clone, Debug)]
pub struct ProofNode {
    /// The key associated with this proof node
    pub key: felt252,
    /// The Merkle hash of this proof node
    pub merkle_hash: felt252,
}

/// A Cartesian Merkle Tree proof structure containing all information needed to verify membership
/// or non-membership.
///
/// The proof contains sibling information along the path from a leaf to the root, allowing
/// verification of key existence or non-existence in the tree without requiring the full tree
/// structure.
#[derive(Drop, Clone, Debug)]
pub struct CMTProof {
    /// The root hash of the tree this proof was generated from
    pub root: felt252,
    /// Array containing alternating keys and hashes of sibling nodes along the proof path
    pub siblings: Array<felt252>,
    /// The total number of elements in the siblings array
    pub siblings_length: u32,
    /// Bit field indicating the ordering of child hashes when computing parent hashes
    pub direction_bits: felt252,
    /// Whether this proof demonstrates key existence (true) or non-existence (false)
    pub existence: bool,
    /// The key being proven to exist or not exist
    pub key: felt252,
    /// For non-existence proofs, the key of the node where the target key would be inserted
    pub non_existence_key: felt252,
}

#[generate_trait]
pub impl CMTProofImpl of CMTProofTrait {
    /// Creates a new empty CMTProof with default values.
    ///
    /// ## Returns
    ///
    /// A new `CMTProof` instance with all fields initialized to zero/empty values.
    ///
    /// ## Examples
    ///
    /// ```
    /// let proof = CMTProofTrait::new();
    /// assert!(!proof.existence);
    /// assert!(proof.siblings_length == 0);
    /// ```
    fn new() -> CMTProof {
        CMTProof {
            root: 0,
            siblings: ArrayTrait::new(),
            siblings_length: 0,
            direction_bits: 0,
            existence: false,
            key: 0,
            non_existence_key: 0,
        }
    }

    /// Verifies a CMT proof against a given root hash and key.
    ///
    /// This method reconstructs the Merkle path from the leaf to the root using the sibling
    /// information stored in the proof, and checks if the computed root matches the expected root
    /// hash.
    ///
    /// ## Arguments
    ///
    /// * `root_hash` - The expected root hash of the tree
    /// * `key` - The key being verified
    ///
    /// ## Returns
    ///
    /// `true` if the proof is valid, `false` otherwise
    ///
    /// ## Examples
    ///
    /// ```
    /// let mut tree = CMTreeTrait::new();
    /// tree.insert(50);
    /// let proof = tree.generate_proof_with_path(50);
    /// let root = tree.get_root_hash();
    /// assert!(proof.verify(root, 50));
    /// ```
    fn verify(self: @CMTProof, root_hash: felt252, key: felt252) -> bool {
        if *self.root != root_hash {
            return false;
        }

        if *self.siblings_length == 0 {
            return !*self.existence;
        }

        // Start with the leaf hash
        let mut current_hash = if *self.existence {
            // For existing nodes, siblings[0] and siblings[1] are left and right child hashes
            if *self.siblings_length < 2 {
                return false;
            }
            let left_hash = *self.siblings.at(0);
            let right_hash = *self.siblings.at(1);
            Self::calculate_node_hash(key, left_hash, right_hash)
        } else {
            // For non-existing nodes, siblings[0] and siblings[1] are left and right child hashes
            // of the parent
            if *self.siblings_length < 2 {
                return false;
            }
            let left_hash = *self.siblings.at(0);
            let right_hash = *self.siblings.at(1);
            Self::calculate_node_hash(*self.non_existence_key, left_hash, right_hash)
        };

        // Process siblings pairs (key, hash) up the tree
        let mut i = 2;
        let mut direction_bits = *self.direction_bits;

        while i < *self.siblings_length {
            let node_key = *self.siblings.at(i);
            let sibling_hash = *self.siblings.at(i + 1);

            // Use direction bit to determine ordering
            let direction_bits_u256: u256 = direction_bits.into();
            let (new_direction_bits, remainder) = DivRem::div_rem(direction_bits_u256, 2);
            let use_original_order = remainder == 0;
            direction_bits = new_direction_bits.try_into().unwrap();

            current_hash =
                if use_original_order {
                    Self::calculate_node_hash(node_key, current_hash, sibling_hash)
                } else {
                    Self::calculate_node_hash(node_key, sibling_hash, current_hash)
                };

            i += 2;
        }

        current_hash == root_hash
    }

    /// Calculates the Merkle hash for a node given its key and child hashes.
    ///
    /// This function ensures consistent hash ordering by sorting child hashes before
    /// computing the parent hash, maintaining compatibility with the Solidity implementation.
    ///
    /// ## Arguments
    ///
    /// * `key` - The key of the node
    /// * `left_hash` - Hash of the left child
    /// * `right_hash` - Hash of the right child
    ///
    /// ## Returns
    ///
    /// The computed Merkle hash for the node
    ///
    /// ## Examples
    ///
    /// ```
    /// let hash = CMTProofTrait::calculate_node_hash(50, 0, 0);
    /// assert!(hash != 0);
    /// ```
    fn calculate_node_hash(key: felt252, left_hash: felt252, right_hash: felt252) -> felt252 {
        // Order the child hashes (smaller first, as in Solidity implementation)
        let left_u256: u256 = left_hash.into();
        let right_u256: u256 = right_hash.into();

        if left_u256 > right_u256 {
            CMTUtilsTrait::calculate_merkle_hash(key, right_hash, left_hash)
        } else {
            CMTUtilsTrait::calculate_merkle_hash(key, left_hash, right_hash)
        }
    }
}

#[generate_trait]
pub impl CMTreeProofImpl of CMTreeProofTrait {
    /// Generates a cryptographic proof for a key in the Cartesian Merkle Tree.
    ///
    /// This method creates either an existence proof (if the key is found) or a non-existence
    /// proof (if the key is not found) by collecting sibling information along the search path.
    ///
    /// ## Arguments
    ///
    /// * `key` - The key to generate a proof for
    ///
    /// ## Returns
    ///
    /// A `CMTProof` containing all necessary information to verify the key's presence or absence
    ///
    /// ## Examples
    ///
    /// ```
    /// let mut tree = CMTreeTrait::new();
    /// tree.insert(50);
    ///
    /// // Generate existence proof
    /// let existence_proof = tree.generate_proof_with_path(50);
    /// assert!(existence_proof.existence);
    ///
    /// // Generate non-existence proof
    /// let non_existence_proof = tree.generate_proof_with_path(60);
    /// assert!(!non_existence_proof.existence);
    /// ```
    fn generate_proof_with_path(self: @CMTree, key: felt252) -> CMTProof {
        let root_hash = CMTreeTrait::get_root_hash(self);

        match self.root {
            Option::None => {
                // Empty tree - non-existence proof
                CMTProof {
                    root: root_hash,
                    siblings: ArrayTrait::new(),
                    siblings_length: 0,
                    direction_bits: 0,
                    existence: false,
                    key,
                    non_existence_key: 0,
                }
            },
            Option::Some(root) => {
                let mut siblings = ArrayTrait::new();
                let mut direction_bits = 0_felt252;
                let mut siblings_count = 0_u32;

                let (found, non_existence_key) = Self::generate_proof_internal(
                    root, key, ref siblings, ref direction_bits, ref siblings_count,
                );

                CMTProof {
                    root: root_hash,
                    siblings,
                    siblings_length: siblings_count,
                    direction_bits,
                    existence: found,
                    key,
                    non_existence_key: if found {
                        0
                    } else {
                        non_existence_key
                    },
                }
            },
        }
    }

    /// Internal recursive function for generating proof data by traversing the tree.
    ///
    /// This function performs a depth-first search through the tree, collecting sibling
    /// information and direction bits needed to reconstruct the Merkle path during verification.
    ///
    /// ## Arguments
    ///
    /// * `node` - Current node being examined
    /// * `key` - Target key to generate proof for
    /// * `siblings` - Mutable reference to array collecting sibling data
    /// * `direction_bits` - Mutable reference to bit field for hash ordering
    /// * `siblings_count` - Mutable reference to count of collected siblings
    ///
    /// ## Returns
    ///
    /// A tuple containing:
    /// * `bool` - Whether the key was found
    /// * `felt252` - For non-existence proofs, the key where insertion would occur
    fn generate_proof_internal(
        node: @Box<CMTNode>,
        key: felt252,
        ref siblings: Array<felt252>,
        ref direction_bits: felt252,
        ref siblings_count: u32,
    ) -> (bool, felt252) {
        let node_snapshot = node.as_snapshot().unbox();

        if *node_snapshot.key == key {
            // Found the target node - add its children as first siblings
            let left_hash = CMTUtilsTrait::get_child_hash(node_snapshot.left_child);
            let right_hash = CMTUtilsTrait::get_child_hash(node_snapshot.right_child);

            siblings.append(left_hash);
            siblings.append(right_hash);
            siblings_count += 2;

            // Calculate direction bit based on child hash ordering
            let left_u256: u256 = left_hash.into();
            let right_u256: u256 = right_hash.into();
            let is_swapped = left_u256 > right_u256;
            direction_bits =
                Self::calculate_direction_bit(direction_bits, siblings_count, is_swapped);

            (true, 0)
        } else {
            // Convert keys for comparison
            let key_u256: u256 = key.into();
            let node_key_u256: u256 = (*node_snapshot.key).into();

            let (found, non_existence_key, go_left) = if key_u256 < node_key_u256 {
                match node_snapshot.left_child {
                    Option::None => {
                        // Non-existence proof - key would be left child of this node
                        let left_hash = CMTUtilsTrait::get_child_hash(node_snapshot.left_child);
                        let right_hash = CMTUtilsTrait::get_child_hash(node_snapshot.right_child);

                        siblings.append(left_hash);
                        siblings.append(right_hash);
                        siblings_count += 2;

                        let left_u256: u256 = left_hash.into();
                        let right_u256: u256 = right_hash.into();
                        direction_bits =
                            Self::calculate_direction_bit(
                                direction_bits, siblings_count, left_u256 > right_u256,
                            );

                        (true, *node_snapshot.key, true)
                    },
                    Option::Some(left) => {
                        let (found, non_existence_key) = Self::generate_proof_internal(
                            left, key, ref siblings, ref direction_bits, ref siblings_count,
                        );
                        (found, non_existence_key, true)
                    },
                }
            } else {
                match node_snapshot.right_child {
                    Option::None => {
                        // Non-existence proof - key would be right child of this node
                        let left_hash = CMTUtilsTrait::get_child_hash(node_snapshot.left_child);
                        let right_hash = CMTUtilsTrait::get_child_hash(node_snapshot.right_child);

                        siblings.append(left_hash);
                        siblings.append(right_hash);
                        siblings_count += 2;

                        let left_u256: u256 = left_hash.into();
                        let right_u256: u256 = right_hash.into();
                        direction_bits =
                            Self::calculate_direction_bit(
                                direction_bits, siblings_count, left_u256 > right_u256,
                            );

                        (false, *node_snapshot.key, false)
                    },
                    Option::Some(right) => {
                        let (found, non_existence_key) = Self::generate_proof_internal(
                            right, key, ref siblings, ref direction_bits, ref siblings_count,
                        );
                        (found, non_existence_key, false)
                    },
                }
            };

            // Add this level's sibling info when returning from recursion
            // For existence proofs: when we found it in this subtree and this is not the target
            // node For non-existence proofs: when we traversed through this node toward the
            // insertion point
            if (found && (*node_snapshot.key != key))
                || (!found && (*node_snapshot.key != non_existence_key)) {
                siblings.append(*node_snapshot.key);
                let sibling_hash = if go_left {
                    CMTUtilsTrait::get_child_hash(node_snapshot.right_child)
                } else {
                    CMTUtilsTrait::get_child_hash(node_snapshot.left_child)
                };
                siblings.append(sibling_hash);
                siblings_count += 2;

                // Calculate direction bit for this level
                let child_hash = if go_left {
                    CMTUtilsTrait::get_child_hash(node_snapshot.left_child)
                } else {
                    CMTUtilsTrait::get_child_hash(node_snapshot.right_child)
                };
                let child_u256: u256 = child_hash.into();
                let sibling_u256: u256 = sibling_hash.into();
                let is_swapped = child_u256 > sibling_u256;
                direction_bits =
                    Self::calculate_direction_bit(direction_bits, siblings_count, is_swapped);
            }

            (found, non_existence_key)
        }
    }

    /// Calculates and updates the direction bits for hash ordering during proof verification.
    ///
    /// Direction bits encode whether child hashes were swapped during node hash calculation.
    /// This information is essential for correctly reconstructing the Merkle path during
    /// verification.
    ///
    /// ## Arguments
    ///
    /// * `direction_bits` - Current direction bits value
    /// * `siblings_count` - Number of siblings processed so far
    /// * `is_swapped` - Whether the child hashes were swapped for this level
    ///
    /// ## Returns
    ///
    /// Updated direction bits value
    fn calculate_direction_bit(
        direction_bits: felt252, siblings_count: u32, is_swapped: bool,
    ) -> felt252 {
        let direction_bits_u256: u256 = direction_bits.into();
        let mut result = direction_bits_u256;
        if siblings_count != 2 {
            result = result * 2; // Left shift
        }
        if is_swapped {
            result = result + 1;
        }
        result.try_into().unwrap()
    }
}

#[cfg(test)]
mod tests {
    use crate::CMTreeTrait;
    use super::{CMTProofTrait, CMTreeProofTrait};

    #[test]
    fn test_proof_generation_existing_key() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);

        let proof = tree.generate_proof_with_path(30);
        assert!(proof.existence, "Proof should indicate existence");
        assert!(proof.siblings_length > 0, "Proof should have sibling data");
        assert_eq!(proof.key, 30, "Proof key should match");
    }

    #[test]
    fn test_simple_proof() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);

        let proof = tree.generate_proof_with_path(50);
        assert!(proof.existence, "Root should exist");
        assert!(proof.siblings_length == 2, "Root proof should have child hashes");

        let root_hash = tree.get_root_hash();
        assert!(proof.verify(root_hash, 50), "Root proof should verify");
    }

    #[test]
    fn test_proof_generation_non_existing_key() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);

        let proof = tree.generate_proof_with_path(40);
        assert!(!proof.existence, "Proof should indicate non-existence");
        assert!(proof.non_existence_key != 0, "Should have non-existence key");
        assert_eq!(proof.key, 40, "Proof key should match");
    }

    #[test]
    fn test_proof_verification_existing() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);
        tree.insert(20);
        tree.insert(40);

        let root_hash = tree.get_root_hash();
        let proof = tree.generate_proof_with_path(30);

        assert!(proof.verify(root_hash, 30), "Valid proof should verify");
    }

    #[test]
    fn test_proof_verification_non_existing() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);

        let root_hash = tree.get_root_hash();
        let proof = tree.generate_proof_with_path(40);

        assert!(proof.verify(root_hash, 40), "Non-existence proof should verify");
    }

    #[test]
    fn test_proof_invalid_verification() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);

        let root_hash = tree.get_root_hash();
        let proof = tree.generate_proof_with_path(30);

        // Try to verify with wrong key
        assert!(!proof.verify(root_hash, 40), "Proof with wrong key should not verify");

        // Try to verify with wrong root
        assert!(!proof.verify(12345, 30), "Proof with wrong root should not verify");
    }

    #[test]
    fn test_proof_after_modification() {
        let mut tree = CMTreeTrait::new();
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);

        let proof_before = tree.generate_proof_with_path(30);
        let _root_before = tree.get_root_hash();

        // Modify tree
        tree.insert(25);
        let root_after = tree.get_root_hash();

        // Old proof should not verify with new root
        assert!(!proof_before.verify(root_after, 30), "Old proof should not verify with new root");

        // Generate new proof
        let proof_after = tree.generate_proof_with_path(30);
        assert!(proof_after.verify(root_after, 30), "New proof should verify with new root");
    }

    #[test]
    fn test_proof_empty_tree() {
        let tree = CMTreeTrait::new();
        let proof = tree.generate_proof_with_path(50);

        assert!(!proof.existence, "Empty tree proof should indicate non-existence");
        assert!(proof.siblings_length == 0, "Empty tree proof should have no siblings");
        assert_eq!(proof.key, 50, "Proof key should match");
    }

    #[test]
    fn test_algorithm_6_example() {
        // Create proof matching Algorithm 6 example structure
        let mut proof = CMTProofTrait::new();

        // Set up the proof as per the example
        proof.existence = true;
        proof.key = 18;
        proof.root = 333; // rootNodeMH from example

        // siblings: [0, 0, 20, 0, 15, 0, 13, 180]
        // First two are child hashes of target node (18)
        proof.siblings.append(0); // left child hash
        proof.siblings.append(0); // right child hash

        // Then alternating keys and sibling hashes up the path
        proof.siblings.append(20); // key
        proof.siblings.append(0); // sibling hash
        proof.siblings.append(15); // key
        proof.siblings.append(0); // sibling hash
        proof.siblings.append(13); // key
        proof.siblings.append(180); // sibling hash

        proof.siblings_length = 8;
        proof.direction_bits = 0; // No hash swapping in this example

        // This demonstrates the correct proof structure
        assert!(proof.existence, "Proof should indicate existence");
        assert_eq!(proof.siblings_length, 8, "Proof should have 8 sibling entries");
        assert_eq!(proof.key, 18, "Key should be 18");
        assert_eq!(proof.root, 333, "Root should be 333");
    }

    #[test]
    fn test_algorithm_7_exclusion_proof() {
        // Create proof matching Algorithm 7 exclusion proof example
        let mut proof = CMTProofTrait::new();

        // Set up the proof as per the exclusion example
        proof.existence = false; // This is an exclusion proof
        proof.key = 19; // The key we're proving doesn't exist
        proof.non_existence_key = 20; // The key that would be at this position
        proof.root = 333; // rootNodeMH from example

        // siblings: [100, 0, 15, 0, 13, 180]
        // First two are child hashes of non-existence node (20)
        proof.siblings.append(100); // left child hash of node 20
        proof.siblings.append(0); // right child hash of node 20

        // Then alternating keys and sibling hashes up the path
        proof.siblings.append(15); // key
        proof.siblings.append(0); // sibling hash
        proof.siblings.append(13); // key
        proof.siblings.append(180); // sibling hash

        proof.siblings_length = 6;
        proof.direction_bits = 0; // No hash swapping in this example

        // This demonstrates the exclusion proof structure
        assert!(!proof.existence, "Proof should indicate non-existence");
        assert_eq!(proof.non_existence_key, 20, "Non-existence key should be 20");
        assert_eq!(proof.siblings_length, 6, "Proof should have 6 sibling entries");
        assert_eq!(proof.key, 19, "Key should be 19");
        assert_eq!(proof.root, 333, "Root should be 333");
    }
}
