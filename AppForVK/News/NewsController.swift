//
//  NewsController.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 04/01/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class NewsController: UITableViewController {
    
    private let vkService = VKService()
    private let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    private var notificationToken: NotificationToken?
    private var news: Results<News>?
    private var owners: Results<Owner>?
    private var videos: Results<Video>?
    
    var isExpand: Bool = false {
        didSet {
            if isExpand != oldValue {
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 3)], with: .fade)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl!.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "NewsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: NewsHeaderTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "NewsRepostHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: NewsRepostHeaderTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "NewsTextTableViewCell", bundle: nil), forCellReuseIdentifier: NewsTextTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "NewsImageTableViewCell", bundle: nil), forCellReuseIdentifier: NewsImageTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "NewsFooterTableViewCell", bundle: nil), forCellReuseIdentifier: NewsFooterTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "NewsSeparatorTableViewCell", bundle: nil), forCellReuseIdentifier: NewsSeparatorTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "NewsDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: NewsDefaultTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "NewsWebViewTableViewCell", bundle: nil), forCellReuseIdentifier: NewsWebViewTableViewCell.reuseIdentifier)
        
        loadNews(from: SessionApp.shared.nextFrom)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        //let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: config) else { return }
        news = realm.objects(News.self).sorted(byKeyPath: "titlePostTime", ascending: false)
        owners = realm.objects(Owner.self)
        videos = realm.objects(Video.self)
        notificationToken = news?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertSections(IndexSet(insertions), with: .automatic)
                tableView.deleteSections(IndexSet(deletions), with: .automatic)
                tableView.reloadSections(IndexSet(modifications), with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    func loadNews(from: String) {
        vkService.loadVKNewsFeed(startFrom: from) { news, users, groups, nextFrom, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let news = news, let users = users, let groups = groups {
                RealmProvider.save(items: users)
                RealmProvider.save(items: groups)
                RealmProvider.save(items: news)
            }
        }
    }
    
    func loadVideos(request: String) {
        vkService.getVideo(q: request) { videos, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let videos = videos {
                RealmProvider.save(items: videos)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 54
        case 1:
            if news![indexPath.section].postText == "" {
                return 0
            } else {
                let attributedText = news![indexPath.section].postText.attributedString(font: UIFont.systemFont(ofSize: 15), lineSpacing: 9)
                let size = attributedText?.boundingRect(with: CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                if isExpand {
                    return UITableView.automaticDimension
                } else {
                    if Int(size!.height) > 50 {
                        return 50
                    } else {
                        return UITableView.automaticDimension
                    }
                }
                
            }
        case 2:
            if news![indexPath.section].attachments_typePhoto == "" {
                return 0
            } else {
                let photoWidth = news?[indexPath.section].attachments_photoWidth ?? Int(tableView.frame.width)
                let photoHeight = news?[indexPath.section].attachments_photoHeight ?? Int(tableView.frame.width)
                var ratio: CGFloat = 1.0000
                if photoHeight != 0 {
                    ratio = CGFloat(photoWidth) / CGFloat(photoHeight)
                }
                return tableView.frame.width / ratio
            }
        case 3:
            if news![indexPath.section].repostOwnerId == 0 {
                return 0
            } else {
                return 44
            }
        case 4:
            if news![indexPath.section].repostText == "" {
                return 0
            } else {
                return UITableView.automaticDimension
            }
        case 5:
            if news![indexPath.section].repostPhoto == "" {
                return 0
            } else {
                let photoWidth = news?[indexPath.section].repostPhotoWidth ?? Int(tableView.frame.width)
                let photoHeight = news?[indexPath.section].repostPhotoHeight ?? Int(tableView.frame.width)
                var ratio: CGFloat = 1.0000
                if photoHeight != 0 {
                    ratio = CGFloat(photoWidth) / CGFloat(photoHeight)
                }
                return tableView.frame.width / ratio
            }
        case 6:
            return 24
        case 7:
            return 5
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell") as? NewsHeaderTableViewCell else { return UITableViewCell() }
            guard var sourceID = news?[indexPath.section].postSource_id else { return  UITableViewCell() }
            var urlUserImage = ""
            if sourceID > 0 {
                urlUserImage = owners?.filter("ownerId == %@", sourceID)[0].ownerPhoto ?? "https://vk.com/images/error404.png"
                cell.userName.text = owners?.filter("ownerId == %@", sourceID)[0].userName
            } else {
                sourceID = -sourceID
                urlUserImage = owners?.filter("ownerId == %@", sourceID)[0].ownerPhoto ?? "https://vk.com/images/error404.png"
                cell.userName.text = owners?.filter("ownerId == %@", sourceID)[0].groupName
            }
            cell.userImage.kf.setImage(with: URL(string: urlUserImage))
            cell.newsDate.text = Date(timeIntervalSince1970: news![indexPath.section].titlePostTime).timeAgo(numericDates: false) //TODO: - убрать force-unwrap
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell") as? NewsTextTableViewCell else { return UITableViewCell() }
            
            let text = news![indexPath.section].postText
            let attrString = NSMutableAttributedString(string: text, attributes: TextStyles.postStyle)
            
            cell.newsText.attributedText = attrString
            cell.newsText.isUserInteractionEnabled = true
            
            let size = attrString.boundingRect(with: CGSize(width: cell.frame.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            
            if isExpand {
                cell.expandButton.isHidden = true
                cell.expandAction = nil
            } else {
                if size.height > 50 {
                    cell.expandButton.isHidden = false
                    cell.expandAction = { [weak self] (button) in
                        self?.isExpand = true
                        cell.expandButton.isHidden = true
                    }
                } else {
                    cell.expandButton.isHidden = true
                    cell.expandAction = nil
                }
            }
            
            return cell
        case 2:
            if news![indexPath.section].attachments_typePhoto == "" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDefaultCell") as? NewsDefaultTableViewCell else { return UITableViewCell() }
                return cell
            } else {
                if news![indexPath.section].attachmentsType == "video" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsWebViewCell") as? NewsWebViewTableViewCell else { return UITableViewCell() }
                    let q = String(news![indexPath.section].attachmentsOwnerId) + "_" + String(news![indexPath.section].attachmentsId)
                    loadVideos(request: q)
                    let videoID = news![indexPath.section].attachmentsId
                    guard let videos = videos?.filter("id == %@", videoID) else { return cell }
                    if !videos.isEmpty {
                        print("We have got some(\(videos.count)) videos")
                        let player = videos[0].player
                        cell.configure(player: player)
                    } else {
                        print("Seems it's a perfect time to have some crash.")
                        let player = "https://vk.com/images/error404.png"
                        cell.configure(player: player)
                    }
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell") as? NewsImageTableViewCell else { return UITableViewCell() }
                    let imageURL = news![indexPath.section].attachments_typePhoto //TODO: - убрать force-unwrap
                    cell.newsImage.kf.setImage(with: URL(string: imageURL))
                    return cell
                }
            }
        case 3:
            if news![indexPath.section].repostOwnerId == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDefaultCell") as? NewsDefaultTableViewCell else { return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsRepostHeaderCell") as? NewsRepostHeaderTableViewCell else { return UITableViewCell() }
                var sourceID = news![indexPath.section].repostOwnerId
                var urlUserImage = ""
                if sourceID > 0 {
                    urlUserImage = owners?.filter("ownerId == %@", sourceID)[0].ownerPhoto ?? "https://vk.com/images/error404.png"
                    cell.userName.text = "↪" + owners!.filter("ownerId == %@", sourceID)[0].userName
                } else {
                    sourceID = -sourceID
                    urlUserImage = owners?.filter("ownerId == %@", sourceID)[0].ownerPhoto ?? "https://vk.com/images/error404.png"
                    cell.userName.text = "↪" + owners!.filter("ownerId == %@", sourceID)[0].groupName
                }
                
                cell.userImage.kf.setImage(with: URL(string: urlUserImage))
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                dateFormatter.locale = Locale(identifier: "ru_RU")
                
                let date = Date(timeIntervalSince1970: news![indexPath.section].repostDate) //TODO: - убрать force-unwrap
                cell.newsDate.text = dateFormatter.string(from: date)
                return cell
            }
        case 4:
            if news![indexPath.section].repostText == "" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDefaultCell") as? NewsDefaultTableViewCell else { return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell") as? NewsTextTableViewCell else { return UITableViewCell() }
                cell.newsText.text = news![indexPath.section].repostText //TODO: - убрать force-unwrap
                return cell
            }
        case 5:
            if news![indexPath.section].repostPhoto == "" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDefaultCell") as? NewsDefaultTableViewCell else { return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell") as? NewsImageTableViewCell else { return UITableViewCell() }
                let imageURL = news![indexPath.section].repostPhoto //TODO: - убрать force-unwrap
                cell.newsImage.kf.setImage(with: URL(string: imageURL))
                return cell
            }
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFooterCell") as? NewsFooterTableViewCell else { return UITableViewCell() }
            
            cell.delegateButton = self
            cell.indexPathCell = indexPath
            
            if news![indexPath.section].userLikes == 1 {
                cell.likeButton.setImage(UIImage(named: "Heart"), for: .normal)
                cell.likeLabel.textColor = UIColor.vkRed
            } else {
                cell.likeButton.setImage(UIImage(named: "HeartWhite"), for: .normal)
                cell.likeLabel.textColor = UIColor.vk_color
            }
            
            cell.likeLabel.text = String(news![indexPath.section].likesCount)
            cell.commentLabel.text = String(news![indexPath.section].commentsCount)
            cell.iconCommentWidth.constant = 20
            cell.commentLabelWidth.constant = 40
            cell.commentLeadingConstraint.constant = 8
            cell.shareLabel.text = String(news![indexPath.section].repostsCount)
            cell.viewsLabel.text = String(news![indexPath.section].viewsCount)
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsSeparatorCell") as? NewsSeparatorTableViewCell else { return UITableViewCell() }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDefaultCell") as? NewsDefaultTableViewCell else { return UITableViewCell() }
            return cell
        }
    }
    
    @objc private func refresh(_ sender: Any) {
        refreshBegin(refreshEnd: {() -> () in
            self.refreshControl?.endRefreshing()
        })
    }
    
    func refreshBegin(refreshEnd: @escaping () -> ()) {
        DispatchQueue.global().async() {
            self.loadNews(from: "")
            DispatchQueue.main.async {
                refreshEnd()
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
}

extension NewsController: CellForButtonsDelegate {
    
    func didTapCompleteButton(indexPath: IndexPath) {
        if news![indexPath.row].userLikes == 0 {
            vkService.addOrDeleteLike(likeType: .post, owner_id: news![indexPath.row].postSource_id, item_id: news![indexPath.row].post_id , action: .addLike)
            do {
                guard let realm = try? Realm(configuration: self.config) else { return }
                realm.beginWrite()
                news![indexPath.row].userLikes = 1
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            vkService.addOrDeleteLike(likeType: .post, owner_id: news![indexPath.row].postSource_id, item_id: news![indexPath.row].post_id , action: .deleteLike)
            do {
                guard let realm = try? Realm(configuration: self.config) else { return }
                realm.beginWrite()
                news![indexPath.row].userLikes = 0
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

protocol CellForButtonsDelegate {
    func didTapCompleteButton(indexPath: IndexPath)
}

extension NewsController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell(for:)) {
            loadNews(from: SessionApp.shared.nextFrom)
            print(SessionApp.shared.nextFrom)
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.section == (self.news!.count - 1)
    }
}
