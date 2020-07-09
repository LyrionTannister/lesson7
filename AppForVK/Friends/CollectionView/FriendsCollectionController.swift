//
//  FriendsCollectionController.swift
//  AppForVK
//
//  Created by Семериков Михаил on 23.12.2018.
//  Copyright © 2018 Семериков Михаил. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendsCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet var friendCollectionView: UICollectionView!
    
    private let vkService = VKService()
    private var friendsImages: [String] = []
    private var photos: Results<Photo>?
    private let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    private var notificationToken: NotificationToken?
    var user: Int = 0
 
    override func viewDidLoad() {
        //super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.addGestures()
        loadPhotosFromVK(for: user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationToken = photos?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates( {
                    self?.collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                    self?.collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    self?.collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                }, completion: { (completed: Bool) in self?.collectionView.reloadData() })
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionCell", for: indexPath) as! FriendsCollectionCell
        let imageURL = photos?[indexPath.row].url
        cell.friendImage.kf.setImage(with: URL(string: imageURL ?? "https://vk.com/images/error404.png"))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 1) {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1) {
            cell.alpha = 0
            cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        //let height = self.view.frame.height
        let height = collectionView.contentSize.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Gestures
    
    private func addGestures() {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        downSwipe.direction = .down
        
        self.view.addGestureRecognizer(downSwipe)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        self.swipeGesture(afterGesture: gesture)
    }
    
    private func swipeGesture(afterGesture gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .down:
            if let nvc = navigationController {
                UIView.animate(withDuration: 0.6,
                               animations: {
                                //self.mainImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                                //self.mainImage.alpha = 0
                }, completion: { _ in nvc.popViewController(animated: false)
                }
                )} else {
                dismiss(animated: true, completion: nil)
            }
        default: return
        }
    }
    
    // MARK: - Realm
    
    func loadPhotosFromVK(for user: Int) {
        guard let realm = try? Realm(configuration: self.config) else { return }
        photos = realm.objects(Photo.self).filter("ownerId == %@", user)
        
        vkService.loadVKPhotos(for: user) { photos, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let photos = photos {
                RealmProvider.save(items: photos)
            }
        }
    }
}
