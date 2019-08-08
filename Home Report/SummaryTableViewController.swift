//
//  SummaryTableViewController.swift
//  Home Report
//
//  Created by Andi Setiyadi on 6/8/18.
//  Copyright © 2018 devhubs. All rights reserved.
//

import UIKit
import CoreData

class SummaryTableViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var totalSalesDollarLabel: UILabel!
    @IBOutlet weak var numCondoSoldLabel: UILabel!
    @IBOutlet weak var numSFSoldLabel: UILabel!
    @IBOutlet weak var minPriceHomeLabel: UILabel!
    @IBOutlet weak var maxPriceHomeLabel: UILabel!
    @IBOutlet weak var avgPriceCondoLabel: UILabel!
    @IBOutlet weak var avgPriceSFLabel: UILabel!
    
    
    // MARK: Properties
    private var home: Home?
    
    weak var managedObjectContext: NSManagedObjectContext! {
        didSet {
            return home = Home(context: managedObjectContext)
        }
    }
    
    private var soldPredicate: NSPredicate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      if let homeValue = home {
        totalSalesDollarLabel.text = "\(homeValue.totalHomeSoldValues(moc: managedObjectContext).currencyFormatter)"
        numCondoSoldLabel.text = "\(homeValue.totalSoldCondo(moc: managedObjectContext))"
        numSFSoldLabel.text = "\(homeValue.totalSoldSingleFamilyHome(moc: managedObjectContext))"
        minPriceHomeLabel.text = "\(homeValue.soldPrice(priceType: "min", moc: managedObjectContext).currencyFormatter)"
        maxPriceHomeLabel.text = "\(homeValue.soldPrice(priceType: "max", moc: managedObjectContext).currencyFormatter)"
        avgPriceCondoLabel.text = "\(homeValue.averagePrice(for: .Condo, moc: managedObjectContext).currencyFormatter)"
        avgPriceSFLabel.text = "\(homeValue.averagePrice(for: .SingleFamily, moc: managedObjectContext).currencyFormatter)"
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        
        switch section {
        case 0:
            rowCount = 3
        case 1, 2:
            rowCount = 2
        default:
            rowCount = 0
        }
        
        return rowCount
    }
}
