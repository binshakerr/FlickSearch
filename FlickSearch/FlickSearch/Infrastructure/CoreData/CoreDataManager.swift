//
//  CoreDataManager.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 31/10/2021.
//

import UIKit
import CoreData

protocol CoreDataMangerType {
    func save(values: [String: Any], entityName: String)
    func loadObjects(_ entityName: String)-> [NSManagedObject]?
}

class CoreDataManager: CoreDataMangerType {
    
    static let shared = CoreDataManager()
    
    func save(values: [String: Any], entityName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        for value in values {
            object.setValue(value.value, forKeyPath: value.key)
        }
        appDelegate.saveContext()
    }
    
    func loadObjects(_ entityName: String)-> [NSManagedObject]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
}
