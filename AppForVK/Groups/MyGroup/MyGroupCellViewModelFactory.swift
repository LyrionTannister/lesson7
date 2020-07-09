//
//  MyGroupCellViewModelFactory.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 04.11.2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit
import Kingfisher

final class MyGroupCellViewModelFactory {
    
    func constructViewModels(from groups: [Group]) -> [MyGroupCellViewModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(from group: Group) -> MyGroupCellViewModel {
        let myGroupNameText = group.name
        var image: UIImage?
        let urlString = group.photo_50

        let url = NSURL(string: urlString)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            image = UIImage(data: imageData as Data)
        }
        
        return MyGroupCellViewModel(myGroupNameText: myGroupNameText, myGroupImage: image ?? UIImage(named: "appleIcon")!)
    }
    
}
