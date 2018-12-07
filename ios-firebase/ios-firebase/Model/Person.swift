import Foundation

class Person: Codable, FirebaseItem {
    
    var name: String
    var cohort: String
    var recordIdentifier: String = ""
    
    init(name: String, cohort: String?) {
        let cohort = cohort ?? ""
        (self.name, self.cohort) = (name, cohort)
    }
}
