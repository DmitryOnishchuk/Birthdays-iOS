import UIKit

class NotificationTableViewController: UITableViewController {
    
    
    var notificationPickerView: NotificationPickerView!
    var dummyTextField: UITextField?
    

    @IBOutlet weak var notifyEventLabel0: UILabel!
    @IBOutlet weak var notifyEventLabel1: UILabel!
    @IBOutlet weak var notifyEventLabel2: UILabel!
    var currentNotifyEvent: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotificationCheckmark()
    }
    
    func setNotificationCheckmark(){
        let ud0 = SettingsFunctions.getNotificationTimeEventByUserDefaults(id: 0)
        notifyEventLabel0.text = ud0.text
        let ud1 = SettingsFunctions.getNotificationTimeEventByUserDefaults(id: 1)
        notifyEventLabel1.text = ud1.text
        let ud2 = SettingsFunctions.getNotificationTimeEventByUserDefaults(id: 2)
        notifyEventLabel2.text = ud2.text
    }
    
    
    func changeNotificationEvent(){
        
        dummyTextField = UITextField()
        notificationPickerView = NotificationPickerView()
        notificationPickerView.delegate = notificationPickerView
        notificationPickerView.dataSource = notificationPickerView
        
        view.addSubview(dummyTextField!)
        dummyTextField?.inputView = notificationPickerView
        
        notificationPickerView.timeEvent = SettingsFunctions.getNotificationTimeEventByUserDefaults(id: currentNotifyEvent)
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "DONE".localized, style: .plain, target: self, action: #selector(doneDatePicker))
        let cancelButton = UIBarButtonItem(title: "cancel".localized, style: .plain, target: self, action:
                                            #selector(cancelDatePicker))
        let centerLabel = ToolBarTitleItem(text: "Уведомление " + String(currentNotifyEvent+1), font: .systemFont(ofSize: 16), color: .darkText)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton, spaceButton,centerLabel,spaceButton,doneButton], animated: true)
        
        dummyTextField!.inputAccessoryView = toolbar
        dummyTextField!.becomeFirstResponder()
    }
    
    @objc func doneDatePicker(){
        self.view.endEditing(true)
        
        switch currentNotifyEvent {
        case 0:
            notifyEventLabel0.text = notificationPickerView.timeEvent.text
            print(notificationPickerView.timeEvent.text)
            SettingsFunctions.setNotificationTimeEventByUserDefaults(id: 0, timeEvent: notificationPickerView.timeEvent)
            break
        case 1:
            notifyEventLabel1.text = notificationPickerView.timeEvent.text
            SettingsFunctions.setNotificationTimeEventByUserDefaults(id: 1, timeEvent: notificationPickerView.timeEvent)
            break
        case 2:
            notifyEventLabel2.text = notificationPickerView.timeEvent.text
            SettingsFunctions.setNotificationTimeEventByUserDefaults(id: 2, timeEvent: notificationPickerView.timeEvent)
            break
        default:
            break
        }
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            currentNotifyEvent = 0
            changeNotificationEvent()
            break
        case 1:
            currentNotifyEvent = 1
            changeNotificationEvent()
            break
        case 2:
            currentNotifyEvent = 2
            changeNotificationEvent()
            break
        default: break
        }
    }
    
}
