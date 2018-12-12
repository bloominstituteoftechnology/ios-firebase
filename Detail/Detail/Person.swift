import Foundation

class Person: Codable, FirebaseItem {
    var recordIdentifier: String = ""
    
    var name: String
    var cohort: String
    
    init(name: String, cohort: String) {
        (self.name, self.cohort) = (name, cohort)
    }
}
