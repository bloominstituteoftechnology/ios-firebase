import Foundation

class Model {
    static let shared = Model()
    private init() {}
    
    var students: [Student] = []
    
    // MARK: Core Data Source Methods
    
    func numberOfItems() -> Int {
        return students.count
    }
    
    func device(at indexPath: IndexPath) -> Device {
        return students[indexPath.row]
    }
    
    // MARK: Core Database Management Methods
    
    
    
    func addNewDevice(completion: @escaping () -> Void) {
        let student = Student.
        
        //append it to our devices array, updating our local model <--- locally
        devices.append(device)
        
        // save it by pushing it to Firebase <-- remotely
        Firebase<Device>.save(item: device) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
    
    
    
    func deleteDevice(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let device = devices[indexPath.row]
        //delete locally
        devices.remove(at: indexPath.row)
        
        //delete remotely
        Firebase<Device>.delete(item: device) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
    
    
    
    func updateDevice(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let device = devices[indexPath.row]
        
        // locally
        device.uuid = UUID().uuidString
        
        //remotely
        Firebase<Device>.save(item: device) { success in
            guard success else { return }
            DispatchQueue.main.async { completion() }
        }
    }
}
