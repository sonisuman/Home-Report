//
//  AppDelegate.swift
//  Home Report
//
//  Created by Andi Setiyadi on 6/8/18.
//  Copyright © 2018 devhubs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreData = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        checkDataStore()
        
        let managedObjectContext = coreData.persistentContainer.viewContext
        
        let tabBarController = self.window?.rootViewController as! UITabBarController
        
        // First Tab - Home List
        let homeListNavigationController = tabBarController.viewControllers?[0] as! UINavigationController
        let homeListViewController = homeListNavigationController.topViewController as! HomeListViewController
        homeListViewController.managedObjectContext = managedObjectContext
        
        // Second Tab - Summary View
        let summaryNavigationController = tabBarController.viewControllers?[1] as! UINavigationController
        let summaryViewController = summaryNavigationController.topViewController as! SummaryTableViewController
        summaryViewController.managedObjectContext = managedObjectContext
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreData.saveContext()
    }

    func checkDataStore() {
        let request: NSFetchRequest<Home> = Home.fetchRequest()
        
        let moc = coreData.persistentContainer.viewContext
        do {
            let homeCount = try? moc.count(for: request)
            
            if homeCount == 0 {
                uploadSampleData()
            }
        }
        catch {
            fatalError("Error in counting home record")
        }
    }
    
  func uploadSampleData() {
    let moc = coreData.persistentContainer.viewContext
    if let url = Bundle.main.url(forResource: "homes", withExtension: "json"), let data = try? Data(contentsOf: url) {
      do {
        if  let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
          if let jsonArray = jsonData["home"] as? NSArray {
            for json in jsonArray {
              if let jsonDict = json as? [String: AnyObject] {
                guard  let bath = jsonDict["bath"],
                  let bed = jsonDict["bed"],
                  let city = jsonDict["city"],
                  let price = jsonDict["price"],
                  let sqft = jsonDict["sqft"],
                  let category = jsonDict["category"] as? NSDictionary,
                  let status = jsonDict["status"] as? NSDictionary else {
                  return
                }
                var image = UIImage()
                if let imageName = jsonDict["image"] as? String ,let currentImage = UIImage(named: imageName) {
                  image = currentImage
                }
                let homeType = category["homeType"] as? String
                let isForSall = status["isForSale"] as? Bool
                let home = homeType?.caseInsensitiveCompare("condo") == .orderedSame
                  ?Condo(context: moc) : SingleFamily(context: moc)
                home.bath =  bath.int16Value
                home.bed = bed.int16Value
                home.city = city as? String
                home.price = price as? Double ?? 0.0
                home.image = image.jpegData(compressionQuality: 1.0) as NSData?
                home.isForSale = isForSall ?? false
                home.sqft = sqft.int16Value
                home.homeType = homeType
                if let unitPerBuilding = jsonDict["unitsPerBuilding"],home.isKind(of: Condo.self) {
                  (home as! Condo).unitsPerBuilding = unitPerBuilding.int16Value
                }
                if let lotSize = jsonDict["lotSize"],home.isKind(of: SingleFamily.self) {
                  (home as! SingleFamily).lotSize = lotSize.int16Value
                }
                if let saleHistories = jsonDict["saleHistory"] as? NSArray {
                  let dateFormater = DateFormatter()
                  dateFormater.dateFormat = "yyyy-mm-dd"
                  let saleHistoryData = home.saleHistory?.mutableCopy() as? NSMutableSet
                  for detail in saleHistories {
                    if let saleData = detail as? [String: AnyObject] {
                      let saleHistory = SaleHistory(context: moc)
                      if let salePrice = saleData["soldPrice"] as? Double {
                        saleHistory.soldPrice = salePrice
                        print("price===\(salePrice)")
                      }
                      if let saleDateStr = saleData["soldDate"] as? String {
                        let soldDate = dateFormater.date(from: saleDateStr) as NSDate?
                        saleHistory.soldDate = soldDate
                      }
                      saleHistoryData?.add(saleHistory)
                    }
                  }
                  home.addToSaleHistory(saleHistoryData?.copy() as! NSSet)
                }
              }
              
            }
          }
        }
        coreData.saveContext()
      } catch {
        fatalError("can't parse the data")
      }
      
    }
  }
}

