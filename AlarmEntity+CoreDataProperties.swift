//
//  AlarmEntity+CoreDataProperties.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/11/06.
//
//

import Foundation
import CoreData


extension AlarmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmEntity> {
        return NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
    }

    @NSManaged public var audioName: String?
    @NSManaged public var audioURL: URL?
    @NSManaged public var fireAt: Date?
    @NSManaged public var isDay: Bool
    @NSManaged public var repeatingDays: [Int]
    @NSManaged public var tagName: String?
    @NSManaged public var uuid: String?
    @NSManaged public var volume: Double
    @NSManaged public var isActive: Bool

}

extension AlarmEntity : Identifiable {

}
