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
    
    // empty View and activity indicator
    var emptyView:UIView?
    var activityIndicator:UIActivityIndicatorView?
    
    override init(nibName name: String?, bundle: Bundle?) {
        super.init(nibName: name, bundle: bundle)

        navigationItem.title = "Article"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ArticleListViewController.addArticlePressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Upload", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ArticleListViewController.uploadsPressed))
        
        //make the empty view become full screen
        emptyView = UIView(frame: UIScreen.main.bounds)
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (emptyView?.frame.width)!/2,y: (emptyView?.frame.height)!/2, width: 15, height: 15))
        
        emptyView!.backgroundColor = UIColor.brown
        emptyView!.addSubview(activityIndicator!)
        
        self.view.addSubview(emptyView!)
       
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
        
        self.refreshControl?.addTarget(self, action: #selector(ArticleListViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        self.refreshControl = UIRefreshControl(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 40))
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        //self.tableView.tableFooterView.en
        let uiView = UIView(frame:CGRect(x: 20, y: 0, width: 20, height: 50))
        uiView.backgroundColor = UIColor.blue
        self.tableView.tableFooterView?.addSubview(uiView)
        
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
        PAGE_NUMBER = 1
        articlePresenter?.getArticle(PAGE_NUMBER, NUMBER_OF_REROCE)
    }
    
    
    
    func updateArticle(atIndexParth indexPath: IndexPath, article : Article) {
        articles[indexPath.row].title = article.title
        articles[indexPath.row].articleDescription = article.articleDescription
        articles[indexPath.row].image = article.image
        
        self.tableView.reloadData()
        
        print("Updated ")
    }
    
}

////////////////////
// DELEGAGE  ///////
////////////////////
extension ArticleListViewController : ArticlePresenterDelegate{
    
    func setStartLoading() {
        emptyView?.isHidden = false
        tableView.isHidden = false
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
    func setFinishLoading() {
        self.refreshControl?.endRefreshing()
        tableView.isHidden = false
        emptyView?.isHidden = true
        activityIndicator?.stopAnimating()
    }
    
    func setArticleList(_ articles: Array<Article>) {
        if articles.count > 0 {
            self.articles = []
        }
        self.articles.append(contentsOf: articles)
        tableView.reloadData()
    }
    
    func setEmptyView() {
        tableView.isHidden = true
        emptyView?.isHidden = false
    }
    
    func reloadArticleListTable() {
        tableView.reloadData()
    }
    /** Create     **/
    func setCreateCompleted(_ article: Article) {
        self.articles.insert(article, at: 0)
        tableView.reloadData()
    }
    
    /** pagination **/
    func updateArticleList(_ articles: Array<Article>) {
        self.articles.append(contentsOf: articles)
        print("Appended \(self.articles.count)")
        tableView.reloadData()
    }
    
    /** delete **/
    func setDeleteFailed(_ index:Int) {
        
    }
    
    func setDeleteCompleted(atIndexPath indextPath : IndexPath) {
       print(indextPath.row)
       articles.remove(at: indextPath.row)
        //self.tableView.deleteRows(at: [indextPath], with: .fade)
        self.tableView.reloadData()
    }
    
    // loading
    func startLoading() {
        
    }
    
    func finishLoading() {
        
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
        cell.configuration(articles[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= articles.count - 1 {
           // articlePresenter?.getArticle(PAGE_NUMBER , NUMBER_OF_REROCE)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        print("Footer")
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
            self.articlePresenter?.deleteArticle(aritcleId: self.articles[indexPath.row].id!, atIndexPath: indexPath)
        });
        let EditRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{
            action, indexpath in
            
            let articleDetailViewController = ArticleDetailViewController(nibName: nil, bundle: nil)
            articleDetailViewController.articleToUpdate = self.articles[indexPath.row]
            
            articleDetailViewController.artileListViewController = self
            
            articleDetailViewController.indexPathToUpdate = indexPath
            
            _ = self.navigationController?.pushViewController( articleDetailViewController, animated: true)
            
        });
        deleteRowAction.backgroundColor = UIColor.brown
        return [deleteRowAction,EditRowAction]
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        print("Footer add")
        print(section)
        if section == 1{
            print("Sec 1")
            let tableViewHeader = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 40))
            tableViewHeader.backgroundColor = UIColor.blue
            
            return tableViewHeader
        }
        return nil
    }
    
    override func tableView( _ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
}

