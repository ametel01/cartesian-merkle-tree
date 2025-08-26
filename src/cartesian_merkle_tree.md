# cartesian_merkle_tree

Cartesian Merkle Tree Library
This library provides a complete implementation of Cartesian Merkle Trees with both
in-memory and on-chain (Starknet component) capabilities.
## Core Library

The in-memory implementation consists of:
- Tree operations (insert, remove, search)
- Cryptographic proof generation and verification
- Utility functions for node management and hashing
## Starknet Component

The on-chain component provides:
- Storage-based tree implementation
- All core tree operations as contract functions
- Gas-optimized index management with reuse
## Usage Examples
### In-Memory Tree

```cairo
use cartesian_merkle_tree::{CMTree, CMTreeTrait};

let mut tree = CMTreeTrait::new();
tree.insert(42);
assert!(tree.search(42));

let proof = tree.generate_proof(42);
let root = tree.get_root_hash();
assert!(proof.verify(root, 42));
```
### Starknet Component

```cairo
use cartesian_merkle_tree::components::cmtree_component;

#[starknet::contract]
mod MyContract {
    component!(path: cmtree_component, storage: tree, event: TreeEvent);

    #[abi(embed_v0)]
    impl CMTreeImpl = cmtree_component::CMTree<ContractState>;
}
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)


## [Modules](./cartesian_merkle_tree-modules.md)

| | |
|:---|:---|
| [library](./cartesian_merkle_tree-library.md) | — |
| [components](./cartesian_merkle_tree-components.md) | — |


---
 
# Re-exports: 

 - ### Structs

| | |
|:---|:---|
| [CMTNode](./cartesian_merkle_tree-library-node-CMTNode.md) | A node in the Cartesian Merkle Tree containing key, priority, hash, and child references. Each node maintains the three essential properties of the CMT:... |
| [CMTProof](./cartesian_merkle_tree-library-proof-CMTProof.md) | A Cartesian Merkle Tree proof structure containing all information needed to verify membership or non-membership.... |
| [ProofNode](./cartesian_merkle_tree-library-proof-ProofNode.md) | A node in a Merkle proof path containing key and hash information. |
| [CMTree](./cartesian_merkle_tree-library-tree-CMTree.md) | A Cartesian Merkle Tree combining binary search tree, heap, and Merkle tree properties. The tree maintains three invariants simultaneously: 1. BST Property : Left subtree keys <  node key <... |

<br>


 - ### Traits

| | |
|:---|:---|
| [CMTNodeTrait](./cartesian_merkle_tree-library-node-CMTNodeTrait.md) | — |
| [CMTProofTrait](./cartesian_merkle_tree-library-proof-CMTProofTrait.md) | — |
| [CMTreeProofTrait](./cartesian_merkle_tree-library-proof-CMTreeProofTrait.md) | — |
| [CMTreeTrait](./cartesian_merkle_tree-library-tree-CMTreeTrait.md) | — |
| [CMTUtilsTrait](./cartesian_merkle_tree-library-utils-CMTUtilsTrait.md) | — |

<br>

