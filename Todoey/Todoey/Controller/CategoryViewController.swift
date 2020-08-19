import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    private let realm = try! Realm()
    private var categories: Results<TodoCategory>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = realm.objects(TodoCategory.self).sortedByNameAscending
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewConstants.ReuseIdentifiers.categoryItem, for: indexPath)
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = categories[indexPath.row]
            realm.destroy(category)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewConstants.Segue.todoSegue {
            if let controller = segue.destination as? TodosViewController, let selectedRow = tableView.indexPathForSelectedRow?.row {
                controller.category = categories[selectedRow]
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create category", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = alert.textFromTextField, text.hasValue {
                self.persistCategory(named: text)
            }
        }
        alert.addAction(addAction)
        alert.addCancelAction()
        present(alert, animated: true)
    }
    
    private func persistCategory(named name: String) {
        let category = TodoCategory(name: name)
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Could not persist category '\(name)' to database. Error: \(error)")
        }
        if let row = categories.index(of: category) {
            insertRow(row, inSection: 0)
        }
    }
}
