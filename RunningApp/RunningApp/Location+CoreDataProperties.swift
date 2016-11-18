//
//  Location+CoreDataProperties.swift
//  RunningApp
//
//  Created by lyu on 16/11/2.
//  Copyright © 2016年 lyuchulin. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var lattitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var run: Run?

}
