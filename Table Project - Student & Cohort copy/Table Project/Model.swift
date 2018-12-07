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
    func addNewPerson(person: Person, completion: @escaping () -> Void) {
        
        // Local: Append it to our devices array
        people.append(person)
        
        // Remote: Save it by sending it to firebase
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            
            // otherwise do the completion on the main thread
            DispatchQueue.main.async { completion() }
        }
    }
    
    func updatePerson(person: Person, completion: @escaping () -> Void ) {
        
        // Get a person
        //let person = people[indexPath.row]
        
        // Local - change the person string
        //person.name =
        
        // Remote
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
            
        }
    }
    
    // remove person - D
    func removePerson(at indexPath: IndexPath, completion: @escaping () -> Void ) {
        
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
