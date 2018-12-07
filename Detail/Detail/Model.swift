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
    
    func add(person: Person, completion: @escaping () -> Void) {
        persons.append(person)

        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
        delegate?.modelDidUpdate()
    }
    
    func deletePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let person = persons[indexPath.row]
        //in local model
        persons.remove(at: indexPath.row)
        
        //in firebase
        Firebase<Person>.delete(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
       // delegate?.modelDidUpdate()

    }
    
    func updatePerson(for person: Person, completion: @escaping () -> Void) {
        //in local model
        //update without the index path, updating in detail so no indexPath
        //let person = persons[indexPath.row]

        //in firebase
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
        //delegate?.modelDidUpdate()

    }
}
