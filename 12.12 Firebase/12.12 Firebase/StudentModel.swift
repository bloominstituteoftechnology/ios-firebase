import Foundation

class StudentModel {
    static let shared = StudentModel()
    private init() {}
    
    private var students: [Student] = []
    
    var numberOfStudents: Int {
        return students.count
    }
    
    func student(at indexPath: IndexPath) -> Student {
        return students[indexPath.row]
    }
    
    func setStudents(_ students: [Student]) {
        self.students = students
        
    }
    
    func addNewStudent(completion: @escaping () -> Void ) {
        let student = StudentViewController.nameLabel.text
        students.append(student)
        Firebase<Student>.save(item: student) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func delete(at indexPath: IndexPath, completion: @escaping () -> Void ) {
        let student = students.remove(at: indexPath.row)
        //delet from database
        Firebase<Student>.delete(item: student) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func updateDevice(at indexPath: IndexPath, completion: @escaping () -> Void ) {
        let student = students[indexPath.row]
        
        Firebase<Student>.save(item: student) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
