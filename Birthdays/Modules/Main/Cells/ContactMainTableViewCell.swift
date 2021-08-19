//
//  ContactMainTableViewCell.swift
//  Birthdays
//
//  Created by Dima on 30.12.2020.
//

import UIKit

class ContactMainTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var daysToBirthdayLabel: PaddingLabel!
    @IBOutlet weak var ageStringLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
