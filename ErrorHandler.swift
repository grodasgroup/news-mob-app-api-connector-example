//
//  ErrorHandler.swift
//  Copyright © 2018 Grodas. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandler {
    
    private var localization = Locale(locale: Language.language.english)
    
    func getDataErrorAlert(message: String) -> UIAlertController {
        let errorAlert = UIAlertController(title: self.localization.dataErrorText, message: message, preferredStyle: .alert)
        return errorAlert
    }

    func presentAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))

        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}
