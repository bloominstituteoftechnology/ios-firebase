import Foundation

class Model {
    static let shared = Model()
    private init() {}
    var delegate: ModelUpdateClient?
    
    var persons: [Person] = []
    
    func count() -> Int {
        return persons.count
    }
    
    func person(at indexPath: IndexPath) -> Person {
        return persons[indexPath.row]
    }
    
    func add(person: Person, completion: @escaping () -> Void ) {
        persons.append(person)
        delegate?.modelDidUpdate()
        
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func delete(at indexPath: IndexPath, completion: @escaping () -> Void ) {
        let person = persons[indexPath.row]
        persons.remove(at: indexPath.row)
        
        Firebase<Person>.delete(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func update(person: Person, completion: @escaping () -> Void ) {
        
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
}
