//
//  AlertController.swift
//  TechGropseMT
//
//  Created by Satish Thakur on 16/05/20.
//  Copyright © 2020 Satish Thakur. All rights reserved.
//

import Foundation
import UIKit

struct AlertController {
    func showAlert(viewController: UIViewController, title: String, message: String, buttonTitle: String) {

        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let attributedMessage: NSMutableAttributedString = NSMutableAttributedString(
            string: message, // your string message here
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: .default
            ]
        )
        alertController.setValue(attributedMessage, forKey: "attributedMessage")

        alertController.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: {action in
            debugPrint(action)
        }))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
