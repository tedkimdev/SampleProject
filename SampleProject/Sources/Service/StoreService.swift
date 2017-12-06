//
//  StoreService.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire


protocol StoreServiceType {
  func stores(type: StoreType,
              nearBy locatin: CLLocation,
              offset: Int,
              completion: @escaping (ServiceResult<Businesses>) -> Void)
}


final class StoreService {
  
  // MARK: Constants
  
  fileprivate static let accessToken = "ydXtyZydGlvazj5POGRZG2sRxdLE08dPooRMMMH4f6eYXY9yFCygoVcYGbUvdfQmBYoWLoE_X2KWbs5mf5K8_gURgdWJlO6mS0mfecA35O0dPmNGMeK1KgkKycgmWnYx"
  
  fileprivate static let baseURL = URL(string: "https://api.yelp.com/v3/businesses/search")!
}


// MARK: - StoreServiceType

extension StoreService : StoreServiceType {
  
  func stores(type: StoreType,
              nearBy location: CLLocation,
              offset: Int,
              completion: @escaping (ServiceResult<Businesses>) -> Void)
  {
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(StoreService.accessToken)",
    ]

    let parameters: Parameters = [
      "term": type.rawValue,
      "latitude": location.coordinate.latitude,
      "longitude": location.coordinate.longitude,
      "sort_by": SortType.distance,
      "offset": offset,
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
