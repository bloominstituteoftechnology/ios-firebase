import Foundation

class Model {
    static let shared = Model()
    private init() {}
    var delegate: ModelUpdateClient?
    
     var persons: [Person] = []
    
    func count() -> Int {
        return persons.count
    }
    
    func person(forIndex index: Int) -> Person {
        return persons[index]
    }
//    func person(forIndex index: Int) -> Person {
//        return persons[index]
//    }
    
    func add(person: Person, completion: @escaping () -> Void) {
        persons.append(person)
        delegate?.modelDidUpdate()
        
        Firebase<Person>.save(item: person) { success in
            guard success else {return}
             DispatchQueue.main.async { completion() }
        }
    }
    
    func deletePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let person = persons[indexPath.row]
        persons.remove(at: indexPath.row)
        
        
        Firebase<Person>.delete(item: person) { success in
            guard success else {return}
            DispatchQueue.main.async {
                completion()
                
            }
            
        }
    }
    // Call this to replace the device with one with a new UUID
    func updatePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let person = persons[indexPath.row]
        
        // local
        let detailPerson = DetailViewController()
        person.name =  detailPerson.nameField.text ?? ""
        person.cohort = detailPerson.cohortField.text ?? ""
        
        // remote
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
    
}
