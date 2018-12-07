import UIKit
import Foundation

class DetailViewController: UIViewController {
    var person: Person?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cohortField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         Model.shared.delegate?.modelDidUpdate()
        
        guard let person = person else { return }
        nameField.text = person.name
        cohortField.text = person.cohort
    }
    
    @IBAction func save(_ sender: Any) {
        guard let person = person else { return }
        guard let name = nameField.text, !name.isEmpty else { return }
        person.name = name
        person.cohort = cohortField.text ?? ""
        
        navigationController?.popViewController(animated: true)
        Model.shared.delegate?.modelDidUpdate()
        Firebase.save(item: person)
    }
}
