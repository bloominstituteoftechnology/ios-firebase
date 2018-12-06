import Foundation

class Model {
    static let shared = Model()
    private init() {}
    var delegate: ModelUpdateClient?
    
    private var persons: [Person] = []
    
    func count() -> Int {
        return persons.count
    }
    
    func person(forIndex index: Int) -> Person {
        return persons[index]
    }
    
    // MARK: Core Database Management Methods
    
    // TODO: remove this when addNewPerson is complete and working
    func add(person: Person) {
        persons.append(person)
        delegate?.modelDidUpdate()
    }
    
    func addNewDevice(person: Person, completion: @escaping () -> Void) {
        
        let person = person
        
        // append it to our devices array, updating our local model <-- local
        persons.append(person)
        
        // save it by pushing it to the firebase thing <-- remote
        Firebase<Person>.save(item: person){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        
    }
    
    func deletePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        //
        let person = persons[indexPath.row]
        
        //
        persons.remove(at: indexPath.row)
        
        // remote
        Firebase<Person>.delete(item: person){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        
    }
    
    
    func updatePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        //
        let person = persons[indexPath.row]
        
        // TODO: do we need this?
        //device.uuid = UUID().uuidString
        
        // remote
        Firebase<Person>.save(item: person){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        
    }
}
