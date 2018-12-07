import Foundation

class Person: Codable, FirebaseItem {
    
    var name: String
    var cohort: String
    var uuid = UUID().uuidString
    var recordIdentifier = ""
    
    init(name: String, cohort: String) {
        self.name = name
        self.cohort = cohort
        
        // self is the instance of this class 
    }
}
