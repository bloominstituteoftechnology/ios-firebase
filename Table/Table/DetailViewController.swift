import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cohortField: UITextField!

    // This property allows the detail view controller to have a reference
    // to work on for display and editing
    var person: Person?
    
    @IBAction func save(_ sender: Any) {
        // Update our person in our model
        guard let person = person else { return }
        
        // Make sure there is a name and that it is not empty
        guard let name = nameField.text, !name.isEmpty else { return }
        
        // Perform our edits
        person.name = name
        person.cohort = cohortField.text ?? ""
        
        // Leave
        navigationController?.popViewController(animated: true)
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
