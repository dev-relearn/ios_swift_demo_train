//
//  TrainViewModel.swift
//  DemoTrain
//
//  Created by Athira Krishnan on 26.01.24.
//

import Foundation


class TrainViewModel:ObservableObject,Observable{
    @Published var trains = [Train]()
    var databaseHandler: DatabaseDelegate
    
    init(databaseHandler: DatabaseDelegate = CoreDataDataService(manager: PersistenceController.shared)) {
           self.databaseHandler = databaseHandler
       }
    
    func changeComposition(newComposition:[Carriage],trainID: UUID) -> Void{
        if let fetchResults = databaseHandler.retrieveAllTrainsFromDB(){
            if let savedItem = fetchResults.filter({ $0.id == trainID}).first{
                let changedIndex = zip(savedItem.carriages, newComposition).enumerated().filter {$1.0 != $1.1}.map {$0.offset}
                if(changedIndex.count > 0){
                    databaseHandler.updateCarriages(forTrainWithId: trainID, newIndexes: changedIndex, carriages: newComposition)
                    getData()
                }
                
            }
        }
    }
    
    
   /* func getData(){
        databaseHandler.tryMethods { result in
            switch result {
            case .success(let trains):
                self.trains = trains
                print(trains[0].carriages)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }*/
    
    func getData(){
        if let fetchResults = databaseHandler.retrieveAllTrainsFromDB(){
            self.trains = fetchResults
        }
        
    }
    
 
}
