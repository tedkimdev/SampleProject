//
//  StoreListCell.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit


// MARK: - Protocol

protocol StoreListCellType {
  func configure(viewModel: StoreListCellViewModel)
}


// MARK: - Class Implementation

final class StoreListCell: UITableViewCell, StoreListCellType {
  
  // MARK: UI
  
  @IBOutlet weak var photoView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  
  override func awakeFromNib() {
    setupUI()
  }
  
  private func setupUI() {
    photoView.contentMode = .scaleAspectFill
    photoView.layer.cornerRadius = self.photoView.frame.width / 2
    photoView.layer.masksToBounds = true
  }
  
  
  // MARK: Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    locationLabel.sizeToFit()
    locationLabel.baselineAdjustment = .alignCenters
  }

  
  // MARK: Configuring
  
  func configure(viewModel: StoreListCellViewModel) {
    
    if !viewModel.imageURL.isEmpty {
      photoView.kf.setImage(with: URL(string: viewModel.imageURL))
    }
    
    nameLabel?.text = viewModel.name
    locationLabel?.text = viewModel.location
    locationLabel.baselineAdjustment = .alignCenters
    
    if !viewModel.displayPhone.isEmpty {
      phoneLabel?.text = viewModel.displayPhone
    }
    
    setNeedsLayout()
  }
  
}
