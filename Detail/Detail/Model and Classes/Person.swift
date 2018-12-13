import Foundation

class Person {
    var name: String
    var cohort: String
    var recordIdentifier: String = ""
    
    init(name: String, cohort: String) {
        (self.name, self.cohort) = (name, cohort)
    }
}
