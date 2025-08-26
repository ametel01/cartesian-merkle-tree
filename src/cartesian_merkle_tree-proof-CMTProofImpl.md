# CMTProofImpl

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProofImpl](./cartesian_merkle_tree-proof-CMTProofImpl.md)

<pre><code class="language-cairo">pub impl CMTProofImpl of CMTProofTrait;</code></pre>

## Impl functions

### new

Creates a new empty CMTProof with default values.
## Returns

A new `CMTProof` instance with all fields initialized to zero/empty values.
## Examples

```cairo
let proof = CMTProofTrait::new();
assert!(!proof.existence);
assert!(proof.siblings_length == 0);
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProofImpl](./cartesian_merkle_tree-proof-CMTProofImpl.md)::[new](./cartesian_merkle_tree-proof-CMTProofImpl.md#new)

<pre><code class="language-cairo">fn new() -&gt; <a href="cartesian_merkle_tree-proof-CMTProof.html">CMTProof</a></code></pre>


### verify

Verifies a CMT proof against a given root hash and key.
This method reconstructs the Merkle path from the leaf to the root using the sibling
information stored in the proof, and checks if the computed root matches the expected root
hash.
## Arguments

- `root_hash` - The expected root hash of the tree
- `key` - The key being verified
## Returns

`true` if the proof is valid, `false` otherwise
## Examples

```cairo
let mut tree = CMTreeTrait::new();
tree.insert(50);
let proof = tree.generate_proof_with_path(50);
let root = tree.get_root_hash();
assert!(proof.verify(root, 50));
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProofImpl](./cartesian_merkle_tree-proof-CMTProofImpl.md)::[verify](./cartesian_merkle_tree-proof-CMTProofImpl.md#verify)

<pre><code class="language-cairo">fn verify(self: CMTProof, root_hash: felt252, key: felt252) -&gt; bool</code></pre>


### calculate_node_hash

Calculates the Merkle hash for a node given its key and child hashes.
This function ensures consistent hash ordering by sorting child hashes before
computing the parent hash, maintaining compatibility with the Solidity implementation.
## Arguments

- `key` - The key of the node
- `left_hash` - Hash of the left child
- `right_hash` - Hash of the right child
## Returns

The computed Merkle hash for the node
## Examples

```cairo
let hash = CMTProofTrait::calculate_node_hash(50, 0, 0);
assert!(hash != 0);
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[proof](./cartesian_merkle_tree-proof.md)::[CMTProofImpl](./cartesian_merkle_tree-proof-CMTProofImpl.md)::[calculate_node_hash](./cartesian_merkle_tree-proof-CMTProofImpl.md#calculate_node_hash)

<pre><code class="language-cairo">fn calculate_node_hash(key: felt252, left_hash: felt252, right_hash: felt252) -&gt; felt252</code></pre>


