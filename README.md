# Cartesian Merkle Tree

A Cairo library implementation of Cartesian Merkle Trees (CMTs) - an efficient data structure combining binary search tree properties with heap properties and Merkle tree cryptographic verification capabilities.

## Overview

Cartesian Merkle Trees represent a significant advancement over traditional Merkle tree structures by storing useful data in every node rather than just leaves. This implementation provides:

- **O(log n) operations** for insertions, deletions, and searches
- **Deterministic tree structure** through key-derived priorities
- **Cryptographic proof generation** for membership and non-membership verification
- **Self-balancing properties** through treap rotations
- **Space-efficient design** with useful data stored in all nodes

## What are Cartesian Merkle Trees?

CMTs combine three fundamental data structures:

1. **Binary Search Tree (BST)**: Keys are ordered for efficient search operations
2. **Heap**: Priorities maintain balance through the treap property
3. **Merkle Tree**: Each node contains a cryptographic hash for verification

Each element in the tree corresponds to a point on a 2D plane:

- **X-coordinate**: The key (determines BST position)
- **Y-coordinate**: The priority (determines heap structure, derived deterministically from the key)

This dual ordering ensures both efficient operations and cryptographic integrity.

## Why CMTs vs Existing Solutions?

### Advantages over Sparse Merkle Trees (SMT):

- **Useful data in all nodes**: SMTs only store data in leaves, CMTs utilize every node
- **Better memory efficiency**: Reduced storage requirements while maintaining functionality
- **Flexible tree depth**: Not constrained by fixed depth requirements

### Advantages over Incremental Merkle Trees (IMT):

- **No off-chain dependency**: Generate proofs entirely on-chain
- **Support for deletions**: Full CRUD operations vs append-only IMTs
- **Deterministic structure**: Same set of elements always produces the same tree

### Trade-offs:

- **Proof size**: At worst 2x larger than SMT proofs, but often smaller in practice
- **Implementation complexity**: More sophisticated than basic Merkle trees

## On-Chain Benefits

CMTs are particularly well-suited for blockchain applications:

- **Gas efficiency**: Fewer storage operations due to useful data in all nodes
- **Proof verification**: Compact proofs for state transitions
- **Deterministic behavior**: Essential for consensus across nodes
- **State management**: Efficient for rollups and layer-2 solutions

## Use Cases

CMTs are ideal for various onchain applications requiring dynamic, verifiable data structures:

### DeFi & Financial Applications

- **Liquidity Pool Management**: Track liquidity positions with cryptographic proofs
- **Staking Registries**: Manage staking positions with add/remove capabilities
- **Order Book Systems**: Maintain sorted order books with proof of inclusion
- **Lending Protocol Collateral**: Track collateral deposits with verification

### Identity & Access Control

- **Decentralized Identity (DID)**: Store verifiable credentials entirely onchain
- **Allowlist/Whitelist Management**: Dynamic access control with membership proofs
- **KYC/AML Registries**: Maintain compliance lists with cryptographic verification
- **DAO Membership**: Track voting rights and member privileges

### Gaming & NFTs

- **Asset Ownership Registries**: Efficient tracking of in-game items or NFTs
- **Achievement Systems**: Verifiable player accomplishments
- **Tournament Brackets**: Maintain competitive rankings with proof of position
- **Loot Distribution**: Fair and verifiable reward allocation

### Infrastructure & Scaling

- **Layer 2 State Management**: Efficient state roots for rollups
- **Cross-chain Bridge State**: Track locked assets with proofs
- **Oracle Data Aggregation**: Verifiable data feeds with update history
- **State Channel Checkpoints**: Efficient intermediate state commitments

### Governance & Voting

- **Voter Registries**: Dynamic voter lists with add/remove capabilities
- **Proposal Tracking**: Maintain proposal states with verification
- **Delegation Systems**: Track delegated voting power with proofs
- **Quadratic Funding**: Verifiable contribution tracking

### Supply Chain & Real World Assets

- **Product Authenticity**: Track genuine products with proof of origin
- **Inventory Management**: Verifiable stock levels across locations
- **Certification Tracking**: Maintain certification status with proofs
- **Carbon Credit Registry**: Track and verify environmental credits

## Installation

Add to your `Scarb.toml`:

```toml
[dependencies]
cartesian_merkle_tree = "0.2.0"
```

Or install from GitHub:

```toml
[dependencies]
cartesian_merkle_tree = { git = "https://github.com/ametel01/cartesian-merkle-tree.git" }
```

## Usage

### In-Memory Tree Operations

```cairo
use cartesian_merkle_tree::{CMTree, CMTreeTrait};

// Create a new tree
let mut tree = CMTreeTrait::new();

// Insert elements
tree.insert(50);
tree.insert(30);
tree.insert(70);

// Search for elements
assert!(tree.search(50));
assert!(!tree.search(100));

// Remove elements
assert!(tree.remove(30));
assert!(!tree.search(30));

// Get root hash for verification
let root_hash = tree.get_root_hash();
```

### Proof Generation and Verification

```cairo
use cartesian_merkle_tree::{CMTree, CMTreeTrait, CMTreeProofTrait};

let mut tree = CMTreeTrait::new();
tree.insert(50);
tree.insert(30);
tree.insert(70);

// Generate existence proof
let proof = tree.generate_proof(30);
let root_hash = tree.get_root_hash();

// Verify the proof
assert!(proof.verify(root_hash, 30));

// Generate non-existence proof
let non_existence_proof = tree.generate_proof(40);
assert!(non_existence_proof.verify(root_hash, 40));
```

### Using as Starknet Contract Component

```cairo
#[starknet::contract]
mod MyContract {
    use cartesian_merkle_tree::cmtree_component::cmtree_component;

    component!(path: cmtree_component, storage: cmtree, event: CMTreeEvent);

    // Embed the CMTree component's external functions
    #[abi(embed_v0)]
    impl CMTreeImpl = cmtree_component::CMTree<ContractState>;

    // Access to internal functions
    impl CMTreeInternalImpl = cmtree_component::InternalFunctions<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        cmtree: cmtree_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CMTreeEvent: cmtree_component::Event,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Initialize the CMTree component
        self.cmtree.initializer();
    }
}
```

### Contract Usage Example

```cairo
use cartesian_merkle_tree::components::cmtree_component::{
    ICMTreeDispatcher, ICMTreeDispatcherTrait
};

fn use_cmt_contract(contract_address: ContractAddress) {
    let dispatcher = ICMTreeDispatcher { contract_address };

    // Insert elements
    dispatcher.insert(50);
    dispatcher.insert(30);
    dispatcher.insert(70);

    // Search for elements
    assert!(dispatcher.search(50));

    // Generate and verify proofs
    let proof = dispatcher.generate_proof(30);
    let root_hash = dispatcher.get_root_hash();
    assert!(dispatcher.verify_proof(proof, root_hash, 30));

    // Remove elements
    assert!(dispatcher.remove(30));
}
```

## Implementation Details

This Cairo implementation features:

- **Poseidon hashing** for priority calculation and Merkle commitments
- **Deterministic priority generation** ensuring consistent tree structure
- **Efficient rotations** for maintaining heap property
- **Comprehensive proof system** supporting both membership and non-membership
- **Memory-safe operations** using Cairo's ownership model

## Research Foundation

This implementation is based on the research paper ["Cartesian Merkle Trees"](https://arxiv.org/abs/2504.10944) which provides the theoretical foundation and formal analysis of the data structure.

## Documentation

For complete API documentation and implementation details, run:

```bash
scarb doc --build
```

## Testing

Run the test suite with:

```bash
snforge test
```

The implementation includes comprehensive tests covering:

- Basic tree operations (insert, search, remove)
- Heap property maintenance through rotations
- Merkle hash consistency
- Proof generation and verification
- Edge cases and error conditions

## License

This implementation follows the research outlined in the linked paper and provides a practical Cairo implementation for blockchain applications.
