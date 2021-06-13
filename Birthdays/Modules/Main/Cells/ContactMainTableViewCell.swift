//
//  ContactMainTableViewCell.swift
//  Birthdays
//
//  Created by Dima on 30.12.2020.
//

import UIKit

class ContactMainTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabelView: UILabel!
    @IBOutlet weak var birthdayLabelView: UILabel!
    @IBOutlet weak var daysToBirthdayLabelView: UILabel!
    @IBOutlet weak var ageStringLabelView: UILabel!
    @IBOutlet weak var ageLabelView: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
