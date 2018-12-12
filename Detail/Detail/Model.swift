import Foundation

class Model {
    static let shared = Model()
    private init() {}
    var delegate: ModelUpdateClient?
    
    var persons: [Person] = []
    
    func count() -> Int {
        return persons.count
    }
//    original person func
    func person(forIndex index: Int) -> Person {
        return persons[index]
    
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
        
    }
}
