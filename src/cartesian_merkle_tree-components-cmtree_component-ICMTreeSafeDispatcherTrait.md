# ICMTreeSafeDispatcherTrait

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTreeSafeDispatcherTrait](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md)

Part of the group: [dispatchers](./dispatchers.md)

<pre><code class="language-cairo">pub trait ICMTreeSafeDispatcherTrait&lt;T&gt;</code></pre>

## Trait functions

### insert

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTreeSafeDispatcherTrait](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md)::[insert](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md#insert)

<pre><code class="language-cairo">fn insert&lt;T, T&gt;(self: T, key: felt252) -&gt; Result&lt;(), Array&lt;felt252&gt;&gt;</code></pre>


### remove

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTreeSafeDispatcherTrait](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md)::[remove](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md#remove)

<pre><code class="language-cairo">fn remove&lt;T, T&gt;(self: T, key: felt252) -&gt; Result&lt;bool, Array&lt;felt252&gt;&gt;</code></pre>


### search

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTreeSafeDispatcherTrait](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md)::[search](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md#search)

<pre><code class="language-cairo">fn search&lt;T, T&gt;(self: T, key: felt252) -&gt; Result&lt;bool, Array&lt;felt252&gt;&gt;</code></pre>


### get_root_hash

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTreeSafeDispatcherTrait](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md)::[get_root_hash](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md#get_root_hash)

<pre><code class="language-cairo">fn get_root_hash&lt;T, T&gt;(self: T) -&gt; Result&lt;felt252, Array&lt;felt252&gt;&gt;</code></pre>


### generate_proof

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTreeSafeDispatcherTrait](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md)::[generate_proof](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md#generate_proof)

<pre><code class="language-cairo">fn generate_proof&lt;T, T&gt;(self: T, key: felt252) -&gt; Result&lt;ProofData, Array&lt;felt252&gt;&gt;</code></pre>


### verify_proof

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTreeSafeDispatcherTrait](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md)::[verify_proof](./cartesian_merkle_tree-components-cmtree_component-ICMTreeSafeDispatcherTrait.md#verify_proof)

<pre><code class="language-cairo">fn verify_proof&lt;T, T&gt;(
    self: T, proof: <a href="cartesian_merkle_tree-components-cmtree_component-ProofData.html">ProofData</a>, root_hash: felt252, key: felt252,
) -&gt; Result&lt;bool, Array&lt;felt252&gt;&gt;</code></pre>


