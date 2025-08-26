# proof

Cartesian Merkle Tree proof generation and verification.
This module provides functionality for:
- Generating cryptographic proofs of key existence or non-existence in CMTrees
- Verifying proofs against tree root hashes
- Supporting both membership and non-membership proofs
## Examples

Creating and verifying an existence proof:
```cairo
let mut tree = CMTreeTrait::new();
tree.insert(50);
tree.insert(30);
tree.insert(70);

let proof = tree.generate_proof_with_path(30);
let root_hash = tree.get_root_hash();
assert!(proof.verify(root_hash, 30));
```

Generating a non-existence proof:
```cairo
let mut tree = CMTreeTrait::new();
tree.insert(50);
tree.insert(70);

let proof = tree.generate_proof_with_path(60); // Key doesn't exist
let root_hash = tree.get_root_hash();
assert!(proof.verify(root_hash, 60)); // Non-existence proof verifies
```

Working with empty trees:
```cairo
let tree = CMTreeTrait::new();
let proof = tree.generate_proof_with_path(50);
assert!(!proof.existence); // Empty tree always returns non-existence
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)


## [Structs](./cartesian_merkle_tree-proof-structs.md)

| | |
|:---|:---|
| [ProofNode](./cartesian_merkle_tree-proof-ProofNode.md) | A node in a Merkle proof path containing key and hash information. |
| [CMTProof](./cartesian_merkle_tree-proof-CMTProof.md) | A Cartesian Merkle Tree proof structure containing all information needed to verify membership or non-membership.... |

## [Traits](./cartesian_merkle_tree-proof-traits.md)

| | |
|:---|:---|
| [CMTProofTrait](./cartesian_merkle_tree-proof-CMTProofTrait.md) | — |
| [CMTreeProofTrait](./cartesian_merkle_tree-proof-CMTreeProofTrait.md) | — |

## [Impls](./cartesian_merkle_tree-proof-impls.md)

| | |
|:---|:---|
| [CMTProofImpl](./cartesian_merkle_tree-proof-CMTProofImpl.md) | — |
| [CMTreeProofImpl](./cartesian_merkle_tree-proof-CMTreeProofImpl.md) | — |
