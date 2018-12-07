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
    
    func personAt(at indexPath: IndexPath) -> Person {
        return persons[indexPath.row]
    }
    
//    func add(person: Person) {
//        persons.append(person)
//        delegate?.modelDidUpdate()
//    }
    
    // MARK: Core Database Management Methods
    
    func addNewPerson(person: Person, completion: @escaping () -> Void) {
//        // FIXME:
        let person = person
        //append to robots array, updating our local model
        persons.append(person)
        // save it sending to firebase
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }

    }
    func deletePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        // FIXME:
        //local
        let person = persons[indexPath.row]
        persons.remove(at: indexPath.row)
        //remote
        Firebase<Person>.delete(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
    func updatePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        // FIXME:
        //local
        let person = persons[indexPath.row]
        //remote
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
    
}
