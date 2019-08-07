//
//  Home-Extension.swift
//  Home Report
//
//  Created by soni suman on 07/08/19.
//  Copyright © 2019 devhubs. All rights reserved.
//

import Foundation
import CoreData

extension Home {
  
  func getHomesByStatus(isForSall: Bool, filterBy: NSPredicate?, sortBy sort: [NSSortDescriptor], managedObjectContext: NSManagedObjectContext) -> [Home]? {
    let request : NSFetchRequest<Home> = Home.fetchRequest()
    var predicate = [NSPredicate]()
    let statusPredicate = NSPredicate(format:"isForSale = %@" ,NSNumber(value: isForSall))
    predicate.append(statusPredicate)
    if let additionalPredicate = filterBy {
      predicate.append(additionalPredicate)
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicate)
      request.predicate = compoundPredicate
      request.sortDescriptors = sort.isEmpty ? nil : sort
    }
    do {
      if let homes =  try? managedObjectContext.fetch(request) {
         return homes
      }
    } catch  {
      print("error=== \(error.localizedDescription)")
    }
    return nil
  }
  
}
