# Storage

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[Storage](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-Storage.md)

<pre><code class="language-cairo">#[storage]
pub struct Storage {
    root_index: u64,
    next_node_index: u64,
    nodes: Map&lt;u64, CMTNodeStorage&gt;,
    deleted_indices_head: u64,
    deleted_indices: Map&lt;u64, u64&gt;,
}</code></pre>

