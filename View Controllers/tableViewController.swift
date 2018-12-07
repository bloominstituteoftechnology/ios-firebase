import UIKit

class tableViewController: UITableViewController, ModelUpdateClient {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Firebase<Person>.fetchRecords { persons in
            if let persons = persons {
                Model.shared.persons = persons
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Model.shared.delegate = self
    }
    
    func modelDidUpdate() {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.resuseIdentifier, for: indexPath) as? EntryCell else { fatalError("Unable to deque entry cell") }
            
            cell.nameTextField.text = ""
            cell.cohortTextField.text = ""
            
            return cell
        }
        
        // do anything related to person cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as? PersonCell else { fatalError("Unable to deque person cell") }
        
        let person = Model.shared.person(at: indexPath)
        cell.nameLabel.text = person.name
        cell.cohortLabel.text = person.cohort
        cell.uuidLabel.text = person.uuid
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        Model.shared.delete(at: indexPath) {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        guard let destination = segue.destination as? DetailViewController else { return }
        
        let person = Model.shared.person(at: indexPath)
        destination.person = person
        // Or //
        //destination.person = Model.shared.person(forIndex: indexPath.row)
    }
    
}
