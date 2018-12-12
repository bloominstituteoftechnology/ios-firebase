
import Foundation

/*
 READ   <- Start the application
 
 POST   <- create, creating a new record, Firebase returns a new record identifier
 PUT    <- update a specific record
 DELETE <- delete a specific record
 */

class Firebase<Item: Codable & FirebaseItem> {
    
    static var baseURL: URL! { return URL(string: "https://names-and-cohorts-mbp.firebaseio.com/") }
    
    // Construct a URL for a method (RESTful methods are: PUT POST GET and DELETE) and pass the method as a string
    // When we post, we take the baseURL and put JSON at the end - that is what we POST with
    // Returns a URL that is specific to your method
    // We are creating a new record, so we don't yet have a recordIdentifier.
    static func requestURL( _ method: String, for recordIdentifier: String = "unknownid" ) -> URL {
        
        switch method {
        case "POST":
            // Post to the main DB - it will return a new record identifier
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
    
    // Handle a single request: meant for DELETE, PUT, POST
    static func processRequest (
        method: String, // GET PUT POST or DELETE
        for item: Item, // Conforms to Codable and FirebaseItem (so that we have a record id field)
        with completion: @escaping (_ success: Bool) -> Void = { _ in } // Give the closure a default that doesn't do anything
        ) {
        
        // Create a URL request
        // Fetch appropriate request URL customized to method
        var request = URLRequest(url: requestURL(method, for: item.recordIdentifier))
        // set the http method
        request.httpMethod = method
        
        // Encode the record/data
        do {
            // fill out the request body - needed when pushing information to a service
            request.httpBody = try JSONEncoder().encode(item)
        } catch {
            NSLog("Unable to encode \(item): \(error)")
            completion(false)
            return
        }
        
        // Create data task to perform request
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            // Fail on error
            if let error = error {
                NSLog("Server \(method) error: \(error)")
                completion(false)
                return
            }
            
            // Handle PUT, GET, DELETE
            guard method == "POST" else {
                completion(true)
                return
            }
            
            // If it is POST, then continue
            
            // Process POST requests
            
            // post it, get the record id, add record id to our device, save it again and THEN firebase will have the record id with the person stored
            
            // Fetch identifier from POST
            // Look in the data and make sure we have it. We are expecting to get back a dictionary with a name and a record identifier. If we don't have that, throw an error
            guard let data = data else {
                NSLog("Invalid server response data")
                completion(false)
                return
            }
            
            // Decode data
            // If we do have it, decode the {string: string} dictionary
            do {
                // POST request returns ["name": recordIdentifier]
                // Store the record identifier
                let nameDict = try JSONDecoder().decode([String: String].self, from: data)
                // Make sure there is an entry for the record ID and record Name
                guard let recordIdentifier = nameDict["name"] else {
                    completion(false)
                    return
                }
                // Update the record and store the name/recordIdentifier
                // POST now includes the recordIdentifier as part of the item record
                item.recordIdentifier = recordIdentifier // set it to the recordIdentifier
                processRequest(method: "PUT", for: item) // PUT it back to the server
                completion(true)
            } catch {
                NSLog("Error decoding JSON response: \(error)")
                completion(false)
                return
            }
            
        }
        
        dataTask.resume()
        
    }
    
    // Three useful entry points that we will call
    // Delete, Save, and Fetch
    
    static func delete(item: Item, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        // call the method DELETE for that item
        processRequest(method: "DELETE", for: item, with: completion)
    }
    
    static func save(item: Item, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        // if nothing in the recordIdentifier, post it
        switch item.recordIdentifier.isEmpty {
        case true: // POST, new record, "create"
            processRequest(method: "POST", for: item, with: completion)
        // if there is, replace it instead of storing a new one
        case false: // PUT, existing record, "update"
            processRequest(method: "PUT", for: item, with: completion)
        }
    }
    
    // Fetch all records and pass them to the sender via a completion handler
    static func fetchRecords(completion: @escaping ([Item]?) -> Void) {
        // append the path extension json
        let requestURL = baseURL.appendingPathExtension("json")
        // create a data task, but don't need a request, just a URL - you can do this if all you are doing is reading. If passing a method and a body, then you need to create a URLRequest instance, like in the method above
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            // make sure there is no error AND there is data to use
            guard error == nil, let data = data else {
                if let error = error {
                    NSLog("Error fetching entries: \(error)")
                }
                completion(nil)
                return
            }
            
            // if it does work...
            // Decode
            do {
                // decode string: item
                // record id: item
                let recordDict = try JSONDecoder().decode([String: Item].self, from: data)
                // Extra safety
                for (key, value) in recordDict { value.recordIdentifier = key }
                // Map - everything in a dict is a key-value pair. We don't care about the recordId, so take the value out of the pair sent to us and that becomes my list of records
                let records = recordDict.map({ $0.value }) // this converts the [[id: item]] array of dictionary entries into an array of just the items
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
