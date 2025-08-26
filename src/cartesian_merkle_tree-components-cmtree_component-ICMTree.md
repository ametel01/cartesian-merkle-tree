# ICMTree

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTree](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md)

<pre><code class="language-cairo">pub trait ICMTree&lt;TContractState&gt;</code></pre>

## Trait functions

### insert

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTree](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md)::[insert](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md#insert)

<pre><code class="language-cairo">fn insert&lt;TContractState, TContractState&gt;(ref self: TContractState, key: felt252)</code></pre>


### remove

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTree](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md)::[remove](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md#remove)

<pre><code class="language-cairo">fn remove&lt;TContractState, TContractState&gt;(ref self: TContractState, key: felt252) -&gt; bool</code></pre>


### search

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTree](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md)::[search](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md#search)

<pre><code class="language-cairo">fn search&lt;TContractState, TContractState&gt;(self: @TContractState, key: felt252) -&gt; bool</code></pre>


### get_root_hash

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTree](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md)::[get_root_hash](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md#get_root_hash)

<pre><code class="language-cairo">fn get_root_hash&lt;TContractState, TContractState&gt;(self: @TContractState) -&gt; felt252</code></pre>


### generate_proof

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTree](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md)::[generate_proof](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md#generate_proof)

<pre><code class="language-cairo">fn generate_proof&lt;TContractState, TContractState&gt;(self: @TContractState, key: felt252) -&gt; <a href="cartesian_merkle_tree-components-cmtree_component-ProofData.html">ProofData</a></code></pre>


### verify_proof

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[ICMTree](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md)::[verify_proof](./cartesian_merkle_tree-components-cmtree_component-ICMTree.md#verify_proof)

<pre><code class="language-cairo">fn verify_proof&lt;TContractState, TContractState&gt;(
    self: @TContractState, proof: <a href="cartesian_merkle_tree-components-cmtree_component-ProofData.html">ProofData</a>, root_hash: felt252, key: felt252,
) -&gt; bool</code></pre>


