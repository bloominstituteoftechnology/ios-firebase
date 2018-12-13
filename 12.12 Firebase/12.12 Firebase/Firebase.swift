import Foundation

class Firebase<Item: Codable & FirebaseItem> {
    static var baseURL: URL! { return URL(string: "https://fir-app-aeb1c.firebaseio.com/") }
    
    static func requestURL(_ method: String, for recordIdentifier: String = "unknownid") -> URL {
        switch method {
        case "POST":
            // posting to the main data base and returns a new record identifier
            return baseURL.appendingPathExtension("json")
        case "DELETE", "PUT", "GET":
            // THESE WORK ON INdivual records, so u need to put record identifier in URL
            return baseURL.appendingPathComponent(recordIdentifier).appendingPathExtension("json")
        default:
            fatalError("unknown request method: \(method)")
        }
    }
    
    static func processRequest(method: String, for item: Item, with completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        // get URL requets
        var request = URLRequest(url: requestURL(method, for: item.recordIdentifier))
        request.httpMethod = method
        
        // Encode data -- do try catch block
        do {
            request.httpBody = try JSONEncoder().encode(item)
        } catch {
            NSLog("Unable to encode \(item): \(error)")
            completion(false)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            //check for error
            if let error = error {
                NSLog("server \(method) error: \(error)")
                completion(false)
                return
            }
            
            // Handle PUT, GET, DELETE
            guard method == "POST" else {
                completion(true)
                return
            }
            
            // process the POST request
            // fetch identifier from POST
            guard let data = data else {
                NSLog("Invalid server response data")
                completion(false)
                return
            }
            
            // decode - with another do\, try catch block
            // POST request returns '["name: recordIdentifier]'. store the identifier
            
            
            do {
                let nameDict = try JSONDecoder().decode([String: String].self, from: data)
                guard let recordIdentifier = nameDict["name"] else {
                    completion(false)
                    return
                }
                // if we do have record identifeier we update it here
                item.recordIdentifier = recordIdentifier
                processRequest(method: "PUT", for: item)
                completion(true)
                
            } catch {
                NSLog("Error decoding JSON response: \(error)")
                completion(false)
                return
            }
        }
        dataTask.resume()
    }
    
    static func delete(item: Item, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        processRequest(method: "DELETE", for: item, with: completion)
    }
    
    static func save(item: Item, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        // check for record identifier
        switch item.recordIdentifier.isEmpty {
        case true: // new record --POST
            processRequest(method: "POST", for: item, with: completion)
        case false: // existing record, PUT
            processRequest(method: "PUT", for: item, with: completion)
        }
    }
    
    static func fetchRecords(completion: @escaping ([Item]?) -> Void) {
        let requestURL = baseURL.appendingPathExtension("json")
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            guard error == nil, let data = data else {
                if let error = error {
                    NSLog("Error fetching entries: \(error)")
                }
                completion(nil)
                return
            }
            
            // decode data -- do, try catch block
            do {
                // double checking infrom recieved is right
                let recordDict = try JSONDecoder().decode([String: Item].self, from: data)
                for (key, value) in recordDict {
                    value.recordIdentifier = key
                }
                let records = recordDict.map { $0.value}
                completion(records)
            } catch {
                NSLog("Error decoding recieved data: \(error)")
                completion([])
            }
        }
        dataTask.resume()
    }
}
