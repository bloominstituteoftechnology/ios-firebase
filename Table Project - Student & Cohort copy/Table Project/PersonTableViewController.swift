import UIKit

// 
class PersonTableViewController: UITableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // switch statement
        switch section {
        case 0:
            return 1 // return 1 row in section 0 (the add person section)
        case 1:
            return Model.shared.numberOfPeople()
        default:
            fatalError("Invalid section number")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // get a cell
            let cell = tableView.dequeueReusableCell(withIdentifier: AddPersonCell.reuseIdentifier, for: indexPath)
            return cell
        }
        
        // Handle PersonCell from here forward
        // conditional casting because we need to specialize the cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as? PersonCell
            else { fatalError("Unable to dequeue person cell") }
        
        // put information into the person cell - populating the person cell
        // grab a person
        let person = Model.shared.person(at: indexPath.row)
        cell.nameLabel.text = person.name
        cell.cohortLabel.text = person.cohort
        
        return cell
    }
    
    @IBAction func add() {
        // how many addPersonCells will we have at one time? Always guaranteed that there will be one. So we can grab that single add person cell and cast it to the right type
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddPersonCell
            else { return }
        
        // grab text from the nameField, check to make sure it is not empty, and if it's not empty, then continue (ensure that the name is not empty)
        guard let name = cell.nameField.text, !name.isEmpty
            else { return }
        
        // If nil, set it to the empty string (ensure that we ahve a string and not nil
        let cohort = cell.cohortField.text ?? ""
        
        // construct a person
        let person = Person(name: name, cohort: cohort)
        
        // Clear the textField after entered and saved
        cell.nameField.text = ""
        cell.cohortField.text = ""
        
        // add to the model
        Model.shared.add(person: person)
        // update our table view
        tableView.reloadData()
        
    }
    
    // reload when we return from the detail view (ensure that the table view reloads whenever we return from the detail view controller)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // Cell height information - set custom heights for each section
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        default:
            return 160
        }
    }
    
    // Prepare for segue allows us to pass forward information that the segue's destination can use to set up its views
    // Rule of thumb: NEVER EDIT ANOTHER VIEW CONTROLLER'S FIELDS DIRECTLY, because it might not have enough time to load between screens and you will crash
    // Sending information is safe, editing views is unsafe
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // fetch index path
        // fetch view controller
        guard
            let destination = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow
            else { return }
        
        let person = Model.shared.person(at: indexPath.row)
        destination.person = person
    }
    
}
