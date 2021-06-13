import UIKit

class NotificationPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var days: [String] = []
    private var hours: [String] = []
    private var minutes: [String] = []
    
    public var timeEvent = TimeEvent(day: -1, time: "10:00") {
        didSet{
            setTime()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        generateDays()
        generateHours()
        generateMinutes()
        DispatchQueue.main.async { self.setTime() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTime(){
        
        let fullTimeArr = timeEvent.time.components(separatedBy: ":")
        
        let hour = fullTimeArr[0]
        let minute = fullTimeArr[1]
        
        if let indexOfarray = hours.firstIndex(of: hour){
            self.selectRow(indexOfarray, inComponent: 1, animated: false)
        }
        if let indexOfarray = minutes.firstIndex(of: minute){
            self.selectRow(indexOfarray, inComponent: 2, animated: false)
        }
        
        if let indexOfarray = days.firstIndex(of: timeEvent.getTextByDay()){
            self.selectRow(indexOfarray, inComponent: 0, animated: false)
        }
        
        
    }
    
    func generateDays(){
        days.removeAll()
        
        for day in -1...8 {
            timeEvent.day = day
            days.append(timeEvent.getTextByDay())
        }
    }
    
    func generateHours(){
        hours.removeAll()
        for i in 0...23  {
            hours.append(String(format: "%02d", i))
        }
    }
    
    func generateMinutes(){
        minutes.removeAll()
        for i in 0...59  {
            minutes.append(String(format: "%02d", i))
        }
    }
    
    
    
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let currentDay = pickerView.selectedRow(inComponent: 0)
        var currentHour = hours[pickerView.selectedRow(inComponent: 1)]
        var currentMinute = minutes[pickerView.selectedRow(inComponent: 2)]
        
        switch currentDay {
        case 0:
            timeEvent.day = -1
            break
        case 1:
            timeEvent.day = 0
            break
        case 2:
            timeEvent.day = 1
            break
        case 3:
            timeEvent.day = 2
            break
        case 4:
            timeEvent.day = 3
            break
        case 5:
            timeEvent.day = 4
            break
        case 6:
            timeEvent.day = 5
            break
        case 7:
            timeEvent.day = 6
            break
        case 8:
            timeEvent.day = 7
            break
        case 9:
            timeEvent.day = 8
            break
        default:
            timeEvent.day = -1
        }
        
        timeEvent.time = currentHour + ":" + currentMinute
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return hours.count
        case 2:
            return minutes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(days[row])
        case 1:
            return String(hours[row])
        case 2:
            return String(minutes[row])
        default:
            return "?"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
}
