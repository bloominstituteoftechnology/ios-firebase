import UIKit

class PersonCell: UITableViewCell {
    static let reuseIdentifier = "person cell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cohortLabel: UILabel!
}
