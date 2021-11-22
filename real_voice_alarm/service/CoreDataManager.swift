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
        print("core data manager is created")
    }
    
    func save(savedAlarmName: String) {
        do{
            try context.save()
            //print("\(savedAlarmName) is saved")
        }catch let error {
            print("core data manager save error : \(error.localizedDescription)")
        }
    }
    
    func findAlarmById(uuid: String) -> AlarmEntity {
        var alarmEntity: AlarmEntity = AlarmEntity()
        
        let fetchRequest: NSFetchRequest<AlarmEntity>
        fetchRequest = AlarmEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "uuid == %@", uuid
        )
        do{
            //지금은 하나만 주지만 나중엔 뭉탱이로 줘야한다 왜냐면 언스케줄할 때 요일반복된 것도 다 삭제해야하기 때무니다
            alarmEntity = try context.fetch(fetchRequest)[0]
        }catch let error{
            print("find alarm error : \(error.localizedDescription)")
        }
        return alarmEntity
    }
    
    func deleteTargetEntity(id: String){
        let targetAlarm = findAlarmById(uuid: id)
        context.delete(targetAlarm)
        do{
            try context.save()
        }catch let error{
            print("delete Alarm entity error : \(error.localizedDescription)")
        }
    }
}
