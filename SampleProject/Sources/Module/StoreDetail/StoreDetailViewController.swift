//
//  StoreDetailViewController.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import SafariServices
import UIKit


// MARK: - Protocol

protocol StoreDetailViewType: ViewType {
  func setTitle(title: String)
}


// MARK: - Class Implementation

final class StoreDetailViewController: BaseViewController {
  
  // MARK: Constants
  
  fileprivate struct Metric {
    static let navigationBarHeight: CGFloat = 40.0
  }
  
  
  // MARK: Properties
  
  private var presenter: StoreDetailPresenterType
  
  
  // MARK: UI
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  
  // MARK: Initializing
  
  init(presenter: StoreDetailPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    self.presenter.view = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.presenter = StoreDetailPresenter(business: nil)
    super.init(coder: aDecoder)
    self.presenter.view = self
  }
  
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter.onViewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  
  // MARK: Class Function
  
  class func createFromStoryboard(presenter: StoreDetailPresenterType) -> StoreDetailViewController {
    let viewController = UIStoryboard(name: "StoreDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
    viewController.bindingPresenter(presenter: presenter)
    return viewController
  }
  
  fileprivate func bindingPresenter(presenter: StoreDetailPresenterType) {
    self.presenter = presenter
    self.presenter.view = self
  }
 
  override func setupUI() {
  }
  
  override func setupBinding() {
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
  
}


// MARK: - StoreDetailViewType

extension StoreDetailViewController: StoreDetailViewType {
  
  func setTitle(title: String) {
    self.title = title
  }
  
}


// MARK: - UICollectionViewDelegateFlowLayout

extension StoreDetailViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = UIScreen.main.bounds.height - Metric.navigationBarHeight
    return CGSize(width: UIScreen.main.bounds.width, height: height)
  }
  
}


// MARK: - UICollectionViewDataSource

extension StoreDetailViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.presenter.numberOfRows(in: section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreDetailCell", for: indexPath) as! StoreDetailCell
    cell.delegate = self
    self.presenter.configureCell(cell, at: indexPath)
    return cell
  }
  
}


// MARK: - StoreDetailCellDelegate

extension StoreDetailViewController: StoreDetailCellDelegate {
  
  func showReservationPage(by urlString: String?) {
    guard let urlString = urlString else { return }
    let safariViewController = SFSafariViewController(url: URL(string: urlString)!)
    self.present(safariViewController, animated: true, completion: nil)
  }
  
}
