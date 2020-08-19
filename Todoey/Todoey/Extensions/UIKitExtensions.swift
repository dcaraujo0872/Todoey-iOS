import UIKit

extension UIAlertController {
    
    var textFromTextField: String? {
        return textFields?.first?.text
    }
    
    func addCancelAction() {
        addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
}

extension UITableViewController {
    
    func insertRow(_ row: Int, inSection section: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: section)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func reloadTableViewOnMainQueue() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
