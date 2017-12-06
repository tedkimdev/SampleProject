//
//  AccessInformation.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 6..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import Foundation


struct AccessInformation: Decodable {
  
  let accessToken: String
  let tokenType: String
  let expiresIn: TimeInterval
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case expiresIn = "expires_in"
  }
  
}
