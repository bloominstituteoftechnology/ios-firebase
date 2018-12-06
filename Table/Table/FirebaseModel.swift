import Foundation

class Model {
    static let shared = Model()
    private init() {}
    
    var students: [Student] = []
    
    // MARK: Core Data Source Methods
    
    func numberOfItems() -> Int {
        return students.count
    }
    
    func student(at indexPath: IndexPath) -> Student {
        return students[indexPath.row]
    }
    
    // MARK: Core Database Management Methods
    
    
    
    func addNewStudent(student: Student, completion: @escaping () -> Void) {
       let student = student
        //append it to our students array, updating our local model <--- locally
        students.append(student)
        
        // save it by pushing it to Firebase <-- remotely
        Firebase<Student>.save(item: student) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
    
    
    
    func deleteStudent(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let student = students[indexPath.row]
        //delete locally
        students.remove(at: indexPath.row)
        
        //delete remotely
        Firebase<Student>.delete(item: student) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
    
    
    
    func updateStudent(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let student = students[indexPath.row]
        
        // locally
        student.uuid = UUID().uuidString
        
        //remotely
        Firebase<Student>.save(item: student) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
}
