import UIKit

class EntryCell: UITableViewCell {
    static let resuseIdentifier = "entry cell"
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cohortTextField: UITextField!
    
    @IBAction func add(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        let cohort = cohortTextField.text ?? ""
        let person = Person(name: name, cohort: cohort)
        Model.shared.add(person: person) {}
        
        nameTextField.text = ""
        cohortTextField.text = ""
    }
}
