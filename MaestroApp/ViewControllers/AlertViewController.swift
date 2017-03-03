//
//  AlertViewController.swift
//  MaestroPanel
//

import UIKit

class AlertViewController{
    static func getUIAlertLoding(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        return alert;
    }
    
    static func getUIAlertInfo(_ message: String) -> UIAlertController {
        let infoAlert : UIAlertController = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        infoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
    
        }))
        return infoAlert;
    }
}
