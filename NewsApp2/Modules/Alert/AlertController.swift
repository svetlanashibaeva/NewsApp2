//
//  AlertController.swift
//  NewsApp2
//
//  Created by Света Шибаева on 05.08.2022.
//

import UIKit

extension UIViewController {
    func showError(error: String, handler: ((UIAlertAction) -> Void)? = nil) {
         let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
         let errorAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
         alertController.addAction(errorAction)

         present(alertController, animated: true, completion: nil)
     }
}
