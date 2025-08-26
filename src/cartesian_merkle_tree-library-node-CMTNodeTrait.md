# CMTNodeTrait

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[node](./cartesian_merkle_tree-library-node.md)::[CMTNodeTrait](./cartesian_merkle_tree-library-node-CMTNodeTrait.md)

<pre><code class="language-cairo">pub trait CMTNodeTrait</code></pre>

## Trait functions

### new

Creates a new CMT node with the specified key and priority.
The node is initialized with no children and a zero Merkle hash.
The hash should be updated using `update_merkle_hash()` after creation.
## Arguments

- `key` - The key value for this node
- `priority` - The priority value for heap ordering
## Returns

A new `CMTNode` with the specified key and priority
## Examples

```cairo
let key = 42;
let priority = CMTUtilsTrait::calculate_priority(key);
let node = CMTNodeTrait::new(key, priority);
assert_eq!(node.key, key);
assert_eq!(node.merkle_hash, 0);
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[node](./cartesian_merkle_tree-library-node.md)::[CMTNodeTrait](./cartesian_merkle_tree-library-node-CMTNodeTrait.md)::[new](./cartesian_merkle_tree-library-node-CMTNodeTrait.md#new)

<pre><code class="language-cairo">fn new(key: felt252, priority: felt252) -&gt; <a href="cartesian_merkle_tree-library-node-CMTNode.html">CMTNode</a></code></pre>


### new_with_children

Creates a new CMT node with the specified key, priority, and children.
The Merkle hash is automatically calculated based on the key and children hashes.
This is typically used during tree rotations or reconstruction.
## Arguments

- `key` - The key value for this node
- `priority` - The priority value for heap ordering
- `left_child` - Optional left child node
- `right_child` - Optional right child node
## Returns

A new `CMTNode` with calculated Merkle hash
## Examples

```cairo
let node = CMTNodeTrait::new_with_children(
    50, priority, Some(left_box), Some(right_box)
);
assert!(node.merkle_hash != 0);
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[node](./cartesian_merkle_tree-library-node.md)::[CMTNodeTrait](./cartesian_merkle_tree-library-node-CMTNodeTrait.md)::[new_with_children](./cartesian_merkle_tree-library-node-CMTNodeTrait.md#new_with_children)

<pre><code class="language-cairo">fn new_with_children(
    key: felt252,
    priority: felt252,
    left_child: Option&lt;Box&lt;CMTNode&gt;&gt;,
    right_child: Option&lt;Box&lt;CMTNode&gt;&gt;,
) -&gt; <a href="cartesian_merkle_tree-library-node-CMTNode.html">CMTNode</a></code></pre>


### update_merkle_hash

Updates the Merkle hash of this node based on its key and current children.
This method should be called whenever the node's children change to maintain
the cryptographic integrity of the tree. The hash is computed deterministically
using the node's key and its children's hashes.
## Examples

```cairo
let mut node = CMTNodeTrait::new(key, priority);
node.left_child = Some(left_child_box);
node.update_merkle_hash(); // Hash now reflects the new child
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[node](./cartesian_merkle_tree-library-node.md)::[CMTNodeTrait](./cartesian_merkle_tree-library-node-CMTNodeTrait.md)::[update_merkle_hash](./cartesian_merkle_tree-library-node-CMTNodeTrait.md#update_merkle_hash)

<pre><code class="language-cairo">fn update_merkle_hash(ref self: <a href="cartesian_merkle_tree-library-node-CMTNode.html">CMTNode</a>)</code></pre>


