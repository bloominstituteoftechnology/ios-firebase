import Foundation

class Person: Codable, FirebaseItem {

    var name: String
    var cohort: String
    var recordIdentifier = ""
    
    init(name: String, cohort: String) {
        (self.name, self.cohort) = (name, cohort)
    }
}
