//
//  StoreDetailCell.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit


// MARK: - Protocols

protocol StoreDetailCellType {
  func configure(model: Business)
}


protocol StoreDetailCellDelegate: class {
  func showReservationPage(by urlString: String?)
}


// MARK: - Class Implementation

final class StoreDetailCell: UICollectionViewCell, StoreDetailCellType {
  
  // MARK: Properties
  
  private var reservationURL: String?
  weak var delegate: StoreDetailCellDelegate?
  
  
  // MARK: UI
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var locatinLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var reviewCountLabel: UILabel!
  @IBOutlet weak var isOpenLabel: UILabel!
  @IBOutlet weak var starRatingView: StarRatingView!
  
  
  // MARK: Layout
  
  override func layoutIfNeeded() {
    super.layoutIfNeeded()
    
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = self.imageView.frame.width / 2
    imageView.layer.masksToBounds = true
  }
  
  
  // MARK: Configuring
  
  func configure(model: Business) {
    if !model.imageURL.isEmpty {
      imageView.kf.setImage(with: URL(string: model.imageURL))
    }
    reservationURL = "https://www.yelp.com/reservations/\(model.id)"
    locatinLabel.text = model.location
    phoneLabel.text = model.displayPhone
    starRatingView.rating = model.rating
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    let numberString = formatter.string(from: NSNumber(integerLiteral: model.reviewCount))!
    reviewCountLabel.text = self.reviewCountLabel.text! + "\(numberString)"
    
    if model.isClosed {
      isOpenLabel.text = self.isOpenLabel.text! + "No"
    } else {
      isOpenLabel.text = self.isOpenLabel.text! + "Yes"
    }
    
    layoutIfNeeded()
  }
  
  
  // MARK: Action
  
  @IBAction func reservationButtonDidTap(_ sender: Any) {
    delegate?.showReservationPage(by: self.reservationURL)
  }
  
}
