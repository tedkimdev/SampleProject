//
//  StoreListCellViewModel.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import Foundation


struct StoreListCellViewModel {
  
  let id: String
  let name: String
  let location: String
  let displayPhone: String
  let imageURL: String
  
  init(model: Business) {
    self.id = model.id
    self.name = model.name + "(\(model.rating))"
    self.location = model.location
    self.displayPhone = model.displayPhone
    self.imageURL = model.imageURL
  }
  
}
