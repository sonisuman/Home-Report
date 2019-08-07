//
//  Home+CoreDataClass.swift
//  Home Report
//
//  Created by soni suman on 07/08/19.
//  Copyright © 2019 devhubs. All rights reserved.
//
//

import Foundation
import CoreData


public class Home: NSManagedObject {
  
 private let request: NSFetchRequest<Home> = Home.fetchRequest()
 private let predicate  = NSPredicate(format: "isForSale = false")
  func totalHomeSoldValues(moc: NSManagedObjectContext) -> Double {
    request.predicate = predicate
    request.resultType = .dictionaryResultType
    let sumExpressionDiscription = NSExpressionDescription()
    sumExpressionDiscription.name = "totalSales"
    sumExpressionDiscription.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "price")])
    sumExpressionDiscription.expressionResultType = .doubleAttributeType
    request.propertiesToFetch = [sumExpressionDiscription]
    if let result = try? moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [NSDictionary],
      let totalSalesResult = result?.first?["totalSales"] as? Double {
        return totalSalesResult
      }
    else
    {
      return 0
    }
  }
}
