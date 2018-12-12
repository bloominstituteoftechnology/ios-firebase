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
    
    func add(person: Person, with completion: @escaping () -> Void) {
        persons.append(person)
        delegate?.modelDidUpdate()
        Firebase<Person>.save(item: person) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func removePerson(indexPath: IndexPath, completion: @escaping () -> Void) {
        let person = persons.remove(at: indexPath.row)
        Firebase<Person>.delete(item: person) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func updatePerson(at indexPath: IndexPath, with completion: @escaping () -> Void) {
        let person = persons[indexPath.row]
        Firebase<Person>.save(item: person) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
}
