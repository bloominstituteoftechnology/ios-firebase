import Foundation

class Model {
    static let shared = Model()
    private init() {}
    
    private var persons: [Person] = []
    
    func count() -> Int {
        return persons.count
    }
    
    func person(forIndex index: Int) -> Person {
       return persons[index]
    }
    
    func add(person: Person) {
        persons.append(person)
        
        Firebase<Person>.save(item: device) { success }
    }
}
