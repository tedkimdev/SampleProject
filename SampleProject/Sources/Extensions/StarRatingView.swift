//
//  StarRatingView.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 6..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit


@IBDesignable
final class StarRatingView: UIStackView {
  
  // MARK: Properties
  
  private var starViews = [UIImageView]()
  
  @IBInspectable var starSize: CGSize = CGSize(width: 36.0, height: 36.0) {
    didSet {
      self.setupStarViews()
    }
  }
  
  @IBInspectable var starCount: Int = 5 {
    didSet {
      self.setupStarViews()
    }
  }
  
  var rating: Float = 0 {
    didSet {
      self.setupStarViews()
    }
  }
  
  
  // MARK: Initializing
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupStarViews()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    self.setupStarViews()
  }
  
  private func setupStarViews() {
    self.removeStarViews()
    
    // load images
    let bundle = Bundle(for: type(of: self))
    let filledStarImage = UIImage(named: "icon-star-filled", in: bundle, compatibleWith: self.traitCollection)
    let emptyStarImage = UIImage(named: "icon-star-empty", in: bundle, compatibleWith: self.traitCollection)
    let halfStarImage = UIImage(named: "icon-star-half", in: bundle, compatibleWith: self.traitCollection)
    
    var rating = self.rating
    for _ in 0..<self.starCount {
      let imageView = UIImageView()
      
      if rating > 1 {
        imageView.image = filledStarImage
      } else if rating >= 0.75 {
        imageView.image = filledStarImage
      } else if rating >= 0.25 {
        imageView.image = halfStarImage
      } else {
        imageView.image = emptyStarImage
      }
      rating -= 1
      
      // Add constrainsts
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.heightAnchor.constraint(equalToConstant: self.starSize.height).isActive = true
      imageView.widthAnchor.constraint(equalToConstant: self.starSize.width).isActive = true
      
      self.addArrangedSubview(imageView)
      self.starViews.append(imageView)
    }
  }
  
  private func removeStarViews() {
    for view in self.starViews {
      self.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
    self.starViews.removeAll()
  }

}
