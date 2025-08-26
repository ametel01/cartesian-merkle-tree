# HasComponent

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[HasComponent](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md)

<pre><code class="language-cairo">pub trait HasComponent&lt;TContractState&gt;</code></pre>

## Trait functions

### get_component

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[HasComponent](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md)::[get_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md#get_component)

<pre><code class="language-cairo">fn get_component&lt;TContractState, TContractState&gt;(
    self: @TContractState,
) -&gt; ComponentState&lt;TContractState&gt;</code></pre>


### get_component_mut

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[HasComponent](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md)::[get_component_mut](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md#get_component_mut)

<pre><code class="language-cairo">fn get_component_mut&lt;TContractState, TContractState&gt;(
    ref self: TContractState,
) -&gt; <a href="cartesian_merkle_tree-components-cmtree_component-cmtree_component-ComponentState.html">ComponentState&lt;TContractState&gt;</a></code></pre>


### get_contract

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[HasComponent](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md)::[get_contract](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md#get_contract)

<pre><code class="language-cairo">fn get_contract&lt;TContractState, TContractState&gt;(
    self: @ComponentState&lt;TContractState&gt;,
) -&gt; @TContractState</code></pre>


### get_contract_mut

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[HasComponent](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md)::[get_contract_mut](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md#get_contract_mut)

<pre><code class="language-cairo">fn get_contract_mut&lt;TContractState, TContractState&gt;(
    ref self: ComponentState&lt;TContractState&gt;,
) -&gt; TContractState</code></pre>


### emit

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[components](./cartesian_merkle_tree-components.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component.md)::[cmtree_component](./cartesian_merkle_tree-components-cmtree_component-cmtree_component.md)::[HasComponent](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md)::[emit](./cartesian_merkle_tree-components-cmtree_component-cmtree_component-HasComponent.md#emit)

<pre><code class="language-cairo">fn emit&lt;
    TContractState,
    TContractState,
    S,
    impl IntoImp: Into&lt;
        S, cartesian_merkle_tree::components::cmtree_component::cmtree_component::Event,
    &gt;,
&gt;(
    ref self: ComponentState&lt;TContractState&gt;, event: S,
)</code></pre>


