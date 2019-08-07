//
//  FilterTableViewController.swift
//  Home Report
//
//  Created by Andi Setiyadi on 6/8/18.
//  Copyright © 2018 devhubs. All rights reserved.
//

import UIKit

protocol FilterTableViewControllerDelegate: class {
    func updateHomeList(filterby: NSPredicate?, sortby: NSSortDescriptor?)
}

class FilterTableViewController: UITableViewController {

    // SORT BY
    @IBOutlet weak var sortByLocationCell: UITableViewCell!
    @IBOutlet weak var sortByPriceLowHighCell: UITableViewCell!
    @IBOutlet weak var sortByPriceHighLowCell: UITableViewCell!
    
    // FILTER by home type
    @IBOutlet weak var filterByCondoCell: UITableViewCell!
    @IBOutlet weak var filterBySingleFamilyCell: UITableViewCell!
  
  private var sortDescripter: NSSortDescriptor?
  private var searchFilter : NSPredicate?
  
  var delegate: FilterTableViewControllerDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 2
    }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let selectedCell = tableView.cellForRow(at: indexPath) {
      switch selectedCell {
      case sortByLocationCell:
        sortDiscripter(sortBy: "city", isAscending: true)
      case sortByPriceHighLowCell:
        sortDiscripter(sortBy: "price", isAscending: false)
      case sortByPriceLowHighCell:
        sortDiscripter(sortBy: "price", isAscending: true)
      case filterByCondoCell,filterBySingleFamilyCell:
        setFilerPredicate(filterBy: (selectedCell.textLabel?.text)!)
      default:
        break
      }
      selectedCell.accessoryType = .checkmark
      delegate?.updateHomeList(filterby: searchFilter, sortby: sortDescripter)
    }
  }
  
  private func sortDiscripter(sortBy: String,isAscending: Bool) {
     sortDescripter = NSSortDescriptor(key: sortBy, ascending: isAscending)
  }
  private func setFilerPredicate(filterBy: String) {
    searchFilter = NSPredicate(format: "homeType = %@", filterBy)
  }
}
