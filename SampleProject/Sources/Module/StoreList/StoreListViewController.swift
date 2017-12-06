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
  private var isLoading: Bool = false
  
  
  // MARK: UI
  
  @IBOutlet weak var tableView: UITableView!
  private let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
  }
  
  override func setupUI() {
    self.title = self.navigationController?.tabBarItem.title
    
    self.tableView.refreshControl = UIRefreshControl()
    
    self.indicatorView.layer.cornerRadius = self.indicatorView.bounds.width / 2
    self.indicatorView.backgroundColor = .black
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
    guard !self.isLoading else { return }
    self.isLoading = true
    self.indicatorView.startAnimating()
  }
  
  func stopLoading() {
    self.isLoading = false
    self.indicatorView.stopAnimating()
    self.tableView.refreshControl?.endRefreshing()
    tableView.reloadData()
  }
  
}


// MARK: - UITableViewDelegate

extension StoreListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    tableView.beginUpdates()
    tableView.reloadRows(at: [indexPath], with: .none)
    tableView.endUpdates()
    self.presenter.didSelectTableViewRowAt(indexPath: indexPath)
  }
  
  // MARK: ScrollView
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard !self.isLoading else { return }
    
    let scrollBottom = scrollView.contentOffset.y + scrollView.bounds.height
    let scrollHeight = scrollView.contentSize.height
    
    if scrollBottom >= (scrollHeight - 200) && scrollView.contentSize.height > 0 {
      self.startLoading()
      self.presenter.loadNextData()
    }
    
  }
  
}


// MARK: - UITableViewDataSource

extension StoreListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.presenter.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell", for: indexPath) as! StoreListCell
    self.presenter.configureCell(cell, at: indexPath)
    return cell
  }
  
}
