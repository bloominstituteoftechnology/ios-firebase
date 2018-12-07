import Foundation

class Person {
    var name: String
    var cohort: String
    
    init(name: String, cohort: String) {
        self.name = name
        self.cohort = cohort
        // (self.name, self.cohort) = (name, cohort)
    }
}
