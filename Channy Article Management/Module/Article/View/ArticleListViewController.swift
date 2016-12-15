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
    var articleListPresenter:ArticleListPresenter?
    // page number
    fileprivate var page:Int?
    fileprivate let numberOfRow:Int = 10
    
    // empty View and activity indicator
    var emptyView:UIView?
    var activityIndicator:UIActivityIndicatorView?
    
    override init(nibName name: String?, bundle: Bundle?) {
        super.init(nibName: name, bundle: bundle)

        navigationItem.title = "Article"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ArticleListViewController.addArticlePressed))
        
        // make the empty view become full screen
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
        
        articleListPresenter = ArticleListPresenter()
        articleListPresenter?.attachToDelegate = self
        page = 1
        articleListPresenter?.getArticle(page!, numberOfRow)
        
    }
    
    func addArticlePressed(){
        navigationController?.pushViewController(AddArticleViewController(nibName: nil, bundle: nil), animated: true)
    }
}

////////////////////
// DELEGAGE  ///////
////////////////////

extension ArticleListViewController:ArticleListPresenterDelegate{
    
    func setStartLoading() {
        // make activity spinning
        tableView.isHidden = false
        emptyView?.isHidden = false
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
    func setFinishLoading() {
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
    
    /** pagination **/
    func updateArticleList(_ articles: Array<Article>) {
        self.articles.append(contentsOf: articles)
        print("Appended \(self.articles.count)")
        tableView.reloadData()
    }
    
    /** delete **/
    func setDeleteFailed(_ index:Int) {
        
    }
    
    func setDeleteCompleted(_ index : Int) {
        articles.remove(at: index)
        tableView.reloadData()
    }
    
    // Update
    func setUpdateFailed() {
        
    }
    
    func setUpdateCompleted() {
        
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
        cell.titleLabel.text = articles[indexPath.row].title
        cell.descriptionLabel.text = articles[indexPath.row].articleDescription
        
        if indexPath.row == articles.count - 1{
            articleListPresenter?.getArticle(page! , numberOfRow)
        }
        return cell
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
            self.articleListPresenter?.deleteArticle(aritcleId: self.articles[indexPath.row].id!, index: indexPath.row)
        });
        let EditRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{
            action, indexpath in
            
        });
        deleteRowAction.backgroundColor = UIColor.brown
        return [deleteRowAction,EditRowAction]
    }
}

