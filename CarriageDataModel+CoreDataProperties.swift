//
//  CarriageDataModel+CoreDataProperties.swift
//  DemoTrain
//
//  Created by Athira Krishnan on 28.01.24.
//
//

import Foundation
import CoreData


extension CarriageDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarriageDataModel> {
        return NSFetchRequest<CarriageDataModel>(entityName: "CarriageDataModel")
    }

    @NSManaged public var id: UUID
    @NSManaged public var typeOfDesignation: String
    @NSManaged public var year: String
    @NSManaged public var manufacturer: String
    @NSManaged public var trainLength: NSDecimalNumber
    @NSManaged public var maxPassengers: Int16
    @NSManaged public var curbWeight: NSDecimalNumber
    @NSManaged public var maxLoading: NSDecimalNumber
    @NSManaged public var carriageType: String
    @NSManaged public var tractiveEffort: NSDecimalNumber
    @NSManaged public var position: Int16
    @NSManaged public var trainDataModel: TrainDataModel

}

extension CarriageDataModel : Identifiable {

}
