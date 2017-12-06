//
//  StoreDetailViewController.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit


// MARK: - Protocol

protocol StoreDetailViewType: ViewType {
  func setTitle(title: String)
}


// MARK: - Class Implementation

final class StoreDetailViewController: BaseViewController {
  
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
    print("setupUI")
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
  
}


// MARK: - UICollectionViewDataSource

extension StoreDetailViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.presenter.numberOfRows(in: section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreDetailCell", for: indexPath) as! StoreDetailCell
    self.presenter.configureCell(cell, at: indexPath)
    return cell
  }
  
}
