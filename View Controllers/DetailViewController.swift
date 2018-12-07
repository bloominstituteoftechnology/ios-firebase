import UIKit

class DetailViewController: UIViewController {
    
    var person: Person?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cohortTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let person = person else { return }
        nameTextField.text = person.name
        cohortTextField.text = person.cohort
    }
    
    @IBAction func save(_ sender: Any) {
        guard let person = person,
        let name = nameTextField.text,
            !name.isEmpty else { return }
        
        person.name = name
        person.cohort = cohortTextField.text ?? ""
        
        Model.shared.update(person: person) {}
        
        navigationController?.popViewController(animated: true)
    }
}
