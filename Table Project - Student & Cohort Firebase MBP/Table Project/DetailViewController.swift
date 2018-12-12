import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var cohortField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    // This property allows the detail view controller to have a reference
    // 
    var person: Person?
    
    @IBAction func save(_ sender: Any) {
        // update our person in our model - but first add a property above (var person) because we don't have anything to work with
        
        // unwrap in order to check to see there is a person
        guard let person = person else { return }
        
        // if user has deleted the information in the field, we don't want to save it - so we will make two tests
        // check to see if there is text there
        // check to see whether or not the text is empty
        guard let name = nameField.text, !name.isEmpty else { return }
        
        // Perform our edits
        person.name = name
        person.cohort = cohortField.text ?? "" // nil coalescing, if the result is nil, give it a fallback value (an empty string)
        
        // Leave
        navigationController?.popViewController(animated: true) // Optional/Conditional Chaining: if there is a value in the navigation controller, perform what comes after the question mark. otherwise don't do anything.
       
    }
    
    // Called just before view controller appears on-screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ensure we have a person to present
        guard let person = person else { return }
        
        // Populate the two text fields
        nameField.text = person.name
        cohortField.text = person.cohort
    }
}

