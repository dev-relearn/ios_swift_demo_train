//
//  Model.swift
//  Train
//
//  Created by Athira Krishnan on 26.01.24.
//

import Foundation

// MARK: - Carriage
struct Carriage: Codable,Identifiable,Hashable,Comparable{
    static func < (lhs: Carriage, rhs: Carriage) -> Bool {
        return lhs.position < rhs.position
    }
    
    static func == (lhs: Carriage, rhs: Carriage) -> Bool {
        return lhs.id == rhs.id

    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id = UUID()
    let typeOfDesignation, manufacturer, year: String
    let maxPassengers: Int
    let trainLength,curbWeight, maxLoading: Decimal
    let carriageType: CarriageType
    
    var isSelected: Bool = false
    var position: Int = 0
    
    enum CodingKeys: String, CodingKey {
            case typeOfDesignation, manufacturer, year,maxPassengers,trainLength, curbWeight, maxLoading,carriageType
        }
    public mutating func selected(val: Bool) {
        
        if(val != isSelected){
            isSelected.toggle()
            
        }
            
        }
  
}


// MARK: - CarriageType
struct CarriageType: Codable {
    let locomotive: Locomotive?
    let wagon: Wagon?

}

// MARK: - Locomotive
struct Locomotive: Codable {
    let tractiveEffort: Decimal
    let type: LocomotiveType
}

// MARK: - Wagon
struct Wagon: Codable {
    let type: WagonType
}

enum LocomotiveType:String,Codable {
    case diesel = "diesel"
    case steam = "steam"
    case electric = "electric"
    
    init(from decoder: Decoder) throws {
            let value = try decoder.singleValueContainer().decode(String.self)
            self = LocomotiveType(rawValue: value)!
           }
}
enum WagonType:String,Codable {
    case passenger = "passenger"
    case sleep = "sleep"
    case dine = "dine"
    case goods = "goods"
    
    init(from decoder: Decoder) throws {
            let value = try decoder.singleValueContainer().decode(String.self)
            self = WagonType(rawValue: value)!
           }

        
}

// MARK: - Train
struct Train: Codable,Identifiable {
    var id = UUID()
    var carriages = [Carriage]()
    
    var emptyWeight: Decimal {
        carriages.map(\.curbWeight).reduce(0.0, +)
    }
    var emptyWeightLocos: Decimal {
        allLocomotives.map(\.curbWeight).reduce(0.0, +)
    }
    var maxPassengers: Int{
        // Number of Passengers in Dining Coach is excluded.
        //carriages.map(\.maxPassengers).reduce(0, +) - carriages.filter({ $0.carriageType.wagon?.type == .dine}).map(\.maxPassengers).reduce(0, +)
        carriages.map(\.maxPassengers).reduce(0, +)
    }
    var maxGoods: Decimal  {
        carriages.map(\.maxLoading).reduce(0.0, +)
    }
    var maxLoading: Decimal  {
        (Decimal(maxPassengers) * 75)/1000 + maxGoods
    }
    var trainLength:Decimal  {
        carriages.map(\.trainLength).reduce(0.0, +)
    }
    var trainWeight:Decimal  {
        maxLoading + emptyWeight
    }
    var conductorNeeded:Bool{
        maxPassengers > 0 ? true : false
    }
    var numberOfConductors:Int{
        conductorNeeded ? maxPassengers / 50 : 0
    }
    var tractiveEffort:Decimal{
        let locoCarriages:[Carriage] = carriages.filter({ $0.carriageType.locomotive != nil})
        let tractiveEffort = locoCarriages.lazy.compactMap { $0.carriageType.locomotive?.tractiveEffort }.reduce(0.0, +)
        return tractiveEffort
    }
    
    var hasLocomotive:Bool{
         !carriages.filter({ $0.carriageType.locomotive != nil}).isEmpty
            
    }
    var allLocomotives:[Carriage]{
        carriages.filter({ $0.carriageType.locomotive != nil})

    }
    var allPassengerWagons:[Carriage]{
        carriages.filter({ $0.carriageType.wagon?.type == .passenger})
    }
    var allDineWagons:[Carriage]{
        carriages.filter({ $0.carriageType.wagon?.type == .dine})
    }
    var allSleepWagons:[Carriage]{
        carriages.filter({ $0.carriageType.wagon?.type == .sleep})
    }
    var allGoodsWagons:[Carriage]{
        carriages.filter({ $0.carriageType.wagon?.type == .goods})
    }
    
    enum CodingKeys: String, CodingKey {
        case carriages
    }
}


// MARK: - Extension

extension Carriage{
    
    init(_ entity: CarriageDataModel) {
        self.id = entity.id
        self.typeOfDesignation = entity.typeOfDesignation
        self.manufacturer = entity.manufacturer
        self.year = entity.year
        self.maxPassengers = Int(entity.maxPassengers)
        self.trainLength = entity.trainLength as Decimal
        self.curbWeight = entity.curbWeight as Decimal
        self.maxLoading = entity.maxLoading as Decimal
        self.position = Int(entity.position)
        switch entity.carriageType{
        case LocomotiveType.electric.rawValue,LocomotiveType.steam.rawValue,LocomotiveType.diesel.rawValue:
            self.carriageType = CarriageType(locomotive: Locomotive(tractiveEffort: entity.tractiveEffort as Decimal, type: LocomotiveType(rawValue: entity.carriageType)!), wagon: nil)
        default:
            self.carriageType = CarriageType(locomotive: nil, wagon: Wagon(type: WagonType(rawValue: entity.carriageType)! ))

        }
    }
}

extension Train{
    
    init(_ entity: TrainDataModel) {
        self.id = entity.id
        
    }
}
