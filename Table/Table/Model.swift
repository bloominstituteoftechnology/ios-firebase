import Foundation

class ssModel {
    // MARK: Singleton
    static let shared = Model()
    private init() {}
    
    // MARK: Core Storage
    var people: [Person] = []
    
    // MARK: Model CRUD
    // CRUD <-- basic database management tasks
    // C create, R read, U update, D delete
    
    // C
    func add(person: Person) {
        people.append(person)
        saveData()
    }
    
    // D
    func remove(personAtIndex index: Int) {
        people.remove(at: index)
        saveData()
    }
    
    // R
    func numberOfPeople() -> Int {
        return people.count
    }
    
    // R
    func person(at index: Int) -> Person {
        return people[index]
    }
    
    // U
    func movePerson(at index: Int, to newIndex: Int) {
        // TODO: Implement this
    }
    
    // MARK: Data Persistence
    
    func saveData() {
        // TODO: Implement this
    }
    
    func loadData() {
        // TODO: Implement this
    }
}
