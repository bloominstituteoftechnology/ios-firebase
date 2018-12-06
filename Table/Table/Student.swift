import Foundation

class Student: Codable, FirebaseItem {
    let name: String
    let cohort: String
    var uuid = UUID().uuidString
    var recordIdentifier = ""
}
