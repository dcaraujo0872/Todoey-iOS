import Foundation
import RealmSwift

class TodoCategory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated = Date()
    let todos = List<Todo>()
}

extension TodoCategory {
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

extension Realm {
    
    func destroy<T: Object>(_ obj: T) {
        do {
            try write {
                self.delete(obj)
            }
        } catch {
            print("Could not delete object of type \(String(describing: obj.self))")
        }
    }
}

extension Results where Element == TodoCategory {
    
    var sortedByNameAscending: Results<TodoCategory> {
        return sorted(byKeyPath: "name", ascending: true)
    }
}
