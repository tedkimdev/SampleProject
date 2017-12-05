//
//  BasePresenterType.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import Foundation


protocol PresenterType: class {
  func onViewDidLoad()
}


extension PresenterType {
  func onViewDidLoad() { }
}
