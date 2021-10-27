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
                print("CoreDataManager init error : \(error.localizedDescription)");
            }
        }
        context = container.viewContext;
    }
    
    func save() {
        do{
            try context.save();
        }catch let error{
            print("CoreDataManager save error : \(error.localizedDescription)");
        }
    }
    
}
