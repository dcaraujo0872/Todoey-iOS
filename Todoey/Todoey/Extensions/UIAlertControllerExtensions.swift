import UIKit

extension UIAlertController {
    
    var textFromTextField: String? {
        return textFields?.first?.text
    }
    
    func addCancelAction() {
        addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
}
