//
//  NewsTabViewController.swift
//  AppForVK
//
//  Created by Mad Brains on 01.07.2020.
//  Copyright © 2020 Семериков Михаил. All rights reserved.
//

import Foundation
import UIKit

class NewsTabViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    let newsService = VkNewsService()
    
    var vkNews: VkNews?
    
    var isLoading = false
    var nextFrom: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setupRefreshControl()
        
        newsService.loadPartVKNews(startFrom: "",
            completion: { [weak self] news, error, from in
                guard let _ = error else {
                    
                    self?.vkNews = news
                    self?.tableView.reloadData()
                    
                    return
                }
                
                print("Some error")
            }
        )
        
        //setupRefreshControl()
    }
    
    // Функция настройки контроллера
    fileprivate func setupRefreshControl() {
        // Инициализируем и присваиваем сущность UIRefreshControl
        refreshControl = UIRefreshControl()
        // Настраиваем свойства контрола, как, например,
        // отображаемый им текст
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        // Цвет спиннера
        refreshControl?.tintColor = .red
        // И прикрепляем функцию, которая будет вызываться контролом
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshNews() {
        // Начинаем обновление новостей
        self.refreshControl?.beginRefreshing()
        // Определяем время самой свежей новости
        // или берем текущее время
        let mostFreshNewsDate = self.vkNews?.items.first?.repostDate ?? Date().timeIntervalSince1970
        // отправляем сетевой запрос загрузки новостей
        newsService.loadPartVKNews(
            startFrom: String(mostFreshNewsDate + 1),
            completion: { [weak self] items, error, dateFrom in
                guard let self = self else {
                    return
                }
                
                guard let news = items else {
                    self.refreshControl?.endRefreshing()
                    return
                }
                
                // выключаем вращающийся индикатор
                self.refreshControl?.endRefreshing()
                // проверяем, что более свежие новости действительно есть
                guard news.items.count > 0 else { return }
            
                // прикрепляем их в начало отображаемого массива
                self.vkNews?.items = news.items + (self.vkNews?.items ?? [])
                self.vkNews?.groups = news.groups + (self.vkNews?.groups ?? [])
                self.vkNews?.profiles = news.profiles + (self.vkNews?.profiles ?? [])
                // формируем indexPathes свежедобавленных секций и обновляем таблицу
                let indexPathes = news.items.enumerated().map { offset, element in
                    IndexPath(row: offset, section: 0)
                }
                
                self.tableView.insertRows(at: indexPathes, with: .automatic)
            }
        )
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "NewsTabCell", bundle: nil), forCellReuseIdentifier: "NewsTabCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
    }
    
}

extension NewsTabViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NewsTabViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vkNews?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTabCell", for: indexPath) as? NewsTabCell
 
        guard let uCell = cell, let uVkNews = vkNews else {
            print("Error with news cell")
            return UITableViewCell()
        }
    
        let sourceId = uVkNews.items[indexPath.row].postSource_id
    
        let ownerGroup = uVkNews.groups.filter { $0.ownerId == -sourceId }.first
        let ownerUser = uVkNews.profiles.filter { $0.ownerId == sourceId }.first
        
        let owner = ownerGroup == nil ? ownerUser : ownerGroup
        
        let photoWidth = uVkNews.items[indexPath.section].attachments_photoWidth
        let photoHeight = uVkNews.items[indexPath.section].attachments_photoHeight
        
        var ratio: CGFloat = 1.0000
        if photoHeight != 0 {
            ratio = CGFloat(photoWidth) / CGFloat(photoHeight)
        }
        
        uCell.configure(with: vkNews?.items[indexPath.row], owner: owner, photoHeight: (tableView.frame.width / ratio))
        
        return uCell
    }
    
    
}

extension NewsTabViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell(for:)) {
            // отправляем сетевой запрос загрузки новостей
            newsService.loadPartVKNews(
                startFrom: SessionApp.shared.nextFrom,
                completion: { [weak self] items, error, dateFrom in
                    guard let self = self else {
                        return
                    }
                    
                    self.vkNews?.items = (self.vkNews?.items ?? []) + (items?.items ?? [])
                    self.vkNews?.groups = (self.vkNews?.groups ?? []) + (items?.groups ?? [])
                    self.vkNews?.profiles = (self.vkNews?.profiles ?? []) + (items?.profiles ?? [])
                    
                    self.tableView.reloadData()
                }
            )
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == (self.vkNews!.items.count - 3)
    }
    
}
