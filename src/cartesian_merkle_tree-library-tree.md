# tree

Cartesian Merkle Tree implementation combining BST and heap properties.
This module provides a complete implementation of a Cartesian Merkle Tree, which is:
- A binary search tree ordered by keys
- A heap ordered by priorities (randomized based on keys)
- A Merkle tree with cryptographic hash verification
- Self-balancing through treap rotations

The structure maintains logarithmic time complexity for insertions, deletions, and searches
while providing cryptographic proof capabilities through Merkle hashes.
## Examples

Creating and using a new tree:
```cairo
let mut tree = CMTreeTrait::new();
tree.insert(50);
tree.insert(30);
tree.insert(70);

assert!(tree.search(50));
let root_hash = tree.get_root_hash();
```

Working with multiple operations:
```cairo
let mut tree = CMTreeTrait::new();
tree.insert(10);
tree.insert(20);
tree.insert(5);

assert!(tree.remove(10));
assert!(!tree.search(10));
assert!(tree.search(20));
```

Getting cryptographic verification:
```cairo
let mut tree = CMTreeTrait::new();
tree.insert(42);
let hash = tree.get_root_hash();
assert!(hash != 0); // Non-empty tree has non-zero hash
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[tree](./cartesian_merkle_tree-library-tree.md)


## [Structs](./cartesian_merkle_tree-library-tree-structs.md)

| | |
|:---|:---|
| [CMTree](./cartesian_merkle_tree-library-tree-CMTree.md) | A Cartesian Merkle Tree combining binary search tree, heap, and Merkle tree properties. The tree maintains three invariants simultaneously: 1. BST Property : Left subtree keys <  node key <... |

## [Traits](./cartesian_merkle_tree-library-tree-traits.md)

| | |
|:---|:---|
| [CMTreeTrait](./cartesian_merkle_tree-library-tree-CMTreeTrait.md) | — |

## [Impls](./cartesian_merkle_tree-library-tree-impls.md)

| | |
|:---|:---|
| [CMTreeImpl](./cartesian_merkle_tree-library-tree-CMTreeImpl.md) | — |
