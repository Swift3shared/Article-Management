//
//  ArticleListViewController.swift
//  Channy-Resturant-MVP-Homework
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit


class ArticleListViewController: UITableViewController {
    
    var articles:Array<Article> = []
    var articlePresenter:ArticlePresenter?
    
    override init(nibName name: String?, bundle: Bundle?) {
        super.init(nibName: name, bundle: bundle)

        navigationItem.title = "Article"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ArticleListViewController.addArticlePressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Upload", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ArticleListViewController.uploadsPressed))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(ArticleListViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl = self.refreshControl
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        articlePresenter = ArticlePresenter()
        articlePresenter?.attachToDelegate = self
        articlePresenter?.getArticle(PAGE_NUMBER, NUMBER_OF_REROCE)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if articles.count == 0, articlePresenter != nil{
            articlePresenter?.getArticle(PAGE_NUMBER, NUMBER_OF_REROCE)
        }
    }
    
    func addArticlePressed(){
        let articleDetailViewController = ArticleDetailViewController(nibName: nil, bundle: nil)
        articleDetailViewController.artileListViewController = self
        navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
    
    func uploadsPressed(_ sender : UIBarButtonItem) {
        let uploadImagesViewController = UploadImagesViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(uploadImagesViewController, animated: true)
    }
    
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("Refresh")
        if PAGE_NUMBER > 1 {
            PAGE_NUMBER = 1
            TOTALE_PAGE = 1
            articlePresenter?.getArticle(PAGE_NUMBER, NUMBER_OF_REROCE)
        }else{
            refreshControl.endRefreshing()
        }
    }
    
    func updateArticle(atIndexParth indexPath: IndexPath, article : Article) {
        DispatchQueue.main.async {
            self.articles.remove(at: indexPath.row)
            self.articles.insert(article, at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
}

////////////////////
// DELEGAGE  ///////
////////////////////
extension ArticleListViewController : ArticleDeletage {
       
    func setArticleList(_ articles: Array<Article>) {
        if articles.count > 0 {
            self.articles = []
        }
        self.articles.append(contentsOf: articles)
        tableView.reloadData()
    }
    
    func setFinishRefresh() {
        print("try stop spin")
        DispatchQueue.main.async {
            print("aSyn")
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    /** Create     **/
    func setCreateCompleted(_ article: Article) {
        DispatchQueue.main.async {
            self.articles.insert(article, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .left)
            self.tableView.reloadData()
        }
    }
    
    /** pagination **/
    func updateArticleList(_ articles: Array<Article>) {
        self.articles.append(contentsOf: articles)
        print("Appended \(self.articles.count)")
        tableView.reloadData()
    }
    
    func setDeleteCompleted(atIndexPath indextPath : IndexPath) {
        print(indextPath.row)
        DispatchQueue.main.async{
            self.articles.remove(at: indextPath.row)
            self.tableView.deleteRows(at: [indextPath], with: .left)
        }
        
    }
    
    func setDeleteFailed(_ index: Int) {
        self.messageAlter("Error", "This article cannot delete.")
    }
    
    func messageAlter(_ title : String, _ message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


//////////////////
/// Table View ///
//////////////////
extension ArticleListViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ArticleCell", owner: self, options: nil)?.first as! ArticleCell
        DispatchQueue.main.async {            
            cell.configuration(self.articles[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if indexPath.row >= self.articles.count - 1 {
                if PAGE_NUMBER < TOTALE_PAGE {
                    PAGE_NUMBER = PAGE_NUMBER + 1
                    print(PAGE_NUMBER)
                    self.articlePresenter?.getArticle(PAGE_NUMBER , NUMBER_OF_REROCE)
                }
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = Bundle.main.loadNibNamed("ArticleCell", owner: self, options: nil)?.first as! ArticleCell
        return cell.bounds.height
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{
            action, indexpath in
            self.articlePresenter?.deleteArticle(self.articles[indexPath.row].id!, atIndexPath: indexPath)
        });
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{
            action, indexpath in
            let articleDetailViewController = ArticleDetailViewController(nibName: nil, bundle: nil)
            articleDetailViewController.articleToUpdate = self.articles[indexPath.row]
            articleDetailViewController.artileListViewController = self
            articleDetailViewController.indexPathToUpdate = indexPath
            _ = self.navigationController?.pushViewController( articleDetailViewController, animated: true)
        });
        deleteRowAction.backgroundColor = UIColor.red
        editRowAction.backgroundColor = UIColor.green
        return [deleteRowAction,editRowAction]
    }

}

