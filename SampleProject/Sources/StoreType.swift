//
//  StoreType.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

enum StoreType: String {
  case none = ""
  case restaurant = "Restaurant"
  case groceryStores = "Grocery Store"
}

enum SortType: String {
  case bestMatch = "best_match"
  case rating = "rating"
  case reviewCount = "review_count"
  case distance = "distance"
  
  /// The total number of business Yelp finds based on the search criteria. Sometimes, the value may exceed 1000. In such case, you still can only get up to 1000 businesses. total may be limited to 40 for non-default sorts such as "distance" and "review_count".
  var total: Int {
    get {
      switch self {
      case .distance, .reviewCount:
        return 40
        
      default:
        return 1000
      }
    }
  }
  
}
