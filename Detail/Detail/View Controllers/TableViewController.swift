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
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Model.shared.delegate = self
        
        // Added from the Devices project
        // Seems unnecessary for the most part, since it probably won't work out of the box.
        
        // Need to change this to the add button that is already there - Part 1/2
        // navigationItem.rightBarButtonItem?.isEnabled.toggle()
        let activity = UIActivityIndicatorView()
        activity.style = .gray
        activity.startAnimating()
        navigationItem.titleView = activity
        
        
        Firebase<Person>.fetchRecords { persons in
            if let persons = persons {
                Model.shared.setPerson(persons)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    // need to update this accordingly - Part 2/2
                    // self.navigationItem.rightBarButtonItem?.isEnabled.toggle()
                    self.navigationItem.titleView = nil
                    self.title = "People"
                }
            }
        }
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

    // Add deleting students functionality to table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        Model.shared.deletePerson(at: indexPath) {
            self.tableView.reloadData()
        }
    }
}
