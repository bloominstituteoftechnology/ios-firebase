import UIKit

class EntryCell: UITableViewCell {
    static let reuseIdentifier = "entry cell"
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var cohortField: UITextField!
    
    @IBAction func add(_ sender: Any) {
        guard let name = nameField.text, !name.isEmpty else { return }
        let cohort = cohortField.text ?? ""
        let person = Person(name: name, cohort: cohort)
        Model.shared.add(person: person)
        nameField.text = nil
        cohortField.text = nil
    }
}
