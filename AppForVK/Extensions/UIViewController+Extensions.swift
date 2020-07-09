//
//  UIViewController+Extensions.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 04/03/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(_ error: Error) {
        let alertVC = UIAlertController(title: "Error",
                                        message: error.localizedDescription,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension Collection {
    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }
}
