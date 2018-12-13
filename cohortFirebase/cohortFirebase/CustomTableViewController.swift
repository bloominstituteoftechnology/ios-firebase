import UIKit

class CustomTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch section {
        case 0:
            return 1
        case 1:
            return Model.shared.count()
        default:
            fatalError("Illegal section")
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as? EntryCell
                else { fatalError("Unable to dequeue entry cell") }
            
            cell.nameField.text = ""
            cell.cohortField.text = ""
    
        return cell
    }
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as? PersonCell else { fatalError("Unable to dequeue person cell") }
            let person = Model.shared.person(forIndex: indexPath.row)
            cell.nameLabel.text = person.name
            cell.cohortLabel.text = person.cohort
        
        return cell
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

}
    

