//
//  StoreDetailCell.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit


protocol StoreDetailCellType {
  func configure(model: Business)
}


protocol StoreDetailCellDelegate: class {
  func showReservationPage(by urlString: String?)
}


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
  
  
  // MARK: Initializing
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  // MARK: Layout
  
  override func layoutIfNeeded() {
    super.layoutIfNeeded()
    
    self.imageView.contentMode = .scaleAspectFill
    self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
    self.imageView.layer.masksToBounds = true
  }
  
  
  // MARK: Configuring
  
  func configure(model: Business) {
    if !model.imageURL.isEmpty {
      self.imageView.kf.setImage(with: URL(string: model.imageURL))
    }
    self.reservationURL = "https://www.yelp.com/reservations/\(model.id)"
    self.locatinLabel.text = model.location
    self.phoneLabel.text = model.displayPhone
    self.starRatingView.rating = model.rating
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    let numberString = formatter.string(from: NSNumber(integerLiteral: model.reviewCount))!
    self.reviewCountLabel.text = self.reviewCountLabel.text! + "\(numberString)"
    
    if model.isClosed {
      self.isOpenLabel.text = self.isOpenLabel.text! + "No"
    } else {
      self.isOpenLabel.text = self.isOpenLabel.text! + "Yes"
    }
    
    self.layoutIfNeeded()
  }
  
  
  // MARK: Action
  
  @IBAction func reservationButtonDidTap(_ sender: Any) {
    self.delegate?.showReservationPage(by: self.reservationURL)
  }
  
}
