//
//  VoteVC.swift
//  CallTaxi
//
//  Created by yura on 7/15/19.
//  Copyright © 2019 Lubimoe Taxi. All rights reserved.
//

import UIKit

protocol NoNetworkViewProtocol: AnyObject {
    func  showAboutView()
    func hideAboutView()
}

class AboutVC: NiblessViewController{
    
    var presenter: AboutPresenterProtocol!
    let noNetworkView = AboutView()
    var isShowed = false
    
    override init() {
        super.init()
        
        setupPresentationStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isShowed { return }
        showAboutView()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func setupPresentationStyle() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    fileprivate func setupViews() {
        
        view.addSubview(noNetworkView)
        noNetworkView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: noNetworkView.topAnchor, constant: 0).isActive = true
            view.leadingAnchor.constraint(equalTo: noNetworkView.leadingAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: noNetworkView.bottomAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: noNetworkView.trailingAnchor, constant: 0).isActive = true
            
        } else {
            view.topAnchor.constraint(equalTo: noNetworkView.topAnchor, constant: 0).isActive = true
            view.leadingAnchor.constraint(equalTo: noNetworkView.leadingAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: noNetworkView.bottomAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: noNetworkView.trailingAnchor, constant: 0).isActive = true
        }
    }
    
    fileprivate func setupCallbacks() {
        
        noNetworkView.shareButtonCallback = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.share()
        }
        
        noNetworkView.closeButtonCallback = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.presenter.cancelButtonPressed()
        }
    }
    
    private func share(){
        let textToShare = [ Utils.getAppName() + " " + URLs.appStoreURL]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        //avoiding to crash on iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension AboutVC: NoNetworkViewProtocol {
    
    // MARK: - Show/Hide with animation
    
    func showAboutView() {
        var height: CGFloat = noNetworkView.bounds.height
        if #available(iOS 11.0, *) {
            height += UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        noNetworkView.center.y += height
        UIView.animate(withDuration: 0.25, delay: 0.05, options: [.curveEaseOut], animations: {
            self.noNetworkView.center.y -= height
        }, completion: { _ in
            self.isShowed = true
        })
    }
    
    func hideAboutView() {
        var height: CGFloat = noNetworkView.bounds.height
        if #available(iOS 11.0, *) {
            height += UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn], animations: {
            self.noNetworkView.center.y += height
        }, completion: { _ in
            self.presenter.cancelButtonPressed()
            //self.dismiss(animated: true, completion: nil)
        })
    }
    
}

extension AboutVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is AboutVC {
            return DismissAnimationController()
        }
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimationController()
    }
}
