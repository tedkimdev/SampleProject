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
  func openSettingsAlert(title: String, message: String)
  
  // Navigation
  func show(_ viewController: UIViewController, animated: Bool)
  
  // Loading
  func startLoading()
  func stopLoading(shouldReload: Bool)
}


// MARK: - Class Implementation

final class StoreListViewController: BaseViewController {
  
  // MARK: Properties
  
  private var presenter: StoreListPresenterType
  private var isLoading = false
  
  
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
    presenter.onViewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = false
  }
  
  override func setupUI() {
    title = navigationController?.tabBarItem.title
    
    tableView.refreshControl = UIRefreshControl()
    
    indicatorView.layer.cornerRadius = self.indicatorView.bounds.width / 4
    indicatorView.backgroundColor = .black
    indicatorView.center = self.view.center
    
    view.addSubview(self.indicatorView)
  }
  
  override func setupBinding() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.refreshControl?.addTarget(
      self,
      action: #selector(didPullToRefresh),
      for: .valueChanged
    )
  }
  
  
  // MARK: Target Action
  
  @objc func didPullToRefresh() {
    presenter.reloadData()
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
    
    let reloadAction = UIAlertAction(title: "Reload", style: .default) { _ in
      self.didPullToRefresh()
    }
    alertController.addAction(reloadAction)
    
    present(alertController, animated: true)
  }
  
  func openSettingsAlert(title: String, message: String) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    let openAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
      if let url = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.open(url, options: [:])
      }
    }
    alertController.addAction(openAction)
    
    present(alertController, animated: true) {
      self.stopLoading(shouldReload: true)
    }
  }
  
  // Navigation
  
  func show(_ viewController: UIViewController, animated: Bool) {
    navigationController?.pushViewController(viewController, animated: true)
  }

  // Networking
  
  func startLoading() {
    guard !isLoading else { return }
    isLoading = true
    indicatorView.startAnimating()
  }
  
  func stopLoading(shouldReload: Bool) {
    isLoading = false
    indicatorView.stopAnimating()
    tableView.refreshControl?.endRefreshing()
    
    if shouldReload {
      tableView.reloadData()
    }
  }
  
}


// MARK: - UITableViewDelegate

extension StoreListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    tableView.beginUpdates()
    tableView.reloadRows(at: [indexPath], with: .none)
    tableView.endUpdates()
    presenter.didSelectTableViewRowAt(indexPath: indexPath)
  }
  
  // MARK: ScrollView
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard !isLoading else { return }
    
    let scrollBottom = scrollView.contentOffset.y + scrollView.bounds.height
    let scrollHeight = scrollView.contentSize.height
    
    if scrollBottom >= (scrollHeight - 200) && scrollView.contentSize.height > 0 {
      startLoading()
      presenter.loadNextData()
    }
    
  }
  
}


// MARK: - UITableViewDataSource

extension StoreListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell", for: indexPath) as! StoreListCell
    presenter.configureCell(cell, at: indexPath)
    return cell
  }
  
}
