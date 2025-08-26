# ProofData

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ProofData](./cartesian_merkle_tree-components-cmtree_component-ProofData.md)

<pre><code class="language-cairo">#[derive(Drop, Clone, Debug, Serde)]
pub struct ProofData {
    pub root: felt252,
    pub siblings: Array&lt;felt252&gt;,
    pub siblings_length: u32,
    pub direction_bits: felt252,
    pub existence: bool,
    pub key: felt252,
    pub non_existence_key: felt252,
}</code></pre>

## Members

### root

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ProofData](./cartesian_merkle_tree-components-cmtree_component-ProofData.md)::[root](./cartesian_merkle_tree-components-cmtree_component-ProofData.md#root)

<pre><code class="language-cairo">pub root: felt252</code></pre>


### siblings

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ProofData](./cartesian_merkle_tree-components-cmtree_component-ProofData.md)::[siblings](./cartesian_merkle_tree-components-cmtree_component-ProofData.md#siblings)

<pre><code class="language-cairo">pub siblings: Array&lt;felt252&gt;</code></pre>


### siblings_length

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ProofData](./cartesian_merkle_tree-components-cmtree_component-ProofData.md)::[siblings_length](./cartesian_merkle_tree-components-cmtree_component-ProofData.md#siblings_length)

<pre><code class="language-cairo">pub siblings_length: u32</code></pre>


### direction_bits

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ProofData](./cartesian_merkle_tree-components-cmtree_component-ProofData.md)::[direction_bits](./cartesian_merkle_tree-components-cmtree_component-ProofData.md#direction_bits)

<pre><code class="language-cairo">pub direction_bits: felt252</code></pre>


### existence

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ProofData](./cartesian_merkle_tree-components-cmtree_component-ProofData.md)::[existence](./cartesian_merkle_tree-components-cmtree_component-ProofData.md#existence)

<pre><code class="language-cairo">pub existence: bool</code></pre>


### key

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ProofData](./cartesian_merkle_tree-components-cmtree_component-ProofData.md)::[key](./cartesian_merkle_tree-components-cmtree_component-ProofData.md#key)

<pre><code class="language-cairo">pub key: felt252</code></pre>


### non_existence_key

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ProofData](./cartesian_merkle_tree-components-cmtree_component-ProofData.md)::[non_existence_key](./cartesian_merkle_tree-components-cmtree_component-ProofData.md#non_existence_key)

<pre><code class="language-cairo">pub non_existence_key: felt252</code></pre>


