import UIKit

class EntryCell: UITableViewCell {
    static let reuseIdentifier = "entry cell"
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var cohortField: UITextField!
    
    @IBAction func add(_ sender: Any) {
        guard let name = nameField.text, !name.isEmpty else { return } // name has to be filled out
        let cohort = cohortField.text ?? "" // cohort is optional
        let person = Person(name: name, cohort: cohort) // create a new person instance
        Model.shared.add(person: person)
        nameField.text = nil // reset the name field to be blank
        cohortField.text = nil // reset the cohort field to be blank
    }
}
