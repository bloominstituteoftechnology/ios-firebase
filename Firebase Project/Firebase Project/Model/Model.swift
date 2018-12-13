import Foundation

class Model {
    static let shared = Model()
    private init() {}
    var delegate: ModelUpdateClient?
    
    var persons: [Person] = []
    
    // MARK: Core Data Source Methods
    func count() -> Int {
        return persons.count
    }
    
    func person(at index: Int) -> Person {
        return persons[index]
    }
    
    // MARK: Core Database Management Methods
    func add(person: Person, completion: @escaping () -> Void)  {
        persons.append(person)
        delegate?.modelDidUpdate()
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func deletePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let person = persons[indexPath.row]
        persons.remove(at: indexPath.row)
        Firebase<Person>.delete(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
}


    

