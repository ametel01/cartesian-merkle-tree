//! Example contract demonstrating how to use the CMTree component

#[starknet::contract]
pub mod CMTreeExampleContract {
    use crate::components::cmtree_component::cmtree_component;
    use crate::components::cmtree_component::cmtree_component::InternalFunctions;

    component!(path: cmtree_component, storage: cmtree, event: CMTreeEvent);

    // Embed the CMTree component's external functions
    #[abi(embed_v0)]
    impl CMTreeImpl = cmtree_component::CMTree<ContractState>;

    // Access to internal functions
    impl CMTreeInternalImpl = InternalFunctions<ContractState>;

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
