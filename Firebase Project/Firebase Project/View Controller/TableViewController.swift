//
//  TableViewController.swift
//  Firebase Project
//
//  Created by Ivan Caldwell on 12/7/18.
//  Copyright © 2018 Ivan Caldwell. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController, ModelUpdateClient {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isEnabled = false
        let activity = UIActivityIndicatorView()
        activity.style = .gray
        activity.startAnimating()
        navigationItem.titleView = activity
        
        // Fetch records from Firebase and then reload the table view
        // Note: this may be significantly delayed.
        Firebase<Person>.fetchRecords { persons in
            if let persons = persons {
                Model.shared.persons = persons
                
                // Comment this out to show what it looks like while waiting
                DispatchQueue.main.async {
                    self.tableView.reloadData()
//                    self.navigationItem.rightBarButtonItem?.isEnabled = true
//                    self.navigationItem.titleView = nil
//                    self.title = "Person"
                }
            }
        }
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
            // handle the single entry cell return it
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as? EntryCell
                else { fatalError("Unable to dequeue entry cell") }
            let person = Model.shared.person(forIndex: indexPath.row)
            cell.nameField.text = person.name
            cell.cohortField.text = person.cohort
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
}
