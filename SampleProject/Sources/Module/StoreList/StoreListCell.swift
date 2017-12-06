//
//  StoreListCell.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit

protocol StoreListCellType {
  func configure(viewModel: StoreListCellViewModel)
}

final class StoreListCell: UITableViewCell, StoreListCellType {
  
  // MARK: UI
  
  @IBOutlet weak var photoView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  
  @IBOutlet weak var locationHeight: NSLayoutConstraint!
  
  // MARK: Initializing
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  // MARK: Layout
  
  override func layoutIfNeeded() {
    super.layoutIfNeeded()
    
    self.photoView.contentMode = .scaleAspectFill
    self.photoView.layer.cornerRadius = self.photoView.frame.width / 2
    self.photoView.layer.masksToBounds = true
  }
  
  
  // MARK: Configuring
  
  func configure(viewModel: StoreListCellViewModel) {
    if !viewModel.imageURL.isEmpty {
      self.photoView.kf.setImage(with: URL(string: viewModel.imageURL))
    }
    
    self.nameLabel?.text = viewModel.name
    self.locationLabel?.text = viewModel.location
    self.phoneLabel?.text = viewModel.displayPhone
    
    self.layoutIfNeeded()
  }
  
}
