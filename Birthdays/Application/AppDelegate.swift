import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        loadView()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { _, _ in })
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        return true
    }    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}


extension AppDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var mainVC: MainVC {
        return window!.rootViewController as! MainVC
    }
    
    func loadView() {
        Bundle.setLanguage(UserDefaultsManager.shared.currentLanguage)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainModuleBuilder().create()
        window?.makeKeyAndVisible()
        print(#function + " finished")
    }
}

func print(_ items: Any...) {
    #if DEBUG
    Swift.print(items[0])
    #endif
}
