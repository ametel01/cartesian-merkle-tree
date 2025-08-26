//! Cartesian Merkle Tree Library
//!
//! This library provides a complete implementation of Cartesian Merkle Trees with both
//! in-memory and on-chain (Starknet component) capabilities.
//!
//! ## Core Library
//!
//! The in-memory implementation consists of:
//! - Tree operations (insert, remove, search)
//! - Cryptographic proof generation and verification
//! - Utility functions for node management and hashing
//!
//! ## Starknet Component
//!
//! The on-chain component provides:
//! - Storage-based tree implementation
//! - All core tree operations as contract functions
//! - Gas-optimized index management with reuse
//!
//! ## Usage Examples
//!
//! ### In-Memory Tree
//! ```cairo
//! use cartesian_merkle_tree::{CMTree, CMTreeTrait};
//!
//! let mut tree = CMTreeTrait::new();
//! tree.insert(42);
//! assert!(tree.search(42));
//!
//! let proof = tree.generate_proof(42);
//! let root = tree.get_root_hash();
//! assert!(proof.verify(root, 42));
//! ```
//!
//! ### Starknet Component
//! ```cairo
//! use cartesian_merkle_tree::components::cmtree_component;
//!
//! #[starknet::contract]
//! mod MyContract {
//!     component!(path: cmtree_component, storage: tree, event: TreeEvent);
//!
//!     #[abi(embed_v0)]
//!     impl CMTreeImpl = cmtree_component::CMTree<ContractState>;
//! }
//! ```

// Core library modules
pub mod library {
    pub mod proof;
    pub mod tree;
    pub mod utils;
}

// Starknet integration
pub mod components {
    pub mod cmtree_component;

    #[cfg(test)]
    pub mod contract_example;
}
pub use library::proof::{CMTProof, CMTProofTrait, CMTreeProofTrait, ProofNode};
pub use library::tree::{CMTree, CMTreeTrait};

// Re-export main types and traits for easy access
pub use library::utils::{CMTNode, CMTNodeTrait, CMTUtilsTrait};
