# CMTree

A Cartesian Merkle Tree combining binary search tree, heap, and Merkle tree properties.
The tree maintains three invariants simultaneously:
1. BST Property: Left subtree keys < node key < right subtree keys
2. Heap Property: Parent priority >= child priorities
3. Merkle Property: Each node's hash depends on its key and children's hashes

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[tree](./cartesian_merkle_tree-library-tree.md)::[CMTree](./cartesian_merkle_tree-library-tree-CMTree.md)

<pre><code class="language-cairo">#[derive(Drop, Copy, Debug)]
pub struct CMTree {
    pub root: Option&lt;Box&lt;CMTNode&gt;&gt;,
}</code></pre>

## Members

### root

The root node of the tree, None for empty trees

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[tree](./cartesian_merkle_tree-library-tree.md)::[CMTree](./cartesian_merkle_tree-library-tree-CMTree.md)::[root](./cartesian_merkle_tree-library-tree-CMTree.md#root)

<pre><code class="language-cairo">pub root: Option&lt;Box&lt;CMTNode&gt;&gt;</code></pre>


