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
  
  // TableView
  func didSelectTableViewRowAt(indexPath: IndexPath)
  func numberOfRows(in section: Int) -> Int
  func configureCell(_ cell: StoreListCellType)
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
  
  private func requestStoreList() {
    guard let location = self.currentLocation else { return }
    
    self.view?.startLoading()
    self.storeService.stores(type: self.storeType, nearBy: location) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let businesses):
          self.businesses = businesses.items
          
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
  
  // TableView
  
  func didSelectTableViewRowAt(indexPath: IndexPath) {
    print("didSelectTableViewRowAt")
  }
  
  func numberOfRows(in section: Int) -> Int {
    return 5
  }
  
  func configureCell(_ cell: StoreListCellType) {
    cell.configure()
  }
}


// MARK: - LocationServiceDelegate

extension StoreListPresenter: LocationServiceDelegate {
  func getLocation(currentLocation: CLLocation) {
    self.currentLocation = currentLocation
    self.requestStoreList()
  }

  func getLocationDidFailWithError(error: Error) {
    self.view?.presentAlert(title: "Location Error", message: error.localizedDescription)
  }
}

