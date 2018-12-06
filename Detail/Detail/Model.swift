import Foundation

class Model {
    static let shared = Model()
    private init() {}
    var delegate: ModelUpdateClient?
    
    private var persons: [Person] = []
    
    func count() -> Int {
        return persons.count
    }
    
    
    func person(at indexPath: IndexPath) -> Person {
        return persons[indexPath.row]
    }
    
    
    func addNewPerson(person: Person, completion: @escaping () -> Void) {
        persons.append(person)
        Firebase<Person>.save(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async {
                completion()
            }
        }
    
    
    func deletePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let person = persons[indexPath.row]
        
        persons.remove(at: indexPath.row)
        
        Firebase<Person>.delete(item: person) { success in
            guard success else { return }
            DispatchQueue.main.async {
                completion()
            }
        }
     }
        func updatePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
            let person = persons[indexPath.row]
            persons.append(person)
            
            Firebase<Person>.save(item: person) { success in
                guard let success else { return }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
  }
}
