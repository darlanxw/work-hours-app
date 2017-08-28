//
//  CheckService.swift
//  WorkHours
//
//  Created by MacDD02 on 28/08/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import CoreData

class CheckingService {
    var coreDataStack:CoreDataStack = CoreDataStack()
    var context: NSManagedObjectContext
    
    @available(iOS 10.0, *)
    init(){
        self.context = coreDataStack.persistentContainer.viewContext
    }
    
    func getLastCheck() -> Checking?{
        let result = get(withPredicate: NSPredicate(value:true)).last
        
        return result
    }
    
    func getChecksOfCurrentDay() -> TimeInterval{
        let results = get(withPredicate: NSPredicate(format: "(checkin >= %@) AND (checkin <= %@)",  argumentArray: [Date().startOfDay,Date().endOfDay!]))
        
        var totalSecond:TimeInterval = 0;
        
        for item in results {
            if let myCheckout = item.checkout {
                totalSecond = totalSecond + myCheckout.timeIntervalSince(item.checkin! as Date)
            }else{
                totalSecond = totalSecond + Date().timeIntervalSince(item.checkin! as Date)
            }
        }
        
        print((totalSecond / 60) / 60)
        
        return totalSecond
    }
    
    
    func update(checkout: Date)
    {
        let lastCheck = getLastCheck()
        
        if let myLastCheck = lastCheck {
            myLastCheck.checkout = checkout as NSDate
            
            self.saveChanges()
        }
    }
    // Creates a new Check
    func create(checkin: Date, lat: NSNumber?, long: NSNumber?) -> Void {
        let check = NSEntityDescription.insertNewObject(forEntityName: "Checking", into: context) as! Checking
        
        check.checkin = checkin as NSDate
        check.checkout = nil
        //check.lat = lat as! Double
        //check.long = long as! Double
        
        self.saveChanges()
    }
    
    fileprivate func get(withPredicate queryPredicate: NSPredicate) -> [Checking]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Checking")
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try context.fetch(fetchRequest)
            return response as! [Checking]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [Checking]()
        }
    }
    
    // Gets a Check by id
    func getById(_ id: NSManagedObjectID) -> Checking? {
        return context.object(with: id) as? Checking
    }
    
    // Deletes a Check
    func delete(_ id: NSManagedObjectID){
        if let orderBatchToDelete = getById(id){
            context.delete(orderBatchToDelete)
        }
    }
    
    // Saves all changes
    func saveChanges(){
        do{
            try context.save()
        } catch let error as NSError {
            // failure
            print(error)
        }
    }
}
