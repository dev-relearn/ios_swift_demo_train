//
//  TrainDataModel+CoreDataProperties.swift
//  DemoTrain
//
//  Created by Athira Krishnan on 28.01.24.
//
//

import Foundation
import CoreData


extension TrainDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainDataModel> {
        return NSFetchRequest<TrainDataModel>(entityName: "TrainDataModel")
    }

    @NSManaged public var id: UUID
    @NSManaged public var carriagesDataModel: NSOrderedSet

}

// MARK: Generated accessors for carriagesDataModel
extension TrainDataModel {

    @objc(insertObject:inCarriagesDataModelAtIndex:)
    @NSManaged public func insertIntoCarriagesDataModel(_ value: CarriageDataModel, at idx: Int)

    @objc(removeObjectFromCarriagesDataModelAtIndex:)
    @NSManaged public func removeFromCarriagesDataModel(at idx: Int)

    @objc(insertCarriagesDataModel:atIndexes:)
    @NSManaged public func insertIntoCarriagesDataModel(_ values: [CarriageDataModel], at indexes: NSIndexSet)

    @objc(removeCarriagesDataModelAtIndexes:)
    @NSManaged public func removeFromCarriagesDataModel(at indexes: NSIndexSet)

    @objc(replaceObjectInCarriagesDataModelAtIndex:withObject:)
    @NSManaged public func replaceCarriagesDataModel(at idx: Int, with value: CarriageDataModel)

    @objc(replaceCarriagesDataModelAtIndexes:withCarriagesDataModel:)
    @NSManaged public func replaceCarriagesDataModel(at indexes: NSIndexSet, with values: [CarriageDataModel])

    @objc(addCarriagesDataModelObject:)
    @NSManaged public func addToCarriagesDataModel(_ value: CarriageDataModel)

    @objc(removeCarriagesDataModelObject:)
    @NSManaged public func removeFromCarriagesDataModel(_ value: CarriageDataModel)

    @objc(addCarriagesDataModel:)
    @NSManaged public func addToCarriagesDataModel(_ values: NSOrderedSet)

    @objc(removeCarriagesDataModel:)
    @NSManaged public func removeFromCarriagesDataModel(_ values: NSOrderedSet)

}

extension TrainDataModel : Identifiable {

}
