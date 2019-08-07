//
//  SaleHistory-Extension.swift
//  Home Report
//
//  Created by soni suman on 07/08/19.
//  Copyright © 2019 devhubs. All rights reserved.
//

import Foundation
import CoreData
extension SaleHistory {
  func saleHistoryData(for sale: Home, manageObjectContext: NSManagedObjectContext) -> [SaleHistory]? {
    let request: NSFetchRequest<SaleHistory> = SaleHistory.fetchRequest()
    request.predicate = NSPredicate(format: "home = %@", sale)
    
    do {
     let soldHistory = try manageObjectContext.fetch(request)
      return soldHistory
    } catch  {
      print("error === \(error.localizedDescription)")
    }
    return nil
  }
}
