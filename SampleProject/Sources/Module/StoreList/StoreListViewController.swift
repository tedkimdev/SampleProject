//
//  StoreListViewController.swift
//  SampleProject
//
//  Created by aney on 2017. 12. 5..
//  Copyright © 2017년 Ted Kim. All rights reserved.
//

import UIKit

final class StoreListViewController: UIViewController {
  
  // MARK: Constants
  
  
  // MARK: Properties
  
  
  // MARK: UI
  
  @IBOutlet weak var tableView: UITableView!
  
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }
  
}


// MARK: - UITableViewDelegate

extension StoreListViewController: UITableViewDelegate {
  
}


// MARK: - UITableViewDataSource

extension StoreListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell", for: indexPath)
    cell.backgroundColor = .blue
    
    return cell
  }
  
}
