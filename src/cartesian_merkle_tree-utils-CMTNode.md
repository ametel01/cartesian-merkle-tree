# CMTNode

A node in the Cartesian Merkle Tree containing key, priority, hash, and child references.
Each node maintains the three essential properties of the CMT:
- Key: Used for BST ordering and proof generation
- Priority: Randomized value for heap property maintenance
- Merkle Hash: Cryptographic commitment to this node and its subtree
- Children: References to left and right child nodes

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTNode](./cartesian_merkle_tree-utils-CMTNode.md)

<pre><code class="language-cairo">#[derive(Drop, Copy, Debug)]
pub struct CMTNode {
    pub key: felt252,
    pub priority: felt252,
    pub merkle_hash: felt252,
    pub left_child: Option&lt;Box&lt;CMTNode&gt;&gt;,
    pub right_child: Option&lt;Box&lt;CMTNode&gt;&gt;,
}</code></pre>

## Members

### key

The key value for BST ordering and identification

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTNode](./cartesian_merkle_tree-utils-CMTNode.md)::[key](./cartesian_merkle_tree-utils-CMTNode.md#key)

<pre><code class="language-cairo">pub key: felt252</code></pre>


### priority

Randomized priority for heap property (derived from key)

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTNode](./cartesian_merkle_tree-utils-CMTNode.md)::[priority](./cartesian_merkle_tree-utils-CMTNode.md#priority)

<pre><code class="language-cairo">pub priority: felt252</code></pre>


### merkle_hash

Merkle hash commitment to this node and its children

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTNode](./cartesian_merkle_tree-utils-CMTNode.md)::[merkle_hash](./cartesian_merkle_tree-utils-CMTNode.md#merkle_hash)

<pre><code class="language-cairo">pub merkle_hash: felt252</code></pre>


### left_child

Reference to the left child node (keys < this.key)

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTNode](./cartesian_merkle_tree-utils-CMTNode.md)::[left_child](./cartesian_merkle_tree-utils-CMTNode.md#left_child)

<pre><code class="language-cairo">pub left_child: Option&lt;Box&lt;CMTNode&gt;&gt;</code></pre>


### right_child

Reference to the right child node (keys > this.key)

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[utils](./cartesian_merkle_tree-utils.md)::[CMTNode](./cartesian_merkle_tree-utils-CMTNode.md)::[right_child](./cartesian_merkle_tree-utils-CMTNode.md#right_child)

<pre><code class="language-cairo">pub right_child: Option&lt;Box&lt;CMTNode&gt;&gt;</code></pre>


