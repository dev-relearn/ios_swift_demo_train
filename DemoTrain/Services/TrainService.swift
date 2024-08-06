//
//  TrainService.swift
//  Train
//
//  Created by Athira Krishnan on 26.01.24.
//


import Foundation

enum OperationError:String, Error {
    case NoLoco = "Train must have an engine"
    case TractiveEffort = "Train needs more engine"
    case Remove = "Remove failed"
    case Creation = "Creation Failed"
}


// MARK: - PROTOCOL
protocol TrainServiceDelegate: TrainDelegate  {
    
    var tempTrain : Train { get set }
    func collectCarriage(selectedCarriage: Carriage,completion: @escaping(Result<Bool, OperationError>) -> Void)
    func createTrain(collectedCarriages:[Carriage] , completion: @escaping(Result<Train, OperationError>) -> Void)
    func removeCollectedCarriage(selectedCarriage: Carriage,completion: @escaping(Result<Bool, OperationError>) -> Void)
    func composeTrain(collectedCarriages: [Carriage]) -> Train

}

protocol TrainDelegate {
    // API methods
}

protocol Validators {
    func hasAnEngine() -> Bool
    func validTractiveEffort() -> Bool
    func validateCollection() -> (status: Bool, msg: OperationError)
}

// MARK: - CLASS

class TrainService: TrainServiceDelegate,Validators  {
   
    var tempTrain = Train()
    
    func collectCarriage(selectedCarriage: Carriage, completion: @escaping (Result<Bool, OperationError>) -> Void) {
        tempTrain.carriages.append(selectedCarriage)
        let validationResult = validateCollection()
        validationResult.status ? completion(.success(true)) : completion(.failure(validationResult.msg))

    }
    
    func removeCollectedCarriage(selectedCarriage: Carriage,completion: @escaping (Result<Bool, OperationError>) -> Void) {
        if let index = tempTrain.carriages.firstIndex(where: {$0.id == selectedCarriage.id}){
            tempTrain.carriages.remove(at: index)
            let validationResult = validateCollection()
            validationResult.status ? completion(.success(true)) : completion(.failure(validationResult.msg))
        }
    }
    
    func createTrain(collectedCarriages: [Carriage], completion: @escaping (Result<Train, OperationError>) -> Void) {
        let composedTrain = composeTrain(collectedCarriages: collectedCarriages)
        tempTrain = Train()
        composedTrain.carriages.count > 0 ? completion(.success(composedTrain)) : completion(.failure(.Creation))
        
        
    }
    
    func composeTrain(collectedCarriages: [Carriage]) -> Train{
        let allLocos = tempTrain.allLocomotives
        guard allLocos.count <= 0 else {
            var composedCarriages: [Carriage] = []
            let tempTrain = Train(carriages: collectedCarriages)
            switch allLocos.count {
            case 1:
                composedCarriages.append(contentsOf: tempTrain.allLocomotives)
                composedCarriages.append(contentsOf: tempTrain.allPassengerWagons)
                composedCarriages.append(contentsOf: tempTrain.allDineWagons)
                composedCarriages.append(contentsOf: tempTrain.allSleepWagons)
                composedCarriages.append(contentsOf: tempTrain.allGoodsWagons)
            case 2:
                composedCarriages.append(tempTrain.allLocomotives[0])
                composedCarriages.append(contentsOf: tempTrain.allPassengerWagons)
                composedCarriages.append(contentsOf: tempTrain.allDineWagons)
                composedCarriages.append(contentsOf: tempTrain.allSleepWagons)
                composedCarriages.append(contentsOf: tempTrain.allGoodsWagons)
                composedCarriages.append(tempTrain.allLocomotives[1])
            default:
                composedCarriages.append(tempTrain.allLocomotives[0])
                composedCarriages.append(contentsOf: tempTrain.allPassengerWagons)
                composedCarriages.append(contentsOf: tempTrain.allDineWagons)
                composedCarriages.append(contentsOf: tempTrain.allSleepWagons)
                composedCarriages.append(contentsOf: tempTrain.allGoodsWagons)
                composedCarriages.append(contentsOf: tempTrain.allLocomotives[1..<tempTrain.allLocomotives.endIndex])
            
            }
            return Train(carriages: composedCarriages)
        }
        
        
        return Train()
    }
    
    func hasAnEngine() -> Bool {
        return tempTrain.hasLocomotive
    }
    
    func validTractiveEffort() -> Bool {
        (tempTrain.maxLoading + tempTrain.emptyWeight - tempTrain.emptyWeightLocos) <= tempTrain.tractiveEffort ? true : false
    }
   
    func validateCollection() -> (status: Bool, msg: OperationError) {
        if hasAnEngine() {
            print("Train has engine tractive effort calculation possible")
            return (validTractiveEffort(),OperationError.TractiveEffort)
        }else{
            print("no engine")
            return (false,OperationError.NoLoco)
        }
    }
    

        
}
// MARK: - EXTENSION

extension Array where Element: Equatable
{
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) { self.move(from: oldIndex, to: newIndex) }
    }
}

extension Array
{
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
