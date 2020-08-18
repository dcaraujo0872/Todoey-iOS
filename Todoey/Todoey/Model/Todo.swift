import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var completed: Bool = false
    @objc dynamic var dateCreated = Date()
    var category = LinkingObjects(fromType: TodoCategory.self, property: "todos")
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}

extension Results where Element == Todo {
    
    var sortedByCreationDateDescending: Results<Todo> {
        return sorted(byKeyPath: "dateCreated", ascending: false)
    }
}
