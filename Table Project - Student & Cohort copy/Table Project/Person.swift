import Foundation

class Person: Codable, FirebaseItem {
    var name: String // = ""
    var cohort: String
    var recordIdentifier = ""
    
    //initializer
    init(name: String, cohort: String) {
        self.name = name
        self.cohort = cohort
        
        // Fancy way to intiliaze
        //(self.name, self.cohort) = (name, cohort)
    }
}
