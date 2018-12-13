import Foundation

struct StudentStyle: Codable {
    
    static let shared = StudentStyle()
    private init() {}
    
    let name: String
    let phoneNumber: String
}
