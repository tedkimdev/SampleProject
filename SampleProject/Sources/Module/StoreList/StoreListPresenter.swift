//
//  StoreListPresenter.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import CoreLocation
import Foundation


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
    guard let title = view?.getViewTitle() else { return }
    storeType = StoreType(rawValue: title) ?? StoreType.none
    
    let status = CLLocationManager.authorizationStatus()
    if status == .denied || status == .restricted {
      view?.openSettingsAlert(
        title: "Location Services Disabled",
        message: "Please enable Location Services in Settings."
      )
    }
    
    authorize()
  }
  
  
  // MARK: Action
  
  private func authorize() {
    storeService.authorize { [weak self] result in
      guard let `self` = self else { return }
      
      switch result {
      case .success:
        self.reloadData()
        
      case .failure(let error):
        DispatchQueue.main.async {
          self.view?.presentAlert(title: "Autorization Error", message: error.localizedDescription)
        }
      }
    }
  }
  
  private func requestStoreList(isRefresh: Bool = false) {
    guard let location = currentLocation,
      !isRefresh && businesses.count < SortType.distance.total || isRefresh else {
        view?.stopLoading(shouldReload: false)
        return
      }
    
    if businesses.isEmpty {
      view?.startLoading()
    }
    
    storeService.stores(
      type: storeType,
      nearBy: location,
      offset: isRefresh ? 0 : businesses.count
    ) { [weak self] result in
      guard let `self` = self else { return }
      
      DispatchQueue.main.async {
        switch result {
        case .success(let businesses):
          if isRefresh {
            self.businesses = businesses.items
          } else {
            self.businesses.append(contentsOf: businesses.items)
          }
          self.view?.stopLoading(shouldReload: true)
          
        case .failure(let error):
          self.view?.presentAlert(title: "Networking Error", message: error.localizedDescription)
          self.view?.stopLoading(shouldReload: false)
        }
        
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
    requestStoreList()
  }
  
  // TableView
  
  func didSelectTableViewRowAt(indexPath: IndexPath) {
    let presenter = StoreDetailPresenter(business: businesses[indexPath.row])
    let viewController = StoreDetailViewController.createFromStoryboard(presenter: presenter)
    view?.show(viewController, animated: true)
  }
  
  func numberOfRows(in section: Int) -> Int {
    return businesses.count
  }
  
  func configureCell(_ cell: StoreListCellType, at indexPath: IndexPath) {
    let viewModel = StoreListCellViewModel(model: businesses[indexPath.row])
    cell.configure(viewModel: viewModel)
  }
  
}


// MARK: - LocationServiceDelegate

extension StoreListPresenter: LocationServiceDelegate {
  
  func getLocation(currentLocation: CLLocation) {
    self.currentLocation = currentLocation
    requestStoreList(isRefresh: true)
  }

  func getLocationDidFailWithError(error: Error) {
    let status = CLLocationManager.authorizationStatus()
    
    DispatchQueue.main.async { [weak self] in
      guard let `self` = self else { return }
      
      if status == .denied || status == .restricted {
        self.view?.openSettingsAlert(
          title: "Location Access Denied",
          message: "Please enable Location Services in Settings."
        )
      } else {
        self.view?.presentAlert(
          title: "Location Error",
          message: error.localizedDescription
        )
      }
    }
    
  }
  
}

