import Foundation

class Model {
    // MARK: Singleton
    static let shared = Model()
    private init() {}
    
    // MARK: Core Storage
    // Store our people
    var people: [Person] = []
    

    // MARK: - Model Management (CRUD)
    // Basic information that helps our model to manage people and add to our table
    
    // count - R
    func numberOfPeople() -> Int {
        return people.count
    }
    
    // find which person is at an index - R
    func person(at indexPath: IndexPath) -> Person {
        return people[indexPath.row]
    }
        //func person(at index: Int) -> Person {
            //return people[index]
        //}
    
    // move - U
    func movePerson(at index: Int, to newIndex: Int) {
        // TODO: Implement this
    }
    
    // Set people to the array
    func setPeople( _ people: [Person]) {
        self.people = people
    }

    // MARK: Core Database Management Methods
    
    // add person - C
    func addNewPerson(person: Person, completion: @escaping () -> Void) {
       
        // Local: append to our people array on the model
        people.append(person)
        
        // Remote: save it by sending to firebase
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            
            DispatchQueue.main.async { completion() }
        }
    }
    
    // remove person - D
    func removePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        
        // Get a person
        let person = people[indexPath.row]
        
        // Local
        people.remove(at: indexPath.row)
        
        // Remote
        Firebase<Person>.delete(item: person) { success in
            guard success else { return }
            
            DispatchQueue.main.async { completion() }
        }
    }
    
    // Call this to update any changes that were made in the detail view on Firebase
    func updatePerson(person: Person, indexPath: IndexPath, completion: @escaping () -> Void) {
        
        // Remote
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            
            DispatchQueue.main.async { completion() }
        }
        
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
