// bookstore contract

// this is a simple bookstore
// Users should be able to add book to the store
// Users should be able to check all the books in the store
// Admin can decide to remove book from the store


#[starknet::interface]
trait IBookstore<TContractState> {
    fn add_book(ref self:TContractState, name:felt252, author:felt252, storage_number:u256);
    fn delete_book(ref self:TContractState, storage_number:u256);
    fn get_book(self: @TContractState, storage_number:u256) -> BookStore::Book;
}


#[starknet::contract]
mod BookStore {

    #[storage]
    struct Storage {
        shelf: LegacyMap::<u256, Book>
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Book {
        name: felt252,
        author: felt252
    }

    #[external(v0)]
    impl BookStore of super::IBookstore<ContractState> {
        fn add_book(ref self:ContractState, name: felt252, author: felt252, storage_number:u256) {
            let book = Book {
                name: name,
                author: author
            };
            self.shelf.write(storage_number, book);
        }

        fn get_book(self: @ContractState, storage_number: u256) -> Book {
            let book = self.shelf.read(storage_number);
            book
        }

        fn delete_book(ref self: ContractState, storage_number: u256) {
            self.shelf.write(storage_number, Book {name: '', author: ''});
        }
    }
}
