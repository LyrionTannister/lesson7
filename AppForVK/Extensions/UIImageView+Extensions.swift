//
//  UIImageView+Extensions.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 04.11.2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
