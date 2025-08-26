# utils

Utility functions for Cartesian Merkle Trees.
This module provides the core utility functions for CMT operations:
- Priority calculation using cryptographic hashing
- Merkle hash computation with consistent ordering
- Tree rotation operations for maintaining heap property
- Helper functions for child node management

The utilities ensure deterministic behavior and cryptographic security through
the use of Poseidon hashing for both priorities and Merkle commitments.
## Examples

Computing priorities:
```cairo
let key = 42;
let priority = CMTUtilsTrait::calculate_priority(key);
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

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[utils](./cartesian_merkle_tree-library-utils.md)


## [Traits](./cartesian_merkle_tree-library-utils-traits.md)

| | |
|:---|:---|
| [CMTUtilsTrait](./cartesian_merkle_tree-library-utils-CMTUtilsTrait.md) | — |

## [Impls](./cartesian_merkle_tree-library-utils-impls.md)

| | |
|:---|:---|
| [CMTUtilsImpl](./cartesian_merkle_tree-library-utils-CMTUtilsImpl.md) | — |
