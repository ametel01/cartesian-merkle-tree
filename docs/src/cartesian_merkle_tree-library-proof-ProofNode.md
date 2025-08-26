# ProofNode

A node in a Merkle proof path containing key and hash information.

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[proof](./cartesian_merkle_tree-library-proof.md)::[ProofNode](./cartesian_merkle_tree-library-proof-ProofNode.md)

<pre><code class="language-cairo">#[derive(Drop, Clone, Debug)]
pub struct ProofNode {
    pub key: felt252,
    pub merkle_hash: felt252,
}</code></pre>

## Members

### key

The key associated with this proof node

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[proof](./cartesian_merkle_tree-library-proof.md)::[ProofNode](./cartesian_merkle_tree-library-proof-ProofNode.md)::[key](./cartesian_merkle_tree-library-proof-ProofNode.md#key)

<pre><code class="language-cairo">pub key: felt252</code></pre>


### merkle_hash

The Merkle hash of this proof node

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[proof](./cartesian_merkle_tree-library-proof.md)::[ProofNode](./cartesian_merkle_tree-library-proof-ProofNode.md)::[merkle_hash](./cartesian_merkle_tree-library-proof-ProofNode.md#merkle_hash)

<pre><code class="language-cairo">pub merkle_hash: felt252</code></pre>


