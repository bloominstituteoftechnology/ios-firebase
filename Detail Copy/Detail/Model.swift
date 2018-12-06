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
        // save it by posting <-- remote
        Firebase<Person>.save(item: person) { success in
            guard success else {return}
            DispatchQueue.main.async {completion()}
        }
        
        persons.append(person)
        delegate?.modelDidUpdate()
    }
    func delete(indexPath: IndexPath, completion: @escaping () -> Void) {
        let person = persons[indexPath.row]
        Firebase<Person>.delete(item: person) { (success) in
            guard success else {return}
            DispatchQueue.main.async {completion()}
        }
        persons.remove(at: indexPath.row)
    }
}
