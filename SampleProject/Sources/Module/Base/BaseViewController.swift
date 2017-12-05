//
//  BaseViewController.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit


protocol ViewType: class {
}


class BaseViewController: UIViewController {
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
    self.setupBinding()
  }
  
  func setupUI() {
    // Override
  }
  
  func setupBinding() {
    // Override
  }

}
