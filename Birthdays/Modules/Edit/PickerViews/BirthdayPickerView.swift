import UIKit

class BirthdayPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var days: [Int] = []
    private var months: [Int] = []
    private var years: [String] = []
    public var date: Date = Date() {
        didSet{
            setDate()
        }
    }
    public var text: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        generateYears()
        generateMonths()
        generateDays(date)
        setText()
        DispatchQueue.main.async { self.setDate() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(){
        text = DateFunctions.dateToHumanString(date)
    }
    
    func setDate(){
        generateDays(date)
        setText()

        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        
        if let year = calendarDate.year {
            if year == 1 {
                self.selectRow(years.count - 1, inComponent: 2, animated: false)
            }else{
                if let indexOfarray = years.firstIndex(of: String(year)){
                    self.selectRow(indexOfarray, inComponent: 2, animated: false)
                }
            }
        }
        if let month = calendarDate.month {
            if let indexOfarray = months.firstIndex(of: month){
                self.selectRow(indexOfarray, inComponent: 1, animated: false)
            }
        }
        if let day = calendarDate.day {
            if let indexOfarray = days.firstIndex(of: day){
                self.selectRow(indexOfarray, inComponent: 0, animated: false)
            }
        }
    }
    
    func generateYears(){
        years.removeAll()
        let currentYear = Calendar.current.component(.year, from: date)
        for year in 1900...currentYear {
            years.append(String(year))
        }
        years.append("----")
    }
    
    func generateMonths(){
        months.removeAll()
        months = [1,2,3,4,5,6,7,8,9,10,11,12]
    }
    
    func generateDays(_ forDate: Date){
        days.removeAll()
        
        let calendarDate = Calendar.current.dateComponents([.year, .month, .day], from: forDate)
        let year = calendarDate.year
        let month = calendarDate.month
        
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: forDate)!
        let numDays = range.count
        
        for day in 1...numDays {
            days.append(day)
        }
    }
    
    func generateDays31(){
        days.removeAll()
        
        for day in 1...31 {
            days.append(day)
        }
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        var currentYear = -1
        
        
        if pickerView.selectedRow(inComponent: 2) + 1 == years.count {
            currentYear = 1
        }else{
            currentYear = Int(years[pickerView.selectedRow(inComponent: 2)])!
        }
        
        
        let currentMonth = months[pickerView.selectedRow(inComponent: 1)]
        var currentDay = days[pickerView.selectedRow(inComponent: 0)]
        
        let dateStr = String(currentYear) + "-" + String(format: "%02d", currentMonth) + "-" + "01" + "T00:00:00+0000"
        
        if component == 1 || component == 2{
            if currentYear == 1 {
                let dateStrLeapYear = String(2020) + "-" + String(format: "%02d", currentMonth) + "-" + "01" + "T00:00:00+0000"
                generateDays(dateStrLeapYear.toDate()!)
            }else{
                generateDays(dateStr.toDate()!)
            }
            pickerView.reloadComponent(0)
        }
        
        if currentDay > days.count{
            currentDay = days.last!
        }
        
        let dateStr2 = String(format: "%04d", currentYear) + "-" + String(format: "%02d", currentMonth) + "-" + String(format: "%02d", currentDay) + "T00:00:00+0000"

        date = dateStr2.toDate()!
        setText()
    }
        
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return months.count
        case 2:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(days[row])
        case 1:
            return DateFunctions.getMonthName(months[row])
        case 2:
            return String(years[row])
        default:
            return "?"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
}
