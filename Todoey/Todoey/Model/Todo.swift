import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var completed: Bool = false
    @objc dynamic var dateCreated = Date()
    var category = LinkingObjects(fromType: TodoCategory.self, property: "todos")
}

extension Todo {
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}

extension List where Element == Todo {
    
    var sortedByCreationDateDescending: Results<Todo> {
        return sorted(byKeyPath: "dateCreated", ascending: false)
    }
    
    func containing(_ text: String) -> Results<Todo> {
        return filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "dateCreated", ascending: false)
    }
}
