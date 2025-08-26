# CMTUtilsTrait

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTUtilsTrait](./cartesian_merkle_tree-utils-CMTUtilsTrait.md)

<pre><code class="language-cairo">pub trait CMTUtilsTrait</code></pre>

## Trait functions

### calculate_priority

Calculates a deterministic priority for a given key using Poseidon hashing.
The priority is used to maintain the heap property in the treap structure.
Using cryptographic hashing ensures the priorities are effectively randomized
while remaining deterministic for the same key.
## Arguments

- `key` - The key to calculate priority for
## Returns

A `felt252` priority value derived from the key
## Examples

```cairo
let priority1 = CMTUtilsTrait::calculate_priority(42);
let priority2 = CMTUtilsTrait::calculate_priority(42);
assert_eq!(priority1, priority2); // Deterministic

let priority3 = CMTUtilsTrait::calculate_priority(43);
assert!(priority1 != priority3); // Different keys give different priorities
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTUtilsTrait](./cartesian_merkle_tree-utils-CMTUtilsTrait.md)::[calculate_priority](./cartesian_merkle_tree-utils-CMTUtilsTrait.md#calculate_priority)

<pre><code class="language-cairo">fn calculate_priority(key: felt252) -&gt; felt252</code></pre>


### calculate_merkle_hash

Calculates the Merkle hash for a node given its key and children hashes.
The hash is computed using Poseidon with consistent ordering: the key is hashed first,
followed by the children hashes in sorted order (smaller hash first). This ensures
deterministic hashing regardless of the tree's structure.
## Arguments

- `key` - The key of the node
- `left_child_mh` - Merkle hash of the left child (0 if None)
- `right_child_mh` - Merkle hash of the right child (0 if None)
## Returns

The computed Merkle hash for the node
## Examples

```cairo
let hash = CMTUtilsTrait::calculate_merkle_hash(50, 100, 200);
assert!(hash != 0);

// Hash is independent of child order
let same_hash = CMTUtilsTrait::calculate_merkle_hash(50, 200, 100);
assert_eq!(hash, same_hash);
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTUtilsTrait](./cartesian_merkle_tree-utils-CMTUtilsTrait.md)::[calculate_merkle_hash](./cartesian_merkle_tree-utils-CMTUtilsTrait.md#calculate_merkle_hash)

<pre><code class="language-cairo">fn calculate_merkle_hash(key: felt252, left_child_mh: felt252, right_child_mh: felt252) -&gt; felt252</code></pre>


### get_child_hash

Extracts the Merkle hash from an optional child node.
This helper function safely retrieves the hash from a child node reference,
returning 0 for None children (representing empty subtrees).
## Arguments

- `child` - Reference to an optional boxed child node
## Returns

The child's Merkle hash, or 0 if the child is None
## Examples

```cairo
let hash = CMTUtilsTrait::get_child_hash(@Some(child_box));
let zero_hash = CMTUtilsTrait::get_child_hash(@Option::None);
assert_eq!(zero_hash, 0);
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTUtilsTrait](./cartesian_merkle_tree-utils-CMTUtilsTrait.md)::[get_child_hash](./cartesian_merkle_tree-utils-CMTUtilsTrait.md#get_child_hash)

<pre><code class="language-cairo">fn get_child_hash(child: Option&lt;Box&lt;CMTNode&gt;&gt;) -&gt; felt252</code></pre>


### right_rotate

Performs a right rotation on the given node to maintain heap property.
Right rotation moves the left child up to become the new root of this subtree,
with the original node becoming the right child. This operation maintains both
BST ordering and is used to restore heap property when needed.
```cairo
    X                    Y
   / \    right_rotate  / \
  Y   C   ----------->  A   X
 / \                       / \
 A   B                     B   C
```
## Arguments

- `node` - The node to rotate (becomes right child after rotation)
## Returns

The new root of the subtree (originally the left child)
## Panics

Panics if the node has no left child
## Examples

```cairo
let rotated = CMTUtilsTrait::right_rotate(node_box);
// Tree structure is now rotated while preserving BST and heap properties
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTUtilsTrait](./cartesian_merkle_tree-utils-CMTUtilsTrait.md)::[right_rotate](./cartesian_merkle_tree-utils-CMTUtilsTrait.md#right_rotate)

<pre><code class="language-cairo">fn right_rotate(node: Box&lt;CMTNode&gt;) -&gt; Box&lt;CMTNode&gt;</code></pre>


### left_rotate

Performs a left rotation on the given node to maintain heap property.
Left rotation moves the right child up to become the new root of this subtree,
with the original node becoming the left child. This operation maintains both
BST ordering and is used to restore heap property when needed.
```cairo
  X                        Y
 / \      left_rotate     / \
A   Y     ----------->   X   C
   / \                  / \
  B   C                A   B
```
## Arguments

- `node` - The node to rotate (becomes left child after rotation)
## Returns

The new root of the subtree (originally the right child)
## Panics

Panics if the node has no right child
## Examples

```cairo
let rotated = CMTUtilsTrait::left_rotate(node_box);
// Tree structure is now rotated while preserving BST and heap properties
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTUtilsTrait](./cartesian_merkle_tree-utils-CMTUtilsTrait.md)::[left_rotate](./cartesian_merkle_tree-utils-CMTUtilsTrait.md#left_rotate)

<pre><code class="language-cairo">fn left_rotate(node: Box&lt;CMTNode&gt;) -&gt; Box&lt;CMTNode&gt;</code></pre>


