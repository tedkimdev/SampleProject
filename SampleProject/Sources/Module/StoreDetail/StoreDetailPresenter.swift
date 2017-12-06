//
//  StoreDetailPresenter.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import Foundation


// MARK: - Protocol

protocol StoreDetailPresenterType: class, PresenterType {
  weak var view: StoreDetailViewType? { get set }
  
  // CollectionView
  func numberOfRows(in section: Int) -> Int
  func configureCell(_ cell: StoreDetailCellType, at indexPath: IndexPath)
}


// MARK: - Class Implementation

final class StoreDetailPresenter {
  
  // MARK: Properties
  
  weak var view: StoreDetailViewType?
  private var business: Business?
  
  
  // MARK: Initializing
  
  init(business: Business?) {
    self.business = business
  }
  
  func onViewDidLoad() {
    view?.setTitle(title: business?.name ?? "")
  }
  
}


// MARK: - StoreDetailPresenterType

extension StoreDetailPresenter: StoreDetailPresenterType {
  
  func numberOfRows(in section: Int) -> Int {
    return business != nil ? 1 : 0
  }
  
  func configureCell(_ cell: StoreDetailCellType, at indexPath: IndexPath) {
    guard let business = business else { return }
    cell.configure(model: business)
  }
  
}
