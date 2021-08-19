//
//  VoteViewNib.swift
//  CallTaxi
//
//  Created by Dima on 07.05.2021.
//  Copyright © 2021 Lubimoe Taxi. All rights reserved.
//

import UIKit

class AboutView: UIView {
    
    @IBOutlet var mainContentView: UIView!
    @IBOutlet weak var windowView: UIView!
    @IBOutlet weak var windowLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var windowTrallingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    var shareButtonCallback: (() -> Void)?
    var closeButtonCallback: (() -> Void)?
    
   // var gesture: UITapGestureRecognizer!
   // var gesture2: UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AboutView", owner: self, options: nil)
        addSubview(mainContentView)
        mainContentView.frame = self.bounds
        mainContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            windowLeadingConstraint.isActive = false
            windowTrallingConstraint.isActive = false
            windowView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        }
        
        windowView.shadow()
 
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.mainContentViewTouched (_:)))
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.windowViewTouched (_:)))
        self.mainContentView.addGestureRecognizer(gesture)
        self.windowView.addGestureRecognizer(gesture2)
    }
    
    @objc func mainContentViewTouched(_ sender:UITapGestureRecognizer){
        closeButtonCallback?()
    }
    
    @objc func windowViewTouched(_ sender:UITapGestureRecognizer){
        print("TOUCH2")
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        closeButtonCallback?()
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        shareButtonCallback?()
    }
}
