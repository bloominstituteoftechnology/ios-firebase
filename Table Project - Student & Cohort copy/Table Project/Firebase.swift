
import Foundation

// https://names-and-cohorts.firebaseio.com/

/*
 
 READ   <- start the application
 
 POST   <- create, creating a new record, Firebase will return a new record identifier
 PUT    <- update a specific record
 DELETE <- delete a specific record
 
 */

class Firebase<Item: Codable & FirebaseItem> {
    
    // Base URL
    static var baseURL: URL! { return URL(string:"https://names-and-cohorts.firebaseio.com/") }
    
    // Function that constructs a URL specific to my method, passes the method as a string.
    static func requestURL(_ method: String, for recordIdentifier: String = "unknownid") -> URL {
        switch method {
        case "POST":
            // Post to the main database. It will return a new record identifier
            return baseURL.appendingPathExtension("json")
        case "DELETE", "PUT", "GET":
            // You need the record identifier in your URL, except if accessing all the records at once
            return baseURL
                // return the baseURL + the recordIdentifier + .json
                .appendingPathComponent(recordIdentifier)
                .appendingPathExtension("json")
        default:
            fatalError("Unknown request method: \(method)")
        }
    }
    
    // Handle a single request: meant for DELETE, PUT, POST.
    static func processRequest(
        method: String, // Get PUT POST or DELETE
        for item: Item, // Conforms to Codable & FirebaseItem (so that we have a record id field)
        with completion: @escaping (_ success: Bool) -> Void = { _ in }
        ) {
        
        // Fetch appropriate request URL customized in method by creating a URL request
        var request = URLRequest(url: requestURL(method, for: item.recordIdentifier))
        //set the http method
        request.httpMethod = method
        
        // Encode this record
        do {
            // fill out the request body - needed when pushing info to a service
            request.httpBody = try JSONEncoder().encode(item)
        } catch {
            NSLog("Unable to encode \(item): \(error)")
            completion(false)
            return
        }
        
        
        // Create a data task to perform request, then add a completion handler
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            // Fail on error
            if let error = error {
                NSLog("Server \(method) error: \(error)")
                completion(false) // run a completion
                return
            }
            
            // If we have reached this point, we haven't failed and there is data
            
            // Handle PUT, GET, DELETE, then leave the function
            guard method == "POST" else {
                completion(true) // Successful with our completion and leave
                return
            }
            
            // If it is POST, then we continue
            
            // Process POST requests by posting it, getting the record id, adding record id to device, save it again
            
            // Fetch identifier from POST
            // Look at data and make sure it is a dictionary with a name and record identifier
            guard let data = data else {
                NSLog("Invalid server response data")
                completion(false)
                return
            }
            
            // If we do have the data, decode
            do {
                
                // POST request returns `["name": recordIdentifier]` - Store the record identifier, not the name
                let nameDict = try JSONDecoder().decode([String: String].self, from: data)
                // make sure there is an entry for the record ID
                guard let name = nameDict["name"] else {
                    completion(false) // if not, fail and leave
                    return
                }
                
                // Update record and store that name. POST is now successful and includes the recordIdentifier as part of the item record.
                item.recordIdentifier = name // set it to the recordIdentifier
                processRequest(method: "PUT", for: item)// PUT it back to the server
                completion(true) // complete
                
            } catch {
                
                // if error during decoding, log the error, and completion false
                NSLog("Error decoding JSON response: \(error)")
                completion(false)
                return
            }
            
        }
        
        dataTask.resume() // data task doesn't do anything until we resume
        
    }
    
    // Three useful entry points that we will call
    // Delete, Save, Fetch
    
    static func delete(item: Item, completion: @escaping (_ success: Bool) -> Void = { _ in}) {
        // call the method DELETE for that item
        processRequest(method: "DELETE", for: item, with: completion)
    }
    
    static func save(item: Item, completion: @escaping (_ success: Bool) -> Void = { _ in}) {
        // if nothing in the recordIdentifier, POST it
        switch item.recordIdentifier.isEmpty {
        case true: // POST, new record, "create"
            processRequest(method: "POST", for: item, with: completion)
        // if there is, replace it instead of store it
        case false: // PUT, existing record, "update"
            processRequest(method: "PUT", for: item, with: completion)
        }
    }
    
    // Fetch all records and pass them to sender via completion handler
    static func fetchRecords(completion: @escaping ([Item]?) -> Void) {
        // append the path extension json
        let requestURL = baseURL.appendingPathExtension("json")
        // create a data task, don't need a request because it's a reading method
        let dataTask = URLSession.shared.dataTask(with: requestURL) { data, _, error in
            
            // make sure I don't have an error and there is data for me to use
            guard error == nil, let data = data else {
                if let error = error {
                    NSLog("Error fetching entries: \(error)")
                }
                completion(nil)
                return
            }
            
            // if it does work...
            do {
                
                // decode string: item - record ID followed by the item
                let recordDict = try JSONDecoder().decode([String: Item].self, from: data)
                // extra safety
                for (key, value) in recordDict { value.recordIdentifier = key }
                // Map - We don't care about the record ID, so take the value out of the pair and that becomes the list of records
                // This converts the [[id: item]] array of dictionary entries into an array of items
                let records = recordDict.map({ $0.value })
                // call completion with my list of records
                completion(records)
            } catch {
                NSLog("Error decoding received data: \(error)")
                // Start it off with an empty list
                completion([])
            }
        }
        
        dataTask.resume()
    }
    
}
