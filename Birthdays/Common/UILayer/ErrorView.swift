//
//  ErrorView.swift
//  CallTaxi
//
//  Created by Yura Chudnovets on 10/2/18.
//  Copyright © 2018 Lubimoe Taxi. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    var errorText: String = "" {
        didSet {
            errorLabel.text = errorText
        }
    }
    
    private let errorLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
       // l.font = UIFont(name: "SFProDisplay-Regular", size: 18)
        l.font =  .systemFont(ofSize: 18.0)
        l.textAlignment = .center
        l.minimumScaleFactor = 0.5
        l.numberOfLines = 2
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
        
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([errorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
                                     errorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
                                     errorLabel.topAnchor.constraint(equalTo: topAnchor),
                                     errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
    }
    
    func show(with text: String) {
        errorText = text
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 3, options: [], animations: {
                self.alpha = 0
            }, completion: nil)
        }
    }

}
