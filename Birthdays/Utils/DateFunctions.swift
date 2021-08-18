import Foundation


class DateFunctions {
    
    static func dateToString(date:Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    static func dateToHumanString(_ date: Date)->String {
        let calendar = Calendar(identifier: .gregorian)
        let time = calendar.dateComponents([.year,.month,.day], from: date)
        let monthName = getMonthName(time.month!)
        
        var yearString = " " + String(time.year!)
        if time.year == 1 {
            yearString = ""
        }
        
        
        let res = "\(time.day!) \(monthName)\(yearString)"
        return res
    }
    
    static func getBirthdayNear(date: Date) -> Date{
     
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let gregorianCalendar = Calendar(identifier: .gregorian)
        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        component.year = currentYear
        var birthdayNear = Calendar.current.date(from: component)!

        let GMT = TimeZone.current.secondsFromGMT() / 3600
        let currentDate = Calendar.current.date(bySettingHour: GMT, minute: 0, second: 0, of: Date())

        
       // print(date)
       // print(birthdayNear)
        if currentDate! > birthdayNear {
            var dateComponent = DateComponents()
            dateComponent.year = 1
            birthdayNear = Calendar.current.date(byAdding: dateComponent, to: birthdayNear)!
        }
        return birthdayNear
    }
    
    
    static func getAge(birthdayDate: Date, birthdayNear: Date) -> Int{
        var age = -1
        let year = Calendar.current.component(.year, from: birthdayDate)
        if year != 1 {
            age = getDifferenceYears(firstDate: birthdayDate, secondDate: birthdayNear)
        }
        return age
    }
    
    static func getDifferenceYears(firstDate: Date, secondDate: Date) -> Int{
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        let res = calendar.dateComponents([.year], from: date1, to: date2).year!
        
        return res
    }
    
    static func getDifferenceDays(firstDate: Date, secondDate: Date) -> Int{
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        let res = calendar.dateComponents([.day], from: date1, to: date2).day!
        return res
    }
    
    static func getDayAdditional(num: Int) -> String{
        let daysArr: [String] = [NSLocalizedString("COMMON_DAY", comment: ""),
                                 NSLocalizedString("COMMON_DAY2", comment: ""),
                                 NSLocalizedString("COMMON_DAYS", comment: "")]
        
        var langStr = Locale.current.languageCode
        if langStr == nil{
            langStr = "en"
        }
        if langStr == "ru" || langStr == "uk" || langStr == "uz"{
            let result = num % 100;
            if (result >= 5 && result <= 20) {
                return daysArr[2];
            }
            
            let last = result % 10;
            if (last == 1) {
                return daysArr[0];
            }
            if (last < 2 || last > 4) {
                return daysArr[2];
            }
            return daysArr[1];
        } else if (num < 2) {
            return daysArr[0];
        } else {
            return daysArr[2];
        }
        
    }
    
    static func formatDaysToBirthday(days:Int, shortName:Bool) -> String{
        
        var dayString = "COMMON_DAYS".localized
        dayString = getDayAdditional(num: days)
        
        var after = "";
        if (!shortName) {
            after = "COMMON_AFTER_UPPER".localized + " ";
        }
        var res = after + String(days) + " " + dayString;
        if (days == 0) {
            res = "COMMON_TODAY".localized
        } else if (days == 1) {
            res = "COMMON_TOMORROW".localized
        }
        
        return res
    }
    
    static func formatDaysToBirthdayNotification(timeEvent:TimeEvent) -> String{
                
        let days = timeEvent.day
        
        var dayString = "COMMON_DAYS".localized
        dayString = getDayAdditional(num: days)
        
        var after = "COMMON_AFTER_UPPER".localized + " ";
        
        var res = after + String(days) + " " + dayString;
        if (days == 0) {
            res = "COMMON_TODAY".localized
        } else if (days == 1) {
            res = "COMMON_TOMORROW".localized
        }

        return res.lowercased()
    }
    
    
    static func getAgeString(age: Int)-> String{
        var res = ""
        if age > 0 {
            res = String(age)
        }
        return res
    }
    
    static func getMonthName(_ month: Int)-> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: UserDefaultsManager.shared.currentLanguage)
        return formatter.monthSymbols[month - 1]
    }
    
    static func formatAge(_ age: Int)-> String{
        return (age > 0) ? String(age) + " " + getPostfixYears(age) : ""
    }
    
    static func getPostfixYears(_ age: Int)-> String{
        
        
        
        let currentLanguage = UserDefaultsManager.shared.currentLanguage
        var res = "";
        if currentLanguage == "ru" ||
            currentLanguage == "uk" ||
            currentLanguage == "uz" {
            let ageLastNumber = age % 10;
            let isExclusion = (age % 100 >= 11) && (age % 100 <= 14);

            if ageLastNumber == 1{
                res = "NOTIFICATIONS_YEAR_FULL".localized
            } else if (ageLastNumber == 0 || ageLastNumber >= 5 && ageLastNumber <= 9){
                res = "NOTIFICATIONS_YEARS_FULL".localized
                
            } else if (ageLastNumber >= 2 && ageLastNumber <= 4){
                res = "NOTIFICATIONS_YEARS2_FULL".localized
                
            }
            if isExclusion{
                res = "NOTIFICATIONS_YEARS_FULL".localized
            }
            return res;
        }

        if (currentLanguage == "pl") {
            let ageLastNumber = age % 10;
            let isExclusion = (age % 100 >= 11) && (age % 100 <= 14)

            if (age == 1){
                res = "NOTIFICATIONS_YEAR_FULL".localized
                
            }else if (ageLastNumber == 0 || ageLastNumber == 1 || ageLastNumber >= 5 && ageLastNumber <= 9){
                res = "NOTIFICATIONS_YEARS_FULL".localized
                
            } else if (ageLastNumber >= 2 && ageLastNumber <= 4){
                res = "NOTIFICATIONS_YEARS2_FULL".localized
                
            }
            if isExclusion{
                res = "NOTIFICATIONS_YEARS_FULL".localized
                
            }
            return res;
        }

        if age == 1 {
            res = "NOTIFICATIONS_YEAR_FULL".localized
        } else {
            res = "NOTIFICATIONS_YEARS2_FULL".localized
        }
        return res
    }
    
}
