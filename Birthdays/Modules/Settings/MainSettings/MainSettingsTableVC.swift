import UIKit

class MainSettingsTableVC: UITableViewController {
    
    @IBOutlet var settingsTabelView: UITableView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    
    @IBOutlet weak var currentLanuageLabel: UILabel!
    @IBOutlet weak var currentThemeLabel: UILabel!
    @IBOutlet weak var currentAgeLabel: UILabel!
    @IBOutlet weak var currentNotificationTimeLabel: UILabel!
        
    private var datePickerNotificationTime: UIDatePicker?
    private var dummyTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(self.settingsTabelView.sectionHeaderHeight)
        self.settingsTabelView.contentInset = UIEdgeInsets(top: -18, left: 0, bottom: 0, right: 0);

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onLoad()
    }
    
    func onLoad(){
        self.title = "settings".localized
        languageLabel.text = "settings_language".localized
        themeLabel.text = "settings_theme".localized
        ageLabel.text = "settings_contact_age".localized
        notificationTimeLabel.text = "settings_notification_time_remind".localized
        
        setCurrentLanuageLabel()
        setCurrentThemeLabel()
        setCurrentAgeLabel()
        setCurrentNotificationTimeLabel()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [1, 0]:
            changeNotificationTime()
        default: break
        }
    }
    
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        switch(section) {
        case 0: return "settings_title_main".localized
        case 1: return "settings_notification_title".localized
            
        default :return ""
            
        }
    }
    
    func setCurrentThemeLabel(){
        let ud = SettingsFunctions.getThemeByUserDefaults()
        switch ud {
        case 0:
            currentThemeLabel.text = "settings_theme_system_default".localized
            break
        case 1:
            currentThemeLabel.text = "settings_theme_light".localized
            break
        case 2:
            currentThemeLabel.text = "settings_theme_dark".localized
            break
        default:
            currentThemeLabel.text = "settings_theme_system_default".localized
            break
        }
    }
    
    func setCurrentLanuageLabel(){
        let langStr = SettingsFunctions.getCurrentLanguage()
        switch langStr {
        case "en":
            currentLanuageLabel.text = "english".localized
        case "de":
            currentLanuageLabel.text = "germany".localized
        case "ru":
            currentLanuageLabel.text = "russian".localized
        case "pl":
            currentLanuageLabel.text = "polish".localized
        case "uk":
            currentLanuageLabel.text = "ukrainian".localized
        default:
            currentLanuageLabel.text = "english".localized
        }
    }
    
    func setCurrentAgeLabel(){
        let ageSetting = SettingsFunctions.getAgeByUserDefaults()
        switch ageSetting {
        case AgeSettingsEnum.upcoming:
            currentAgeLabel.text = "settings_contact_age_upcoming".localized
        case AgeSettingsEnum.current:
            currentAgeLabel.text = "settings_contact_age_current".localized
        default:
            currentAgeLabel.text = "settings_contact_age_upcoming".localized
        }
    }
    
    func setCurrentNotificationTimeLabel(){
        let notificationTimeString = SettingsFunctions.getNotificationTimeByUserDefaults()
        currentNotificationTimeLabel.text = notificationTimeString
    }
    
    func changeNotificationTime(){
        dummyTextField = UITextField()
        datePickerNotificationTime = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePickerNotificationTime?.preferredDatePickerStyle = .wheels
        }


        view.addSubview(dummyTextField!)
        dummyTextField?.inputView = datePickerNotificationTime
        datePickerNotificationTime?.datePickerMode = .time
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        let date = dateFormatter.date(from: SettingsFunctions.getNotificationTimeByUserDefaults())
        datePickerNotificationTime!.date = date!
        
        
        let localeID = Locale.preferredLanguages.first
        datePickerNotificationTime?.locale = Locale(identifier: localeID!)
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel".localized, style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        dummyTextField!.inputAccessoryView = toolbar
        dummyTextField!.becomeFirstResponder()
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let time = formatter.string(from: datePickerNotificationTime!.date)
        SettingsFunctions.setNotificationTimeByUserDefaults(time)
        setCurrentNotificationTimeLabel()
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
