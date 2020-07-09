//
//  FriendsPhotoGallery.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 27/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit

class FriendsPhotoGallery: UIViewController {

    @IBOutlet private weak var friendImage: UIImageView!
    @IBOutlet weak var animateView: UIView!
    
    var images = [UIImage]()
    var currentPhoto: UIImage!
    var indexOfImage: Int = 0
    var swipeGesture = UISwipeGestureRecognizer()
    var interactiveAnimator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .right, .left]
        for direction in directions {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            view.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
        }

        interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            self.animateView.transform = .init(scaleX: 0.8, y: 0.8)
        }

    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            if (indexOfImage - 1) >= 0 {
                currentPhoto = images[indexOfImage - 1]
                indexOfImage -= 1

//                interactiveAnimator.startAnimation()
                
            }
        } else if gesture.direction == .left {
            if (indexOfImage + 1) < images.count {
                currentPhoto = images[indexOfImage + 1]
                indexOfImage += 1
                
                //interactiveAnimator.startAnimation()
            }
        }
        self.friendImage.image = currentPhoto
    }
    
    func imageToDisplay() {
        self.friendImage.image = currentPhoto
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.friendImage.image = currentPhoto
    }

}
