# InternalFunctionsTrait

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)

<pre><code class="language-cairo">pub trait InternalFunctionsTrait&lt;TContractState, <a href="cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.html">+HasComponent&lt;TContractState&gt;</a>&gt;</code></pre>

## Trait functions

### initializer

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[initializer](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#initializer)

<pre><code class="language-cairo">fn initializer&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;,
)</code></pre>


### allocate_node_index

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[allocate_node_index](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#allocate_node_index)

<pre><code class="language-cairo">fn allocate_node_index&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;,
) -&gt; u64</code></pre>


### free_node_index

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[free_node_index](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#free_node_index)

<pre><code class="language-cairo">fn free_node_index&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;, index: u64,
)</code></pre>


### read_node

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[read_node](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#read_node)

<pre><code class="language-cairo">fn read_node&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    self: @ComponentState&lt;TContractState&gt;, index: u64,
) -&gt; <a href="cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.html">CMTNodeStorage</a></code></pre>


### write_node

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[write_node](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#write_node)

<pre><code class="language-cairo">fn write_node&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;, index: u64, node: <a href="cartesian_merkle_tree-components-cmtree_component-CMTNodeStorage.html">CMTNodeStorage</a>,
)</code></pre>


### update_node_hash

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[update_node_hash](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#update_node_hash)

<pre><code class="language-cairo">fn update_node_hash&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;, index: u64,
) -&gt; felt252</code></pre>


### insert_node

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[insert_node](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#insert_node)

<pre><code class="language-cairo">fn insert_node&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;,
    current_index: u64,
    new_index: u64,
    new_key: felt252,
    new_priority: felt252,
) -&gt; u64</code></pre>


### restore_heap_property

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[restore_heap_property](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#restore_heap_property)

<pre><code class="language-cairo">fn restore_heap_property&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;, node_index: u64, check_left: bool,
) -&gt; u64</code></pre>


### right_rotate

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[right_rotate](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#right_rotate)

<pre><code class="language-cairo">fn right_rotate&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;, node_index: u64,
) -&gt; u64</code></pre>


### left_rotate

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[left_rotate](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#left_rotate)

<pre><code class="language-cairo">fn left_rotate&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;, node_index: u64,
) -&gt; u64</code></pre>


### search_node

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[search_node](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#search_node)

<pre><code class="language-cairo">fn search_node&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    self: @ComponentState&lt;TContractState&gt;, node_index: u64, key: felt252,
) -&gt; bool</code></pre>


### remove_node

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[remove_node](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#remove_node)

<pre><code class="language-cairo">fn remove_node&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;, node_index: u64, key: felt252,
) -&gt; (u64, bool)</code></pre>


### rotate_to_leaf_and_remove

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[rotate_to_leaf_and_remove](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#rotate_to_leaf_and_remove)

<pre><code class="language-cairo">fn rotate_to_leaf_and_remove&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;, node_index: u64, key: felt252,
) -&gt; u64</code></pre>


### generate_proof_internal

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[InternalFunctionsTrait](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md)::[generate_proof_internal](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-InternalFunctionsTrait.md#generate_proof_internal)

<pre><code class="language-cairo">fn generate_proof_internal&lt;
    TContractState, +HasComponent&lt;TContractState&gt;, TContractState, +HasComponent&lt;TContractState&gt;,
&gt;(
    self: @ComponentState&lt;TContractState&gt;,
    node_index: u64,
    key: felt252,
    ref siblings: Array&lt;felt252&gt;,
    ref direction_bits: felt252,
    ref siblings_count: u32,
) -&gt; (bool, felt252)</code></pre>


