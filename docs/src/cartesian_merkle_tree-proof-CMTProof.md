# CMTProof

A Cartesian Merkle Tree proof structure containing all information needed to verify membership
or non-membership.
The proof contains sibling information along the path from a leaf to the root, allowing
verification of key existence or non-existence in the tree without requiring the full tree
structure.

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProof](./cartesian_merkle_tree-proof-CMTProof.md)

<pre><code class="language-cairo">#[derive(Drop, Clone, Debug)]
pub struct CMTProof {
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

The root hash of the tree this proof was generated from

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProof](./cartesian_merkle_tree-proof-CMTProof.md)::[root](./cartesian_merkle_tree-proof-CMTProof.md#root)

<pre><code class="language-cairo">pub root: felt252</code></pre>


### siblings

Array containing alternating keys and hashes of sibling nodes along the proof path

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProof](./cartesian_merkle_tree-proof-CMTProof.md)::[siblings](./cartesian_merkle_tree-proof-CMTProof.md#siblings)

<pre><code class="language-cairo">pub siblings: Array&lt;felt252&gt;</code></pre>


### siblings_length

The total number of elements in the siblings array

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProof](./cartesian_merkle_tree-proof-CMTProof.md)::[siblings_length](./cartesian_merkle_tree-proof-CMTProof.md#siblings_length)

<pre><code class="language-cairo">pub siblings_length: u32</code></pre>


### direction_bits

Bit field indicating the ordering of child hashes when computing parent hashes

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProof](./cartesian_merkle_tree-proof-CMTProof.md)::[direction_bits](./cartesian_merkle_tree-proof-CMTProof.md#direction_bits)

<pre><code class="language-cairo">pub direction_bits: felt252</code></pre>


### existence

Whether this proof demonstrates key existence (true) or non-existence (false)

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProof](./cartesian_merkle_tree-proof-CMTProof.md)::[existence](./cartesian_merkle_tree-proof-CMTProof.md#existence)

<pre><code class="language-cairo">pub existence: bool</code></pre>


### key

The key being proven to exist or not exist

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProof](./cartesian_merkle_tree-proof-CMTProof.md)::[key](./cartesian_merkle_tree-proof-CMTProof.md#key)

<pre><code class="language-cairo">pub key: felt252</code></pre>


### non_existence_key

For non-existence proofs, the key of the node where the target key would be inserted

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProof](./cartesian_merkle_tree-proof-CMTProof.md)::[non_existence_key](./cartesian_merkle_tree-proof-CMTProof.md#non_existence_key)

<pre><code class="language-cairo">pub non_existence_key: felt252</code></pre>


