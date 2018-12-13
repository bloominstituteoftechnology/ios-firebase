import Foundation

class Student {
    static let shared = Student()
    private init() {}
    
    var students: [StudentStyle] = []
}
