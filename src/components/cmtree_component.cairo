//! On-chain Cartesian Merkle Tree contract implementation
//!
//! This contract provides persistent storage for CMT nodes and operations,
//! allowing for on-chain tree manipulation with gas-efficient storage patterns.

#[derive(Drop, Copy, Debug, Serde, starknet::Store)]
pub struct CMTNodeStorage {
    /// The key value for BST ordering and identification
    pub key: felt252,
    /// Randomized priority for heap property (derived from key)
    pub priority: felt252,
    /// Merkle hash commitment to this node and its children
    pub merkle_hash: felt252,
    /// Storage index of the left child node (0 = no child)
    pub left_child_index: u64,
    /// Storage index of the right child node (0 = no child)
    pub right_child_index: u64,
}

#[derive(Drop, Clone, Debug, Serde)]
pub struct ProofData {
    pub root: felt252,
    pub siblings: Array<felt252>,
    pub siblings_length: u32,
    pub direction_bits: felt252,
    pub existence: bool,
    pub key: felt252,
    pub non_existence_key: felt252,
}

#[starknet::interface]
pub trait ICMTree<TContractState> {
    fn insert(ref self: TContractState, key: felt252);
    fn remove(ref self: TContractState, key: felt252) -> bool;
    fn search(self: @TContractState, key: felt252) -> bool;
    fn get_root_hash(self: @TContractState) -> felt252;
    fn generate_proof(self: @TContractState, key: felt252) -> ProofData;
    fn verify_proof(
        self: @TContractState, proof: ProofData, root_hash: felt252, key: felt252,
    ) -> bool;
}

#[starknet::component]
pub mod cmtree_component {
    use core::array::ArrayTrait;
    use core::hash::HashStateTrait;
    use core::poseidon::PoseidonTrait;
    use core::traits::{DivRem, Into};
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use super::{CMTNodeStorage, ICMTree, ProofData};

    #[storage]
    pub struct Storage {
        /// Index of the root node (0 = empty tree)
        root_index: u64,
        /// Counter for allocating new node indices
        next_node_index: u64,
        /// Mapping from index to node data
        nodes: Map<u64, CMTNodeStorage>,
        /// Stack of deleted indices for reuse (stored as linked list)
        /// Each deleted index points to the next deleted index
        deleted_indices_head: u64,
        deleted_indices: Map<u64, u64>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    #[embeddable_as(CMTree)]
    impl CMTreeImpl<
        TContractState, +HasComponent<TContractState>,
    > of super::ICMTree<ComponentState<TContractState>> {
        fn insert(ref self: ComponentState<TContractState>, key: felt252) {
            let priority = calculate_priority(key);
            let merkle_hash = calculate_merkle_hash(key, 0, 0);

            let new_node_index = self.allocate_node_index();
            let new_node = CMTNodeStorage {
                key, priority, merkle_hash, left_child_index: 0, right_child_index: 0,
            };
            self.nodes.entry(new_node_index).write(new_node);

            let root_index = self.root_index.read();
            if root_index == 0 {
                self.root_index.write(new_node_index);
            } else {
                let new_root_index = self.insert_node(root_index, new_node_index, key, priority);
                self.root_index.write(new_root_index);
            }
        }

        fn remove(ref self: ComponentState<TContractState>, key: felt252) -> bool {
            let root_index = self.root_index.read();
            if root_index == 0 {
                return false;
            }

            let (new_root_index, removed) = self.remove_node(root_index, key);
            self.root_index.write(new_root_index);
            removed
        }

        fn search(self: @ComponentState<TContractState>, key: felt252) -> bool {
            let root_index = self.root_index.read();
            if root_index == 0 {
                return false;
            }
            self.search_node(root_index, key)
        }

        fn get_root_hash(self: @ComponentState<TContractState>) -> felt252 {
            let root_index = self.root_index.read();
            if root_index == 0 {
                return 0;
            }
            let root = self.nodes.entry(root_index).read();
            root.merkle_hash
        }

        fn generate_proof(self: @ComponentState<TContractState>, key: felt252) -> ProofData {
            let root_index = self.root_index.read();
            let root_hash = self.get_root_hash();

            if root_index == 0 {
                return ProofData {
                    root: root_hash,
                    siblings: ArrayTrait::new(),
                    siblings_length: 0,
                    direction_bits: 0,
                    existence: false,
                    key,
                    non_existence_key: 0,
                };
            }

            let mut siblings = ArrayTrait::new();
            let mut direction_bits = 0_felt252;
            let mut siblings_count = 0_u32;

            let (found, non_existence_key) = self
                .generate_proof_internal(
                    root_index, key, ref siblings, ref direction_bits, ref siblings_count,
                );

            ProofData {
                root: root_hash,
                siblings,
                siblings_length: siblings_count,
                direction_bits,
                existence: found,
                key,
                non_existence_key: if found {
                    0
                } else {
                    non_existence_key
                },
            }
        }

        fn verify_proof(
            self: @ComponentState<TContractState>,
            proof: ProofData,
            root_hash: felt252,
            key: felt252,
        ) -> bool {
            if proof.root != root_hash {
                return false;
            }

            if proof.siblings_length == 0 {
                return !proof.existence;
            }

            let mut current_hash = if proof.existence {
                if proof.siblings_length < 2 {
                    return false;
                }
                let left_hash = *proof.siblings.at(0);
                let right_hash = *proof.siblings.at(1);
                calculate_merkle_hash(key, left_hash, right_hash)
            } else {
                if proof.siblings_length < 2 {
                    return false;
                }
                let left_hash = *proof.siblings.at(0);
                let right_hash = *proof.siblings.at(1);
                calculate_merkle_hash(proof.non_existence_key, left_hash, right_hash)
            };

            let mut i = 2;
            let mut direction_bits = proof.direction_bits;

            while i < proof.siblings_length {
                let node_key = *proof.siblings.at(i);
                let sibling_hash = *proof.siblings.at(i + 1);

                let direction_bits_u256: u256 = direction_bits.into();
                let (new_direction_bits, remainder) = DivRem::div_rem(direction_bits_u256, 2);
                let use_original_order = remainder == 0;
                direction_bits = new_direction_bits.try_into().unwrap();

                current_hash =
                    if use_original_order {
                        calculate_merkle_hash(node_key, current_hash, sibling_hash)
                    } else {
                        calculate_merkle_hash(node_key, sibling_hash, current_hash)
                    };

                i += 2;
            }

            current_hash == root_hash
        }
    }

    // Internal helper functions
    #[generate_trait]
    pub impl InternalFunctions<
        TContractState, +HasComponent<TContractState>,
    > of InternalFunctionsTrait<TContractState> {
        fn initializer(ref self: ComponentState<TContractState>) {
            self.root_index.write(0);
            self.next_node_index.write(1); // Start from 1, 0 means null
            self.deleted_indices_head.write(0); // 0 means no deleted indices
        }
        fn allocate_node_index(ref self: ComponentState<TContractState>) -> u64 {
            // First check if there are any deleted indices to reuse
            let deleted_head = self.deleted_indices_head.read();
            if deleted_head != 0 {
                // Pop from the deleted indices stack
                let next_deleted = self.deleted_indices.entry(deleted_head).read();
                self.deleted_indices_head.write(next_deleted);
                // Clear the mapping entry for the reused index
                self.deleted_indices.entry(deleted_head).write(0);
                deleted_head
            } else {
                // Allocate a new index
                let index = self.next_node_index.read();
                self.next_node_index.write(index + 1);
                index
            }
        }

        fn free_node_index(ref self: ComponentState<TContractState>, index: u64) {
            // Push to the deleted indices stack
            let old_head = self.deleted_indices_head.read();
            self.deleted_indices.entry(index).write(old_head);
            self.deleted_indices_head.write(index);
        }

        fn read_node(self: @ComponentState<TContractState>, index: u64) -> CMTNodeStorage {
            self.nodes.entry(index).read()
        }

        fn write_node(ref self: ComponentState<TContractState>, index: u64, node: CMTNodeStorage) {
            self.nodes.entry(index).write(node);
        }

        fn update_node_hash(ref self: ComponentState<TContractState>, index: u64) -> felt252 {
            if index == 0 {
                return 0;
            }

            let mut node = self.read_node(index);
            let left_hash = if node.left_child_index == 0 {
                0
            } else {
                self.read_node(node.left_child_index).merkle_hash
            };

            let right_hash = if node.right_child_index == 0 {
                0
            } else {
                self.read_node(node.right_child_index).merkle_hash
            };

            node.merkle_hash = calculate_merkle_hash(node.key, left_hash, right_hash);
            self.write_node(index, node);
            node.merkle_hash
        }

        fn insert_node(
            ref self: ComponentState<TContractState>,
            current_index: u64,
            new_index: u64,
            new_key: felt252,
            new_priority: felt252,
        ) -> u64 {
            let mut current = self.read_node(current_index);
            let new_key_u256: u256 = new_key.into();
            let current_key_u256: u256 = current.key.into();

            if new_key_u256 < current_key_u256 {
                if current.left_child_index == 0 {
                    current.left_child_index = new_index;
                    self.write_node(current_index, current);
                    self.update_node_hash(current_index);
                    self.restore_heap_property(current_index, true)
                } else {
                    let new_left_index = self
                        .insert_node(current.left_child_index, new_index, new_key, new_priority);
                    current.left_child_index = new_left_index;
                    self.write_node(current_index, current);
                    self.update_node_hash(current_index);
                    self.restore_heap_property(current_index, true)
                }
            } else if current.right_child_index == 0 {
                current.right_child_index = new_index;
                self.write_node(current_index, current);
                self.update_node_hash(current_index);
                self.restore_heap_property(current_index, false)
            } else {
                let new_right_index = self
                    .insert_node(current.right_child_index, new_index, new_key, new_priority);
                current.right_child_index = new_right_index;
                self.write_node(current_index, current);
                self.update_node_hash(current_index);
                self.restore_heap_property(current_index, false)
            }
        }

        fn restore_heap_property(
            ref self: ComponentState<TContractState>, node_index: u64, check_left: bool,
        ) -> u64 {
            let node = self.read_node(node_index);

            if check_left {
                if node.left_child_index != 0 {
                    let left_child = self.read_node(node.left_child_index);
                    let left_priority_u256: u256 = left_child.priority.into();
                    let node_priority_u256: u256 = node.priority.into();

                    if left_priority_u256 > node_priority_u256 {
                        self.right_rotate(node_index)
                    } else {
                        node_index
                    }
                } else {
                    node_index
                }
            } else if node.right_child_index != 0 {
                let right_child = self.read_node(node.right_child_index);
                let right_priority_u256: u256 = right_child.priority.into();
                let node_priority_u256: u256 = node.priority.into();

                if right_priority_u256 > node_priority_u256 {
                    self.left_rotate(node_index)
                } else {
                    node_index
                }
            } else {
                node_index
            }
        }

        fn right_rotate(ref self: ComponentState<TContractState>, node_index: u64) -> u64 {
            let mut node = self.read_node(node_index);
            let left_index = node.left_child_index;
            assert!(left_index != 0, "Cannot right rotate without left child");

            let mut left_child = self.read_node(left_index);

            // Perform rotation
            node.left_child_index = left_child.right_child_index;
            left_child.right_child_index = node_index;

            // Update nodes and hashes
            self.write_node(node_index, node);
            self.write_node(left_index, left_child);
            self.update_node_hash(node_index);
            self.update_node_hash(left_index);

            left_index
        }

        fn left_rotate(ref self: ComponentState<TContractState>, node_index: u64) -> u64 {
            let mut node = self.read_node(node_index);
            let right_index = node.right_child_index;
            assert!(right_index != 0, "Cannot left rotate without right child");

            let mut right_child = self.read_node(right_index);

            // Perform rotation
            node.right_child_index = right_child.left_child_index;
            right_child.left_child_index = node_index;

            // Update nodes and hashes
            self.write_node(node_index, node);
            self.write_node(right_index, right_child);
            self.update_node_hash(node_index);
            self.update_node_hash(right_index);

            right_index
        }

        fn search_node(
            self: @ComponentState<TContractState>, node_index: u64, key: felt252,
        ) -> bool {
            if node_index == 0 {
                return false;
            }

            let node = self.read_node(node_index);

            if node.key == key {
                return true;
            }

            let key_u256: u256 = key.into();
            let node_key_u256: u256 = node.key.into();

            if key_u256 < node_key_u256 {
                self.search_node(node.left_child_index, key)
            } else {
                self.search_node(node.right_child_index, key)
            }
        }

        fn remove_node(
            ref self: ComponentState<TContractState>, node_index: u64, key: felt252,
        ) -> (u64, bool) {
            if node_index == 0 {
                return (0, false);
            }

            let mut node = self.read_node(node_index);
            let key_u256: u256 = key.into();
            let node_key_u256: u256 = node.key.into();

            if key == node.key {
                // Found node to remove
                if node.left_child_index == 0 && node.right_child_index == 0 {
                    // Leaf node
                    self.free_node_index(node_index);
                    (0, true)
                } else if node.left_child_index != 0 && node.right_child_index == 0 {
                    // Only left child
                    self.free_node_index(node_index);
                    (node.left_child_index, true)
                } else if node.left_child_index == 0 && node.right_child_index != 0 {
                    // Only right child
                    self.free_node_index(node_index);
                    (node.right_child_index, true)
                } else {
                    // Both children - rotate to leaf and remove
                    let new_root = self.rotate_to_leaf_and_remove(node_index, key);
                    (new_root, true)
                }
            } else if key_u256 < node_key_u256 {
                let (new_left, removed) = self.remove_node(node.left_child_index, key);
                if removed {
                    node.left_child_index = new_left;
                    self.write_node(node_index, node);
                    self.update_node_hash(node_index);
                }
                (node_index, removed)
            } else {
                let (new_right, removed) = self.remove_node(node.right_child_index, key);
                if removed {
                    node.right_child_index = new_right;
                    self.write_node(node_index, node);
                    self.update_node_hash(node_index);
                }
                (node_index, removed)
            }
        }

        fn rotate_to_leaf_and_remove(
            ref self: ComponentState<TContractState>, node_index: u64, key: felt252,
        ) -> u64 {
            let node = self.read_node(node_index);

            if node.left_child_index == 0 && node.right_child_index == 0 {
                // Leaf node
                self.free_node_index(node_index);
                0
            } else if node.left_child_index != 0 && node.right_child_index == 0 {
                // Only left child
                let rotated = self.right_rotate(node_index);
                let mut rotated_node = self.read_node(rotated);
                let (new_right, _) = self.remove_node(rotated_node.right_child_index, key);
                rotated_node.right_child_index = new_right;
                self.write_node(rotated, rotated_node);
                self.update_node_hash(rotated);
                rotated
            } else if node.left_child_index == 0 && node.right_child_index != 0 {
                // Only right child
                let rotated = self.left_rotate(node_index);
                let mut rotated_node = self.read_node(rotated);
                let (new_left, _) = self.remove_node(rotated_node.left_child_index, key);
                rotated_node.left_child_index = new_left;
                self.write_node(rotated, rotated_node);
                self.update_node_hash(rotated);
                rotated
            } else {
                // Both children exist
                let left_child = self.read_node(node.left_child_index);
                let right_child = self.read_node(node.right_child_index);
                let left_priority_u256: u256 = left_child.priority.into();
                let right_priority_u256: u256 = right_child.priority.into();

                if left_priority_u256 > right_priority_u256 {
                    let rotated = self.right_rotate(node_index);
                    let mut rotated_node = self.read_node(rotated);
                    let (new_right, _) = self.remove_node(rotated_node.right_child_index, key);
                    rotated_node.right_child_index = new_right;
                    self.write_node(rotated, rotated_node);
                    self.update_node_hash(rotated);
                    rotated
                } else {
                    let rotated = self.left_rotate(node_index);
                    let mut rotated_node = self.read_node(rotated);
                    let (new_left, _) = self.remove_node(rotated_node.left_child_index, key);
                    rotated_node.left_child_index = new_left;
                    self.write_node(rotated, rotated_node);
                    self.update_node_hash(rotated);
                    rotated
                }
            }
        }

        fn generate_proof_internal(
            self: @ComponentState<TContractState>,
            node_index: u64,
            key: felt252,
            ref siblings: Array<felt252>,
            ref direction_bits: felt252,
            ref siblings_count: u32,
        ) -> (bool, felt252) {
            let node = self.read_node(node_index);

            if node.key == key {
                // Found target node
                let left_hash = if node.left_child_index == 0 {
                    0
                } else {
                    self.read_node(node.left_child_index).merkle_hash
                };

                let right_hash = if node.right_child_index == 0 {
                    0
                } else {
                    self.read_node(node.right_child_index).merkle_hash
                };

                siblings.append(left_hash);
                siblings.append(right_hash);
                siblings_count += 2;

                let left_u256: u256 = left_hash.into();
                let right_u256: u256 = right_hash.into();
                let is_swapped = left_u256 > right_u256;
                direction_bits =
                    calculate_direction_bit(direction_bits, siblings_count, is_swapped);

                (true, 0)
            } else {
                let key_u256: u256 = key.into();
                let node_key_u256: u256 = node.key.into();

                let (found, non_existence_key, go_left) = if key_u256 < node_key_u256 {
                    if node.left_child_index == 0 {
                        // Non-existence proof
                        let left_hash = 0;
                        let right_hash = if node.right_child_index == 0 {
                            0
                        } else {
                            self.read_node(node.right_child_index).merkle_hash
                        };

                        siblings.append(left_hash);
                        siblings.append(right_hash);
                        siblings_count += 2;

                        let left_u256: u256 = left_hash.into();
                        let right_u256: u256 = right_hash.into();
                        direction_bits =
                            calculate_direction_bit(
                                direction_bits, siblings_count, left_u256 > right_u256,
                            );

                        (false, node.key, true)
                    } else {
                        let (found, non_existence_key) = self
                            .generate_proof_internal(
                                node.left_child_index,
                                key,
                                ref siblings,
                                ref direction_bits,
                                ref siblings_count,
                            );
                        (found, non_existence_key, true)
                    }
                } else if node.right_child_index == 0 {
                    // Non-existence proof
                    let left_hash = if node.left_child_index == 0 {
                        0
                    } else {
                        self.read_node(node.left_child_index).merkle_hash
                    };
                    let right_hash = 0;

                    siblings.append(left_hash);
                    siblings.append(right_hash);
                    siblings_count += 2;

                    let left_u256: u256 = left_hash.into();
                    let right_u256: u256 = right_hash.into();
                    direction_bits =
                        calculate_direction_bit(
                            direction_bits, siblings_count, left_u256 > right_u256,
                        );

                    (false, node.key, false)
                } else {
                    let (found, non_existence_key) = self
                        .generate_proof_internal(
                            node.right_child_index,
                            key,
                            ref siblings,
                            ref direction_bits,
                            ref siblings_count,
                        );
                    (found, non_existence_key, false)
                };

                // Add sibling info for path
                if (found && (node.key != key)) || (!found && (node.key != non_existence_key)) {
                    siblings.append(node.key);

                    let sibling_hash = if go_left {
                        if node.right_child_index == 0 {
                            0
                        } else {
                            self.read_node(node.right_child_index).merkle_hash
                        }
                    } else if node.left_child_index == 0 {
                        0
                    } else {
                        self.read_node(node.left_child_index).merkle_hash
                    };

                    siblings.append(sibling_hash);
                    siblings_count += 2;

                    let child_hash = if go_left {
                        if node.left_child_index == 0 {
                            0
                        } else {
                            self.read_node(node.left_child_index).merkle_hash
                        }
                    } else if node.right_child_index == 0 {
                        0
                    } else {
                        self.read_node(node.right_child_index).merkle_hash
                    };

                    let child_u256: u256 = child_hash.into();
                    let sibling_u256: u256 = sibling_hash.into();
                    let is_swapped = child_u256 > sibling_u256;
                    direction_bits =
                        calculate_direction_bit(direction_bits, siblings_count, is_swapped);
                }

                (found, non_existence_key)
            }
        }
    }

    // Helper functions outside the impl block
    fn calculate_priority(key: felt252) -> felt252 {
        let mut state = PoseidonTrait::new();
        state = state.update(key);
        state.finalize()
    }

    fn calculate_merkle_hash(
        key: felt252, left_child_mh: felt252, right_child_mh: felt252,
    ) -> felt252 {
        let mut state = PoseidonTrait::new();
        state = state.update(key);

        let left_u256: u256 = left_child_mh.into();
        let right_u256: u256 = right_child_mh.into();

        if left_u256 < right_u256 {
            state = state.update(left_child_mh);
            state = state.update(right_child_mh);
        } else {
            state = state.update(right_child_mh);
            state = state.update(left_child_mh);
        }

        state.finalize()
    }

    fn calculate_direction_bit(
        direction_bits: felt252, siblings_count: u32, is_swapped: bool,
    ) -> felt252 {
        let direction_bits_u256: u256 = direction_bits.into();
        let mut result = direction_bits_u256;
        if siblings_count != 2 {
            result = result * 2;
        }
        if is_swapped {
            result = result + 1;
        }
        result.try_into().unwrap()
    }
}
