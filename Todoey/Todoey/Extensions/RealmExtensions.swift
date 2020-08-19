import RealmSwift

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
