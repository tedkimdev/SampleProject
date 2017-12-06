//
//  StoreListCell.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit

protocol StoreListCellType {
  func configure()
}

final class StoreListCell: UITableViewCell, StoreListCellType {
  
  // MARK: Initializing
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  // MARK: Configuring
  
  func configure() {
    self.backgroundColor = .green
  }
}
