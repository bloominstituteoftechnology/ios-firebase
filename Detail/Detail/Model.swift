import Foundation

class Model {
    static let shared = Model()
    private init() {}
    var delegate: ModelUpdateClient?
    
    var persons: [Person] = []
    
    func count() -> Int {
        return persons.count
    }
    // original person func
    func person(forIndex index: Int) -> Person {
        return persons[index]
    }
//  person func that has error
//  func person(at indexPath: IndexPath) -> Person {
//        return persons[indexPath.row]
//    }
    // MARK: Core Database Management Methods
    func add(person: Person, completion: @escaping () -> Void) {
        //appending locally
        persons.append(person)
        delegate?.modelDidUpdate()
        
        //pushing to firebase
        Firebase<Person>.save(item: person) { success in
            guard success else {return}
            DispatchQueue.main.async { completion() }
        }
    }
    
    func delete(at indexPath: IndexPath, completion: @escaping () -> Void) {
        //local change
        let person = persons[indexPath.row]
        persons.remove(at: indexPath.row)
        delegate?.modelDidUpdate()

        
        //in firebase change
        Firebase<Person>.delete(item: person) { success in
            guard success else {return}
            DispatchQueue.main.async { completion() }
        }
    }
    
    func updatePerson(at indexPath: IndexPath, completion: @escaping () -> Void) {
        //local
        let person = persons[indexPath.row]
        delegate?.modelDidUpdate()

        
        //firebase
        Firebase<Person>.save(item: person) { success in
            guard success else {return}
            DispatchQueue.main.async { completion() }
        }
    }
}
