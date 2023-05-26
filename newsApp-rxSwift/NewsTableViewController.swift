//
//  NewsTableViewController.swift
//  newsApp-rxSwift
//
//  Created by Zeyad on 26/05/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {
    
    let disposeBage = DisposeBag()
    private var articles = [Article]()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        fetchNews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("Article table view cell doesnt exist")
        }
        cell.titleLabel.text = self.articles[indexPath.row].title
        cell.descriptionLabel.text = self.articles[indexPath.row].description
        return cell
    }
    
    private func fetchNews() {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=1bf972ca25d84036a0c1641ed57f1119")!
        Observable.just(url)
            .flatMap{
                url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> [Article]? in
                return try? JSONDecoder().decode(ArticlesList.self, from: data).articles
            }.subscribe(onNext: {
                [weak self] articles in
                if let articles = articles {
                    self?.articles = articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBage)
    }
}
