import UIKit
import RealmSwift

class TodosViewController: UITableViewController {
    
    @IBOutlet weak var todoSearchBar: UISearchBar!
    
    private let realm = try! Realm()
    private var todos: Results<Todo>?
    
    var category: TodoCategory! {
        didSet {
            title = category.name
            populateTableView(with: allTodos)
        }
    }
    
    private var allTodos: Results<Todo> {
        return category.todos.sortedByCreationDateDescending
    }
    
    private func populateTableView(with todos: Results<Todo>) {
        self.todos = todos
        reloadTableViewOnMainQueue()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = todos![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewConstants.ReuseIdentifiers.todoItem, for: indexPath)
        cell.textLabel?.text = todo.title
        cell.accessoryType = todo.completed ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo = todos![indexPath.row]
        do {
            try realm.write {
                todo.completed.toggle()
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } catch {
            print("Could not toggle todo '\(todo.title)'. Error: \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todos![indexPath.row]
            realm.destroy(todo)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addNewTodo(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create a todo", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Todo"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = alert.textFromTextField, text.hasValue {
                self.persistTodo(titled: text)
            }
        }
        alert.addAction(addAction)
        alert.addCancelAction()
        present(alert, animated: true)
    }
    
    private func persistTodo(titled title: String) {
        let todo = Todo(title: title)
        do {
            try realm.write {
                category.todos.append(todo)
            }
        } catch {
            print("Could not add todo '\(title)' to '\(category.name)'. Error: \(error)")
        }
        if let row = todos?.index(of: todo) {
            insertRow(row, inSection: 0)
        }
    }
}

extension TodosViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text, search.hasValue {
            populateTableView(with: category.todos.containing(search))
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? true {
            dismissSearchBar()
            populateTableView(with: allTodos)
        }
    }
    
    private func dismissSearchBar() {
        DispatchQueue.main.async {
            self.todoSearchBar.text = nil
            self.todoSearchBar.resignFirstResponder()
        }
    }
}
