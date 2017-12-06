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
  
  @IBInspectable var starSize = CGSize(width: 30.0, height: 30.0) {
    didSet {
      setupStarViews()
    }
  }
  
  @IBInspectable var starCount = 5 {
    didSet {
      setupStarViews()
    }
  }
  
  var rating: Float = 0 {
    didSet {
      setupStarViews()
    }
  }
  
  
  // MARK: Initializing
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStarViews()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    setupStarViews()
  }
  
  private func setupStarViews() {
    removeStarViews()
    
    // load images
    let bundle = Bundle(for: type(of: self))
    let filledStarImage = UIImage(
      named: "icon-star-filled",
      in: bundle,
      compatibleWith: traitCollection
    )
    let emptyStarImage = UIImage(
      named: "icon-star-empty",
      in: bundle,
      compatibleWith: self.traitCollection
    )
    let halfStarImage = UIImage(
      named: "icon-star-half",
      in: bundle,
      compatibleWith: self.traitCollection
    )
    
    var rating = self.rating
    for _ in 0..<starCount {
      let imageView = UIImageView()
      
      if rating >= 0.75 {
        imageView.image = filledStarImage
      } else if rating >= 0.25 {
        imageView.image = halfStarImage
      } else {
        imageView.image = emptyStarImage
      }
      rating -= 1
      
      // Add constrainsts
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
      imageView.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
      
      addArrangedSubview(imageView)
      starViews.append(imageView)
    }
  }
  
  private func removeStarViews() {
    for view in self.starViews {
      removeArrangedSubview(view)
      view.removeFromSuperview()
    }
    starViews.removeAll()
  }

}
