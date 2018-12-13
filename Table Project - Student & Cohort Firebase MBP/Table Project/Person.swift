import Foundation

class Person: Codable, FirebaseItem {
    var recordIdentifier: String = ""
    
    var name: String // = ""
    var cohort: String
    
    //initializer
    init(name: String, cohort: String) {
        self.name = name
        self.cohort = cohort
        
        // Fancy way to intiliaze
        //(self.name, self.cohort) = (name, cohort)
    }
}
