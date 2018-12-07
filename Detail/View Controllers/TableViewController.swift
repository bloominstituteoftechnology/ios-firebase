import UIKit

class TableViewController: UITableViewController, ModelUpdateClient {
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
            // handle the single entry cell
            // return it
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as? EntryCell
                else { fatalError("Unable to dequeue entry cell") }
            
            cell.nameField.text = "" // Coder paranoia
            cell.cohortField.text = ""
            
            return cell
        }
        
        // do anything related to person cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as? PersonCell
            else { fatalError("Unable to dequeue person cell") }
        
        let person = Model.shared.person(forIndex: indexPath.row)
        cell.nameLabel.text = person.name
        cell.cohortLabel.text = person.cohort
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isEnabled = false
        let activity = UIActivityIndicatorView()// for indeterminate waits
        activity.style = .gray
        activity.startAnimating()
        navigationItem.titleView = activity
        
        // Fetch records from Firebase and then reload the table view
        // Note: this may be significantly delayed.
        Firebase<Person>.fetchRecords { persons in
            if let persons = persons {
                Model.shared.persons = persons  // breaks encapsulation, hacked it instead due to time constriants
                
                // Comment this out to show what it looks like while waiting
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.navigationItem.titleView = nil // important to be able to see custom title
                    self.title = "Devices"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow
            else { return }
        guard let destination = segue.destination as? DetailViewController
            else { return }
        
        destination.person = Model.shared.person(forIndex: indexPath.row)
    }
    
    
    // FIXME: Update the person, update Firebase, and reload data
    override func tableView(_ tableViewPassedToUs: UITableView, didSelectRowAt indexPath: IndexPath) {
        Model.shared.updatePerson(at: indexPath) {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        // FIXME: Delete an item, update Firebase, update model, and reload data
        Model.shared.deletePerson(at: indexPath) {
            self.tableView.reloadData()
        }
    }
    
}
