//
//  MockTrainService.swift
//  TrainTests
//
//  Created by Athira Krishnan on 26.01.24.
//

import Foundation

@testable import DemoTrain

class MockTrainService: TrainServiceDelegate{
    
    
    var tempTrain: DemoTrain.Train = Train()
    
    let l = Carriage(typeOfDesignation: "MODEL X", manufacturer: "BMW", year: "2024", maxPassengers: 100, trainLength: 100.0, curbWeight: 12.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: Locomotive(tractiveEffort: 100.0, type: .electric), wagon: nil))
    let g = Carriage(typeOfDesignation: "MODEL 234", manufacturer: "LG", year: "1998", maxPassengers: 100, trainLength: 100.0, curbWeight: 15.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .goods)))
    let p = Carriage(typeOfDesignation: "MODEL 567", manufacturer: "BMW", year: "2000", maxPassengers: 100, trainLength: 100.0, curbWeight: 15.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .passenger)))
    let d = Carriage(typeOfDesignation: "MODEL 809", manufacturer: "BMW", year: "1805", maxPassengers: 100, trainLength: 100.0, curbWeight: 16.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .dine)))
    
    
    func collectCarriage(selectedCarriage: DemoTrain.Carriage, completion: @escaping (Result<Bool, DemoTrain.OperationError>) -> Void) {
        tempTrain.carriages.append(selectedCarriage)

    }
    
    func createTrain(collectedCarriages: [DemoTrain.Carriage], completion: @escaping (Result<DemoTrain.Train, DemoTrain.OperationError>) -> Void) {
        let composedTrain = composeTrain(collectedCarriages: collectedCarriages)
        completion(.success(composedTrain))
    }
    
    func removeCollectedCarriage(selectedCarriage: DemoTrain.Carriage, completion: @escaping (Result<Bool, DemoTrain.OperationError>) -> Void) {
        
    }
    
    func composeTrain(collectedCarriages: [DemoTrain.Carriage]) -> DemoTrain.Train {
        var composedCarriages: [Carriage] = []
        let tmpTrain = Train(carriages: collectedCarriages)
        composedCarriages.append(contentsOf: tmpTrain.allLocomotives)
        composedCarriages.append(contentsOf: tmpTrain.allPassengerWagons)
        composedCarriages.append(contentsOf: tmpTrain.allDineWagons)
        composedCarriages.append(contentsOf: tmpTrain.allSleepWagons)
        composedCarriages.append(contentsOf: tmpTrain.allGoodsWagons)
        return Train(carriages: composedCarriages)
    }
    
    

}

