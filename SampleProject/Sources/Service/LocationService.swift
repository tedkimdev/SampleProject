//
//  LocationService.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import CoreLocation
import Foundation


// MARK: - Protocol

protocol LocationServiceDelegate {
  func getLocation(currentLocation: CLLocation)
  func getLocationDidFailWithError(error: Error)
}


// MARK: - Class Implementation

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
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.delegate = self
  }
  
  func requestLocation() {
    shouldSetRegion = true
    lastLocation = nil
    
    locationManager.requestLocation()
  }
  
  private func updateLocation(currentLocation: CLLocation){
    delegate?.getLocation(currentLocation: currentLocation)
  }
  
  private func updateLocationDidFailWithError(error: Error) {
    delegate?.getLocationDidFailWithError(error: error)
  }
  
}


// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.first,
      shouldSetRegion else { return }
  
    shouldSetRegion = false
    lastLocation = currentLocation
    updateLocation(currentLocation: currentLocation)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    updateLocationDidFailWithError(error: error)
  }
  
}
