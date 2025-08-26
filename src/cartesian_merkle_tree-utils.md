# utils

Utility functions and data structures for Cartesian Merkle Trees.
This module provides the core building blocks for CMT operations:
- Node structure representing individual tree elements
- Priority calculation using cryptographic hashing
- Merkle hash computation with consistent ordering
- Tree rotation operations for maintaining heap property
- Helper functions for child node management

The utilities ensure deterministic behavior and cryptographic security through
the use of Poseidon hashing for both priorities and Merkle commitments.
## Examples

Creating and managing nodes:
```cairo
let key = 42;
let priority = CMTUtilsTrait::calculate_priority(key);
let mut node = CMTNodeTrait::new(key, priority);
node.update_merkle_hash();
```

Computing Merkle hashes:
```cairo
let hash = CMTUtilsTrait::calculate_merkle_hash(key, left_hash, right_hash);
assert!(hash != 0);
```

Performing tree rotations:
```cairo
let rotated = CMTUtilsTrait::right_rotate(node_box);
// Tree structure is now rotated while maintaining properties
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)


## [Structs](./cartesian_merkle_tree-utils-structs.md)

| | |
|:---|:---|
| [CMTNode](./cartesian_merkle_tree-utils-CMTNode.md) | A node in the Cartesian Merkle Tree containing key, priority, hash, and child references. Each node maintains the three essential properties of the CMT:... |
| [CMTUtils](./cartesian_merkle_tree-utils-CMTUtils.md) | Utility struct providing static helper functions for Cartesian Merkle Tree operations. |

## [Traits](./cartesian_merkle_tree-utils-traits.md)

| | |
|:---|:---|
| [CMTNodeTrait](./cartesian_merkle_tree-utils-CMTNodeTrait.md) | — |
| [CMTUtilsTrait](./cartesian_merkle_tree-utils-CMTUtilsTrait.md) | — |

## [Impls](./cartesian_merkle_tree-utils-impls.md)

| | |
|:---|:---|
| [CMTNodeImpl](./cartesian_merkle_tree-utils-CMTNodeImpl.md) | — |
| [CMTUtilsImpl](./cartesian_merkle_tree-utils-CMTUtilsImpl.md) | — |
