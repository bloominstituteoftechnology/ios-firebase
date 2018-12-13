import Foundation


class Person: Codable {
    var name: String
    var cohort: String
    
    init(name: String, cohort: String) {
        self.name = name
        self.cohort = cohort
    }
    
}
