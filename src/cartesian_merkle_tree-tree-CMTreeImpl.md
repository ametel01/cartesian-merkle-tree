# CMTreeImpl

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)

<pre><code class="language-cairo">pub impl CMTreeImpl of CMTreeTrait;</code></pre>

## Impl functions

### new

Creates a new empty Cartesian Merkle Tree.
## Returns

An empty `CMTree` with no root node
## Examples

```cairo
let tree = CMTreeTrait::new();
assert_eq!(tree.get_root_hash(), 0);
assert!(!tree.search(42));
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[new](./cartesian_merkle_tree-tree-CMTreeImpl.md#new)

<pre><code class="language-cairo">fn new() -&gt; <a href="cartesian_merkle_tree-tree-CMTree.html">CMTree</a></code></pre>


### insert

Inserts a key into the Cartesian Merkle Tree.
The insertion maintains all three tree properties (BST, heap, Merkle) through:
1. BST insertion based on key comparison
2. Treap rotations to maintain heap property based on priority
3. Merkle hash updates for cryptographic integrity

Priority is deterministically calculated from the key, ensuring consistent tree structure.
## Arguments

- `key` - The key to insert into the tree
## Examples

```cairo
let mut tree = CMTreeTrait::new();
tree.insert(42);
assert!(tree.search(42));
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[insert](./cartesian_merkle_tree-tree-CMTreeImpl.md#insert)

<pre><code class="language-cairo">fn insert(ref self: <a href="cartesian_merkle_tree-tree-CMTree.html">CMTree</a>, key: felt252)</code></pre>


### insert_node

Internal recursive function for inserting a node while maintaining tree properties.
Performs BST insertion based on key comparison, then checks and restores heap property
through rotations if necessary. Updates Merkle hashes along the insertion path.
## Arguments

- `current` - The current node being examined
- `new_node` - The node to insert
## Returns

The root of the subtree after insertion and any necessary rotations

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[insert_node](./cartesian_merkle_tree-tree-CMTreeImpl.md#insert_node)

<pre><code class="language-cairo">fn insert_node(mut current: Box&lt;CMTNode&gt;, new_node: Box&lt;CMTNode&gt;) -&gt; Box&lt;CMTNode&gt;</code></pre>


### restore_heap_property

Restores the heap property by performing rotations when a child has higher priority than
parent.
This function checks if the specified child violates the heap property (child priority >
parent priority)
and performs the appropriate rotation to restore it. This maintains the treap invariant.
## Arguments

- `node` - The node to check and potentially rotate
- `check_left` - Whether to check the left child (true) or right child (false)
## Returns

The root of the subtree after any necessary rotation

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[restore_heap_property](./cartesian_merkle_tree-tree-CMTreeImpl.md#restore_heap_property)

<pre><code class="language-cairo">fn restore_heap_property(node: Box&lt;CMTNode&gt;, check_left: bool) -&gt; Box&lt;CMTNode&gt;</code></pre>


### search

Searches for a key in the Cartesian Merkle Tree.
Performs a standard BST search using key comparisons to navigate the tree.
Time complexity is O(log n) on average due to the randomized heap property.
## Arguments

- `key` - The key to search for
## Returns

`true` if the key exists in the tree, `false` otherwise
## Examples

```cairo
let mut tree = CMTreeTrait::new();
tree.insert(42);
assert!(tree.search(42));
assert!(!tree.search(100));
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[search](./cartesian_merkle_tree-tree-CMTreeImpl.md#search)

<pre><code class="language-cairo">fn search(self: CMTree, key: felt252) -&gt; bool</code></pre>


### search_node

Internal recursive function for searching a key starting from a given node.
Performs BST traversal by comparing keys and recursively searching the appropriate subtree.
## Arguments

- `node` - The current node being examined
- `key` - The key to search for
## Returns

`true` if the key is found in the subtree, `false` otherwise

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[search_node](./cartesian_merkle_tree-tree-CMTreeImpl.md#search_node)

<pre><code class="language-cairo">fn search_node(node: Box&lt;CMTNode&gt;, key: felt252) -&gt; bool</code></pre>


### get_root_hash

Returns the Merkle hash of the tree's root node.
The root hash serves as a cryptographic commitment to the entire tree structure
and contents, enabling efficient verification of tree state and proof validation.
## Returns

- `0` for empty trees
- The Merkle hash of the root node for non-empty trees
## Examples

```cairo
let tree = CMTreeTrait::new();
assert_eq!(tree.get_root_hash(), 0);

let mut tree = CMTreeTrait::new();
tree.insert(42);
assert!(tree.get_root_hash() != 0);
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[get_root_hash](./cartesian_merkle_tree-tree-CMTreeImpl.md#get_root_hash)

<pre><code class="language-cairo">fn get_root_hash(self: CMTree) -&gt; felt252</code></pre>


### remove

Removes a key from the Cartesian Merkle Tree.
Removal maintains all tree properties through a rotation-based approach:
1. Locate the target node using BST search
2. For nodes with children, rotate them toward a leaf position
3. Remove the node once it becomes a leaf
4. Update Merkle hashes along the removal path
## Arguments

- `key` - The key to remove from the tree
## Returns

`true` if the key was found and removed, `false` if the key wasn't in the tree
## Examples

```cairo
let mut tree = CMTreeTrait::new();
tree.insert(42);
assert!(tree.remove(42));
assert!(!tree.search(42));
assert!(!tree.remove(100)); // Non-existent key
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[remove](./cartesian_merkle_tree-tree-CMTreeImpl.md#remove)

<pre><code class="language-cairo">fn remove(ref self: <a href="cartesian_merkle_tree-tree-CMTree.html">CMTree</a>, key: felt252) -&gt; bool</code></pre>


### remove_node

Internal recursive function for removing a node while maintaining tree properties.
This function handles the BST deletion process, including special handling for nodes
with two children by delegating to rotation-based removal.
## Arguments

- `node` - The current node being examined
- `key` - The key to remove
## Returns

A tuple containing:
- The new root of this subtree (None if subtree becomes empty)
- Whether the key was found and removed

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[remove_node](./cartesian_merkle_tree-tree-CMTreeImpl.md#remove_node)

<pre><code class="language-cairo">fn remove_node(node: Box&lt;CMTNode&gt;, key: felt252) -&gt; (Option&lt;Box&lt;CMTNode&gt;&gt;, bool)</code></pre>


### rotate_to_leaf_and_remove

Rotates a node with two children toward a leaf position, then removes it.
This function implements the treap deletion strategy for nodes with both children:
repeatedly rotate the node down the tree based on child priorities until it becomes
a leaf, then remove it. This maintains both BST and heap properties.
## Arguments

- `node` - The node to rotate and remove
- `key` - The key being removed (for verification)
## Returns

The new root of this subtree after rotation and removal

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[tree](./cartesian_merkle_tree-tree.md)::[CMTreeImpl](./cartesian_merkle_tree-tree-CMTreeImpl.md)::[rotate_to_leaf_and_remove](./cartesian_merkle_tree-tree-CMTreeImpl.md#rotate_to_leaf_and_remove)

<pre><code class="language-cairo">fn rotate_to_leaf_and_remove(node: Box&lt;CMTNode&gt;, key: felt252) -&gt; Option&lt;Box&lt;CMTNode&gt;&gt;</code></pre>


