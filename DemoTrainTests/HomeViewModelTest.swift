//
//  HomeViewModelTest.swift
//  TrainTests
//
//  Created by Athira Krishnan on 26.01.24.
//

import XCTest

@testable import DemoTrain

final class HomeViewModelTest: XCTestCase {

    func testCarriages(){
        let sut = HomeViewModel(serviceHandler: MockCarriageService())
        sut.fetchCarriages()
        
    }
    
    func testTrain(){
        let sut = HomeViewModel(trainserviceHandler: MockTrainService())
        
    }
    
    func testFirstElement(){
        let sut = HomeViewModel(trainserviceHandler: MockTrainService())
        let l = Carriage(typeOfDesignation: "MODEL X", manufacturer: "BMW", year: "2024", maxPassengers: 100, trainLength: 100.0, curbWeight: 12.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: Locomotive(tractiveEffort: 100.0, type: .electric), wagon: nil))
        let g = Carriage(typeOfDesignation: "MODEL 234", manufacturer: "LG", year: "1998", maxPassengers: 100, trainLength: 100.0, curbWeight: 15.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .goods)))
        let p = Carriage(typeOfDesignation: "MODEL 567", manufacturer: "BMW", year: "2000", maxPassengers: 100, trainLength: 100.0, curbWeight: 15.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .passenger)))
        let d = Carriage(typeOfDesignation: "MODEL 809", manufacturer: "BMW", year: "1805", maxPassengers: 100, trainLength: 100.0, curbWeight: 16.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .dine)))
        
       //let train = sut.trainserviceHandler.composeTrain(collectedCarriages: [p,l,g,d])
        let train = sut.trainserviceHandler.composeTrain(collectedCarriages: [l,p,d,g])
        
        XCTAssertNotNil(train.carriages.first?.carriageType.locomotive, "Train has no engine")
        
    }
    
    func testCollection(){
        let sut = HomeViewModel(trainserviceHandler: MockTrainService())
        let l = Carriage(typeOfDesignation: "MODEL X", manufacturer: "BMW", year: "2024", maxPassengers: 100, trainLength: 100.0, curbWeight: 12.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: Locomotive(tractiveEffort: 100.0, type: .electric), wagon: nil))
        let p = Carriage(typeOfDesignation: "MODEL 567", manufacturer: "BMW", year: "2000", maxPassengers: 100, trainLength: 100.0, curbWeight: 15.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .passenger)))
        
        let selectedCarriage:Carriage = p
        
        sut.trainserviceHandler.collectCarriage(selectedCarriage: selectedCarriage) {  result in
            switch result{
            case .success(_):
                sut.trainserviceHandler.createTrain(collectedCarriages: sut.trainserviceHandler.tempTrain.carriages) { result in
                    switch result{
                    case .success(let composedTrain):
                        XCTAssertEqual(composedTrain.carriages[0],selectedCarriage)
                    case .failure(let error):
                        XCTAssertEqual(error.rawValue, OperationError.Creation.rawValue)
                        
                    }
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    

}
