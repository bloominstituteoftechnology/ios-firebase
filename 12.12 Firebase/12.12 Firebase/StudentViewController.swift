import UIKit

class StudentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    
    @IBAction func addButton(_ sender: Any) {
        guard let text = nameLabel.text,  !text.isEmpty else { return }
        StudentModel.shared.
    }
    
}
