//
//  LoginFormController.swift
//  AppForVK
//
//  Created by Семериков Михаил on 15.12.2018.
//  Copyright © 2018 Семериков Михаил. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

final class LogonFormController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    let vkService = VKService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            //URLQueryItem(name: "client_id", value: "6849043"), //AppForVK
            URLQueryItem(name: "client_id", value: "6932198"), //AppForVK2
            //URLQueryItem(name: "client_id", value: "6704883"), //Andrey Antropov
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "offline,friends,photos,groups,wall,email,video"),
            //URLQueryItem(name: "scope", value: "274438"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
    
    func logoutVK() {
        let dataStore = WKWebsiteDataStore.default()
        print("Logout")
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                if record.displayName == "vk.com" {
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: {
                    })
                }
            }
        }
        
        guard let realm = try? Realm() else { return }
        realm.beginWrite()
        realm.deleteAll()
        do {
            try! realm.commitWrite()
        }
    }
    
}

extension LogonFormController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else { decisionHandler(.allow)
            return }
        let params = fragment
            .components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        guard let token = params["access_token"], let userId = Int(params["user_id"]!) else { decisionHandler(.cancel)
            return
        }
        
        SessionApp.shared.token = token
        SessionApp.shared.userId = userId
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MainViewController
        present(vc, animated: true)
        
//        let newsVC = NewsTextureController()
//        newsVC.modalTransitionStyle = .crossDissolve
//        present(newsVC, animated: false)
        
        decisionHandler(.cancel)
    }
}
