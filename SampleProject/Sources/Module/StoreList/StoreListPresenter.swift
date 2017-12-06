//
//  StoreListPresenter.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import Foundation
import CoreLocation


// MARK: - Protocol

protocol StoreListPresenterType: class, PresenterType {
  weak var view: StoreListViewType? { get set }
  
  func reloadData()
  func loadNextData()
  
  // TableView
  func didSelectTableViewRowAt(indexPath: IndexPath)
  func numberOfRows(in section: Int) -> Int
  func configureCell(_ cell: StoreListCellType, at indexPath: IndexPath)
}


// MARK: - Class Implementation

final class StoreListPresenter {
  
  // MARK: Properties
  
  weak var view: StoreListViewType?
  
  private var storeType: StoreType
  private var currentLocation: CLLocation?
  private var businesses = [Business]()
  private let storeService: StoreServiceType
  
  
  // MARK: Initializing
  
  init(service: StoreServiceType = StoreService()) {
    self.storeType = StoreType.none
    self.storeService = service
  }
  
  func onViewDidLoad() {
    guard let title = self.view?.getViewTitle() else { return }
    self.storeType = StoreType(rawValue: title) ?? StoreType.none
    
    self.reloadData()
  }
  
  
  // MARK: Action
  
  private func requestStoreList(isRefresh: Bool = false) {
    guard let location = self.currentLocation else { return }
    
    if !isRefresh {
      self.view?.startLoading()
    }
    
    self.storeService.stores(type: self.storeType,
                             nearBy: location,
                             offset: isRefresh ? 0 : self.businesses.count){ [weak self] result in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let businesses):
          if self.businesses.count == 0 {
            self.businesses = businesses.items
          } else {
            self.businesses.append(contentsOf: businesses.items)
          }
          
        case .failure(let error):
          self.view?.presentAlert(title: "Networking Error", message: error.localizedDescription)
        }
        self.view?.stopLoading()
      }
    }
  }
  
}


// MARK: - StoreListPresenterType

extension StoreListPresenter: StoreListPresenterType {
  
  func reloadData() {
    LocationService.shared.authorize()
    LocationService.shared.requestLocation()
    LocationService.shared.delegate = self
  }
  
  func loadNextData() {
    self.requestStoreList()
  }
  
  // TableView
  
  func didSelectTableViewRowAt(indexPath: IndexPath) {
    let presenter = StoreDetailPresenter(business: self.businesses[indexPath.row])
    let viewController = StoreDetailViewController.createFromStoryboard(presenter: presenter)
    self.view?.show(viewController, animated: true)
  }
  
  func numberOfRows(in section: Int) -> Int {
    return self.businesses.count
  }
  
  func configureCell(_ cell: StoreListCellType, at indexPath: IndexPath) {
    let viewModel = StoreListCellViewModel(model: self.businesses[indexPath.row])
    cell.configure(viewModel: viewModel)
  }
  
}


// MARK: - LocationServiceDelegate

extension StoreListPresenter: LocationServiceDelegate {
  func getLocation(currentLocation: CLLocation) {
    self.currentLocation = currentLocation
    self.requestStoreList(isRefresh: true)
  }

  func getLocationDidFailWithError(error: Error) {
    self.view?.presentAlert(title: "Location Error", message: error.localizedDescription)
  }
}

