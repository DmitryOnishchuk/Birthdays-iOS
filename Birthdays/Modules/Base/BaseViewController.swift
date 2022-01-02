import UIKit
import Toast_Swift

class BaseViewController: UITableViewController {
	
	@Inject private var userDefaultsManager: UserDefaultsManager
    lazy var loader = Loader(in: self.view)

    
	// MARK: - Wait indicator
    func showLoadingIndicator() {
        self.loader.show(view: self.view)
    }
    
    func hideLoadingIndicator() {
        self.loader.hide()
    }
	
}

extension BaseViewController {
	
    func showErrorToast(_ message: String) {
        showToast(title: "Error", msg: message)
    }
    
    public func showToast(title: String? = nil, msg: String, position: ToastPosition = .bottom) {
        view.hideAllToasts()
        if position == .top {
            let top: CGFloat = self.view.bounds.size.height / 6
            let center = CGPoint(x: self.view.bounds.size.width / 2.0, y: top)
            view.makeToast(msg, duration: 1.5, point: center, title: title, image: nil, completion: nil)
        } else if position == .bottom {
            let bottom: CGFloat = (self.view.bounds.size.height / 4) * 3
            let center = CGPoint(x: self.view.bounds.size.width / 2.0, y: bottom)
            view.makeToast(msg, duration: 1.5, point: center, title: title, image: nil, completion: nil)
        }
    }
    
	func showMessage(_ message: String, title: String? = nil, handler: (() -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in handler?() }))
		present(alert, animated: true)
	}
	
	func showError(_ message: String, handler: (() -> Void)? = nil) {
		showMessage(message, title: "Помилка", handler: handler)
	}
	
}
