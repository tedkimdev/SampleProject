//
//  StoreListViewController.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit


// MARK: - Protocol

protocol StoreListViewType: ViewType {
  func getViewTitle() -> String
  
  func presentAlert(title: String, message: String)
  
  // Navigation
  func show(_ viewController: UIViewController, animated: Bool)
  
  // Loading
  func startLoading()
  func stopLoading()
}


// MARK: - Class Implementation

final class StoreListViewController: BaseViewController {
  
  // MARK: Properties
  
  private var presenter: StoreListPresenterType
  
  
  // MARK: UI
  
  @IBOutlet weak var tableView: UITableView!
  private let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  
  
  // MARK: Initializing
  
  init(presenter: StoreListPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    self.presenter.view = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.presenter = StoreListPresenter()
    super.init(coder: aDecoder)
    self.presenter.view = self
  }
  
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter.onViewDidLoad()
  }
  
  override func setupUI() {
    self.title = self.navigationController?.tabBarItem.title
    
    self.tableView.refreshControl = UIRefreshControl()
    
    self.indicatorView.center = self.view.center
    
    self.view.addSubview(self.indicatorView)
  }
  
  override func setupBinding() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
  }
  
  
  // MARK: Target Action
  
  @objc func didPullToRefresh() {
    self.presenter.reloadData()
  }
  
}


// MARK: - StoreListViewType

extension StoreListViewController: StoreListViewType {
  
  func getViewTitle() -> String {
    guard let title = self.title else { return "" }
    return title
  }
  
  // Alert
  
  func presentAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(action)
    self.present(alertController, animated: true, completion: nil)
  }
  
  // Navigation
  
  func show(_ viewController: UIViewController, animated: Bool) {
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  // Networking
  
  func startLoading() {
    if !self.tableView.refreshControl!.isRefreshing {
      self.indicatorView.startAnimating()
    }
  }
  
  func stopLoading() {
    self.indicatorView.stopAnimating()
    self.tableView.refreshControl?.endRefreshing()
    tableView.reloadData()
  }
  
}


// MARK: - UITableViewDelegate

extension StoreListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.presenter.didSelectTableViewRowAt(indexPath: indexPath)
  }
  
}


// MARK: - UITableViewDataSource

extension StoreListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.presenter.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell", for: indexPath) as! StoreListCell
    
    self.presenter.configureCell(cell)
    
    return cell
  }
  
}
