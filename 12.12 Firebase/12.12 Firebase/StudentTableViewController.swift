import UIKit

class StudentTableViewController: UITableViewController {
    
      let reuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    
  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        

        return cell
    }
}
