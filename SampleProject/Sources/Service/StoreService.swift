//
//  StoreService.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import CoreLocation
import Foundation

import Alamofire


// MARK: - Protocol

protocol StoreServiceType {
  
  func authorize(completion: @escaping (ServiceResult<Void>) -> Void)
  
  func stores(
    type: StoreType,
    nearBy locatin: CLLocation,
    offset: Int,
    completion: @escaping (ServiceResult<Businesses>) -> Void
  )
  
}


// MARK: - Class Implementation

final class StoreService {
  
  // MARK: Constants
  
  private static let clientID = "h23U_DN17pdA7Q9yvWgHUg"
  private static let clientSecret = "UfjdkNQYS8DB9r6P2mq0ovpa2C53CM0RX7SrVX9CD1OEgpD4DKv7iSMs6FZ1SsBk"
  private static let baseURL = URL(string: "https://api.yelp.com/v3/businesses/search")!
  private static let authURL = URL(string: "https://api.yelp.com/oauth2/token")!
  
  
  // MARK: Properties
  
  private var accessToken = ""
  private var tokenType = ""
  
}


// MARK: - StoreServiceType

extension StoreService : StoreServiceType {
  
  func authorize(completion: @escaping (ServiceResult<Void>) -> Void) {
    let parameters: Parameters = [
      "client_id": StoreService.clientID,
      "client_secret": StoreService.clientSecret,
    ]
    
    Alamofire.request(StoreService.authURL, method: .post, parameters: parameters)
      .validate(statusCode: 200..<400)
      .responseJSON { [weak self] response in
        guard let `self` = self else { return }
        
        switch response.result {
        case .success:
          do {
            if let data = response.data {
              let accessInfomation = try JSONDecoder().decode(AccessInformation.self, from: data)
              self.accessToken = accessInfomation.accessToken
              self.tokenType = accessInfomation.tokenType
              
              let result = ServiceResult.success(())
              completion(result)
            }
          } catch {
            completion(ServiceResult.failure(ServiceError.JSONParsingError))
          }
          
        case .failure(let error):
          completion(ServiceResult.failure(error))
        }
    }
  }
  
  func stores(
    type: StoreType,
    nearBy location: CLLocation,
    offset: Int,
    completion: @escaping (ServiceResult<Businesses>) -> Void
  ) {
    let headers: HTTPHeaders = [
      "Authorization": "\(tokenType) \(accessToken)",
    ]

    let parameters: Parameters = [
      "term": type.rawValue,
      "latitude": location.coordinate.latitude,
      "longitude": location.coordinate.longitude,
      "sort_by": SortType.distance,
      "offset": offset,
      "limit": 20,
    ]
    
    Alamofire.request(StoreService.baseURL, method: .get, parameters: parameters, headers: headers)
      .validate(statusCode: 200..<400)
      .responseJSON { response in
        switch response.result {
        case .success:
          do {
            if let data = response.data {
              let businesses = try JSONDecoder().decode(Businesses.self, from: data)
              completion(ServiceResult.success(businesses))
            }
          } catch {
            completion(ServiceResult.failure(ServiceError.JSONParsingError))
          }
          
        case .failure(let error):
          completion(ServiceResult.failure(error))
        }
      }
  }
  
}
