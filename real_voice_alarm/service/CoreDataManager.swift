//
//  CoreDataManager.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/27.
//

import Foundation
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager();
    let container: NSPersistentContainer;
    let context: NSManagedObjectContext;
    
    init() {
        container = NSPersistentContainer(name:"CoreDataContainer");
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreDataManager init error : \(error)");
            }
        }
        context = container.viewContext;
    }
    
    func save(savedEntity: String) {
        do{
            try context.save()
            print("\(savedEntity) is saved")
        }catch let error {
            print("core data manager save error : \(error.localizedDescription)")
        }
    }
    
}
