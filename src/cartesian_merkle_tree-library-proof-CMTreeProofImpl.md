# CMTreeProofImpl

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[proof](./cartesian_merkle_tree-library-proof.md)::[CMTreeProofImpl](./cartesian_merkle_tree-library-proof-CMTreeProofImpl.md)

<pre><code class="language-cairo">pub impl CMTreeProofImpl of CMTreeProofTrait;</code></pre>

## Impl functions

### generate_proof_with_path

Generates a cryptographic proof for a key in the Cartesian Merkle Tree.
This method creates either an existence proof (if the key is found) or a non-existence
proof (if the key is not found) by collecting sibling information along the search path.
## Arguments

- `key` - The key to generate a proof for
## Returns

A `CMTProof` containing all necessary information to verify the key's presence or absence
## Examples

```cairo
let mut tree = CMTreeTrait::new();
tree.insert(50);

// Generate existence proof
let existence_proof = tree.generate_proof_with_path(50);
assert!(existence_proof.existence);

// Generate non-existence proof
let non_existence_proof = tree.generate_proof_with_path(60);
assert!(!non_existence_proof.existence);
```

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[proof](./cartesian_merkle_tree-library-proof.md)::[CMTreeProofImpl](./cartesian_merkle_tree-library-proof-CMTreeProofImpl.md)::[generate_proof_with_path](./cartesian_merkle_tree-library-proof-CMTreeProofImpl.md#generate_proof_with_path)

<pre><code class="language-cairo">fn generate_proof_with_path(self: CMTree, key: felt252) -&gt; <a href="cartesian_merkle_tree-library-proof-CMTProof.html">CMTProof</a></code></pre>


### generate_proof_internal

Internal recursive function for generating proof data by traversing the tree.
This function performs a depth-first search through the tree, collecting sibling
information and direction bits needed to reconstruct the Merkle path during verification.
## Arguments

- `node` - Current node being examined
- `key` - Target key to generate proof for
- `siblings` - Mutable reference to array collecting sibling data
- `direction_bits` - Mutable reference to bit field for hash ordering
- `siblings_count` - Mutable reference to count of collected siblings
## Returns

A tuple containing:
- `bool` - Whether the key was found
- `felt252` - For non-existence proofs, the key where insertion would occur

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[proof](./cartesian_merkle_tree-library-proof.md)::[CMTreeProofImpl](./cartesian_merkle_tree-library-proof-CMTreeProofImpl.md)::[generate_proof_internal](./cartesian_merkle_tree-library-proof-CMTreeProofImpl.md#generate_proof_internal)

<pre><code class="language-cairo">fn generate_proof_internal(
    node: Box&lt;CMTNode&gt;,
    key: felt252,
    ref siblings: Array&lt;felt252&gt;,
    ref direction_bits: felt252,
    ref siblings_count: u32,
) -&gt; (bool, felt252)</code></pre>


### calculate_direction_bit

Calculates and updates the direction bits for hash ordering during proof verification.
Direction bits encode whether child hashes were swapped during node hash calculation.
This information is essential for correctly reconstructing the Merkle path during
verification.
## Arguments

- `direction_bits` - Current direction bits value
- `siblings_count` - Number of siblings processed so far
- `is_swapped` - Whether the child hashes were swapped for this level
## Returns

Updated direction bits value

Fully qualified path: [cartesian_merkle_tree](./cartesian_merkle_tree.md)::[library](./cartesian_merkle_tree-library.md)::[proof](./cartesian_merkle_tree-library-proof.md)::[CMTreeProofImpl](./cartesian_merkle_tree-library-proof-CMTreeProofImpl.md)::[calculate_direction_bit](./cartesian_merkle_tree-library-proof-CMTreeProofImpl.md#calculate_direction_bit)

<pre><code class="language-cairo">fn calculate_direction_bit(
    direction_bits: felt252, siblings_count: u32, is_swapped: bool,
) -&gt; felt252</code></pre>


