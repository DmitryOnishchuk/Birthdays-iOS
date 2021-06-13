import UIKit

class ToolBarTitleItem: UIBarButtonItem {

    init(text: String, font: UIFont, color: UIColor) {
        let label =  UILabel(frame: UIScreen.main.bounds)
        label.text = text
        label.sizeToFit()
        label.font = font
        label.textColor = color
        label.textAlignment = .center
        super.init()
        customView = label
    }
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}
