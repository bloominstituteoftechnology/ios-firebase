import Foundation

class Firebase<Item: Codable & FirebaseItem> {
    static var baseURL: URL!  { return URL(string: "https://cohort-2582d.firebaseio.com/") }
    
    
    static func requestURL(_ method: String, for recordIdentifier: String = "unknownid") -> URL {
        switch method {
        case "POST":
            // You post to the main DB. It will return a new record identifier
            return baseURL.appendingPathExtension("json")
        case "DELETE", "PUT", "GET":
           
            return baseURL
                .appendingPathComponent(recordIdentifier)
                .appendingPathExtension("json")
        default:
            fatalError("Unknown request method: \(method)")
        }
    }
    
    static func processRequest(
        method: String,
        for item: Item,
        with completion: @escaping (_ success: Bool) -> Void = { _ in }
        ) {
        
       
        var request = URLRequest(url: requestURL(method, for: item.recordIdentifier))
        request.httpMethod = method
        
       
        do {
            request.httpBody = try JSONEncoder().encode(item)
        } catch {
            NSLog("Unable to encode \(item): \(error)")
            completion(false)
            return
        }
        
        // Create data task to perform request
        let dataTask = URLSession.shared.dataTask(with: request) { data, _ , error in
            
            // Fail on error
            if let error = error {
                NSLog("Server \(method) error: \(error)")
                completion(false)
                return
            }
            
            // Handle PUT, GET, DELETE and leave
            guard method == "POST" else {
                completion(true)
                return
            }
            
            // Process POST requests
            
            // Fetch identifier from POST
            guard let data = data else {
                NSLog("Invalid server response data")
                completion(false)
                return
            }
            
            do {
                
                // POST request returns `["name": recordIdentifier]`. Store the
                // record identifier
                let nameDict = try JSONDecoder().decode([String: String].self, from: data)
                guard let name = nameDict["name"] else {
                    completion(false)
                    return
                }
                
                // Update record and store that name. POST is now successful
                // and includes the recordIdentifier as part of the item record.
                item.recordIdentifier = name
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
        switch item.recordIdentifier.isEmpty {
        case true: // POST, new record
            processRequest(method: "POST", for: item, with: completion)
        case false: // PUT, existing record
            processRequest(method: "PUT", for: item, with: completion)
        }
    }
    
    // Fetch all records and pass them to sender via completion handler
    // if youre just reading, you only need a URL...if you're pushing a method, you need a URLRequest
    static func fetchRecords(completion: @escaping ([Item]?) -> Void) {
        let requestURL = baseURL.appendingPathExtension("json")
        let dataTask = URLSession.shared.dataTask(with: requestURL) { data, _, error in
            
            guard error == nil, let data = data else {
                // Guaranteed to work
                if let error = error {
                    NSLog("Error fetching entries: \(error)")
                }
                completion(nil)
                return
            }
            
            do {
                let recordDict = try JSONDecoder().decode([String: Item].self, from:data)
                for (key, value) in recordDict { value.recordIdentifier = key } // pure paranoia
                let records = recordDict.map({ $0.value }) // This converts the [[id: item]] array of dictionary entries into an array of items
                completion(records)
            } catch {
                NSLog("Error decoding received data: \(error)")
                completion([])
            }
        }
        
        dataTask.resume()
    }
}
