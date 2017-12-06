//
//  LocationService.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationServiceDelegate {
  func getLocation(currentLocation: CLLocation)
  func getLocationDidFailWithError(error: Error)
}


final class LocationService: NSObject {
  
  // MARK: Initializing
  
  private override init() {}
  static let shared = LocationService()
  
  
  // MARK: Properties
  
  let locationManager = CLLocationManager()
  var shouldSetRegion = true
  var lastLocation: CLLocation?
  var delegate: LocationServiceDelegate?
  
  
  // MARK: Functions
  
  func authorize() {
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.delegate = self
  }
  
  func requestLocation() {
    self.shouldSetRegion = true
    self.lastLocation = nil
    
    self.locationManager.requestLocation()
  }
  
  private func updateLocation(currentLocation: CLLocation){
    self.delegate?.getLocation(currentLocation: currentLocation)
  }
  
  private func updateLocationDidFailWithError(error: Error) {
    self.delegate?.getLocationDidFailWithError(error: error)
  }
  
}


// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.first,
      self.shouldSetRegion else { return }
  
    self.shouldSetRegion = false
    self.lastLocation = currentLocation
    self.updateLocation(currentLocation: currentLocation)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    self.updateLocationDidFailWithError(error: error)
  }
  
}
