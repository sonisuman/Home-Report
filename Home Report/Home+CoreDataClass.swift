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
  
  func totalSoldCondo(moc: NSManagedObjectContext) -> Int {
    let typePredicate = NSPredicate(format: "homeType = '\(HomeType.Condo.rawValue)'")
    let predicateValue = NSCompoundPredicate(type: .and, subpredicates: [predicate, typePredicate])
    
    request.resultType = .countResultType
    request.predicate = predicateValue
    
    if let results = try? moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [Int],
      let count = results?.first {
      
      return count
    }
    
    return 0
  }
  
  func totalSoldSingleFamilyHome(moc: NSManagedObjectContext) -> Int {
    let typePredicate = NSPredicate(format: "homeType = '\(HomeType.SingleFamily.rawValue)'")
    let predicateValue = NSCompoundPredicate(type: .and, subpredicates: [predicate, typePredicate])
    
    request.predicate = predicateValue
    
    if let count = try? moc.count(for: request), count != NSNotFound {
      return count
    }
    
    return 0
  }
  
  func soldPrice(priceType: String, moc: NSManagedObjectContext) -> Double {
    request.predicate = predicate
    request.resultType = .dictionaryResultType
    
    let expressionDescription = NSExpressionDescription()
    expressionDescription.name = priceType
    expressionDescription.expression = NSExpression(forFunction: "\(priceType):", arguments: [NSExpression(forKeyPath: "price")]) // min: max:
    expressionDescription.expressionResultType = .doubleAttributeType
    
    request.propertiesToFetch = [expressionDescription]
    
    if let results = try? moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [NSDictionary],
      let homePrice = results?.first?[priceType] as? Double {
      
      return homePrice
    }
    
    return 0
  }
  
  func averagePrice(for homeType: HomeType, moc: NSManagedObjectContext) -> Double {
    let typePredicate = NSPredicate(format: "homeType = %@", homeType.rawValue)
    let predicateValue = NSCompoundPredicate(type: .and, subpredicates: [predicate, typePredicate])
    
    request.predicate = predicateValue
    request.resultType = .dictionaryResultType
    
    let expressionDescription = NSExpressionDescription()
    expressionDescription.name = homeType.rawValue
    expressionDescription.expression = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: "price")])
    expressionDescription.expressionResultType = .doubleAttributeType
    
    request.propertiesToFetch = [expressionDescription]
    
    if let results = try? moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [NSDictionary],
      let homePrice = results?.first?[homeType.rawValue] as? Double {
      
      return homePrice
    }
    
    return 0
  }
}
