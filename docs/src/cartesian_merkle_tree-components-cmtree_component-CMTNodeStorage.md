# CMTNodeStorage

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[CMTNodeStorage](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md)

<pre><code class="language-cairo">#[derive(Drop, Copy, Debug, Serde, starknet::Store)]
pub struct CMTNodeStorage {
    pub key: felt252,
    pub priority: felt252,
    pub merkle_hash: felt252,
    pub left_child_index: u64,
    pub right_child_index: u64,
}</code></pre>

## Members

### key

The key value for BST ordering and identification

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[CMTNodeStorage](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md)::[key](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md#key)

<pre><code class="language-cairo">pub key: felt252</code></pre>


### priority

Randomized priority for heap property (derived from key)

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[CMTNodeStorage](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md)::[priority](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md#priority)

<pre><code class="language-cairo">pub priority: felt252</code></pre>


### merkle_hash

Merkle hash commitment to this node and its children

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[CMTNodeStorage](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md)::[merkle_hash](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md#merkle_hash)

<pre><code class="language-cairo">pub merkle_hash: felt252</code></pre>


### left_child_index

Storage index of the left child node (0 = no child)

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[CMTNodeStorage](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md)::[left_child_index](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md#left_child_index)

<pre><code class="language-cairo">pub left_child_index: u64</code></pre>


### right_child_index

Storage index of the right child node (0 = no child)

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[CMTNodeStorage](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md)::[right_child_index](./cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.md#right_child_index)

<pre><code class="language-cairo">pub right_child_index: u64</code></pre>


