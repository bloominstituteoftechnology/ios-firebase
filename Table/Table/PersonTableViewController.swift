import UIKit

class TableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isEnabled = false
        let activity = UIActivityIndicatorView() // use for indeterminate waits
        activity.style = .gray
        activity.startAnimating()
        navigationItem.titleView = activity
        
        // Fetch records from Firebase and then reload the table view
        // Note: this may be significantly delayed.
        Firebase<Student>.fetchRecords { students in
            if let students = students {
                Model.shared.students = student
                
                // Comment this out to show what it looks like while waiting
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.navigationItem.titleView = nil
                    self.title = "Students"
                }
            }
        }
    }
    
    // No need to use static as we're only going to use this within this implementation
    // rather than with a custom cell subclass
    let reuseIdentifier = "cell"
    
    
    
    
    // FIXME: Add data source methods (number of rows and cell for row)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.numberOfItems()
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let student = Model.shared.student(at: indexPath)
        
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.cohort
        
        return cell
    }
    
    
    
    
    // FIXME: Update the device with a new UUID, update Firebase, and reload data
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Model.shared.updateStudent(at: indexPath) {
            self.tableView.reloadData()
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        // FIXME: Delete an item, update Firebase, update model, and reload data
        Model.shared.deleteStudent(at: indexPath) {
            self.tableView.reloadData()
        }
    }
    
    
    
    
    @IBAction func add(sender: Any) {
        // FIXME: Add a new device, store it at Firebase, update model, and reload data
        Model.shared.addNewStudent(student: student) {
            self.tableView.reloadData()
        
        
            self.tableView.reloadData()
        }
    }
}




//
//class PersonTableViewController: UITableViewController {
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return Model.shared.numberOfPeople()
//        default:
//            fatalError("Invalid section number")
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: AddPersonCell.reuseIdentifier, for: indexPath)
//            return cell
//        }
//
//        // Handle PersonCell from here forward
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as? PersonCell
//            else { fatalError("Unable to dequeue person cell") }
//
//        // Do stuff here
//        let person = Model.shared.person(at: indexPath.row)
//        cell.nameLabel.text = person.name
//        cell.cohortLabel.text = person.cohort
//
//        return cell
//    }
//
//    @IBAction func add() {
//        // Grab single add person cell and cast it to the right type
//        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddPersonCell
//            else { return }
//
//        // Ensure that the name is not empty
//        guard let name = cell.nameField.text, !name.isEmpty
//            else { return }
//
//        // Use nil-coalescing to ensure that we have a string and not nil
//        let cohort = cell.cohortField.text ?? ""
//
//        // Construct person that we'll add to our model
//        let person = Person(name: name, cohort: cohort)
//
//        // CLEAN UP AFTER OURSELVES
//        cell.nameField.text = nil
//        cell.cohortField.text = nil
//
//        // Add the person to the model and then reload the table view
//        Model.shared.add(person: person)
//        tableView.reloadData()
//    }
//
//    // Ensure that the table view reloads whenever we return from
//    // the detail view controller
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableView.reloadData()
//    }
//
//    // Set custom heights for each section
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0:
//            return 150
//        default:
//            return 160
//        }
//    }
//
//    // Prepare for segue allows us to pass forward information that
//    // the segue's destination can use to set up its views
//    //
//    // Rule of thumb: NEVER EDIT ANOTHER VIEW CONTROLLER'S FIELDS/VIEWS DIRECTLY
//    // Sending information is safe
//    // Editing views is unsafe.
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard
//            let destination = segue.destination as? DetailViewController,
//            let indexPath = tableView.indexPathForSelectedRow
//            else { return }
//
//        let person = Model.shared.person(at: indexPath.row)
//        destination.person = person
//
//        // Hopefully this will crash: DO NOT DO THIS!
//        // destination.nameField.text = person.name
//    }
//}
