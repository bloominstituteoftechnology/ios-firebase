import Foundation

class Model {
    // MARK: Singleton
    static let shared = Model()
    private init() {}
    
    // MARK: Core Storage
    // Store our people
    var people: [Person] = []
    
    // Basic information that helps our model to manage people and add to our table
    
    // MARK: - Model Management (CRUD)
    
    // add person - C
    func add(person: Person) {
        people.append(person)
        saveData()
    }
    
    // remove person - D
    func remove(personAtIndex index: Int) {
        people.remove(at: index)
        saveData()
    }
    
    // count - R
    func numberOfPeople() -> Int {
        return people.count
    }
    
    // move - U
    func movePerson(at index: Int, to newIndex: Int) {
        // TODO: Implement this
    }
    
    // find which person is at an index - R
    func person(at index: Int) -> Person {
        return people[index]
    }
    
    // MARK: Data Persistence
    
    // save data
    func saveData() {
        // TODO: Implement this
        // This shows up in the Table of Contents to the right of Model.swift at the top to show you that you need to do something
    }
    
    // load data
    func loadData() {
        // TODO: Implement this
    }
    
    
}
