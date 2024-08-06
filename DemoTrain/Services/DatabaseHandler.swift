//
//  DatabaseHandler.swift
//  DemoTrain
//
//  Created by Athira Krishnan on 26.01.24.
//

import Foundation
import CoreData

protocol DatabaseDelegate{
    func saveTrainToDB(train:Train) -> Void
    func retrieveAllTrainsFromDB() -> [Train]?
    func retrieveSavedCarriagesFromDB() -> [UUID]?
    func updateCarriages(forTrainWithId: UUID, newIndexes: [Int], carriages: [Carriage]) 
}

class DatabaseHandler{
    
    func tryMethods(completion: @escaping(Result<[Train], AppError>) -> Void){
        guard let url = Bundle.main.url(forResource: "myTrain", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let model = try? JSONDecoder().decode([Train].self, from: data) else {
                  return completion(.failure(.DecodingError))
              }
        completion(.success(model))
    }
    
}


class CoreDataDataService: DatabaseDelegate {
   
    private let manager: PersistenceController
    
    init(manager: PersistenceController = PersistenceController.preview) {
        self.manager = manager
    }
    
    // MARK: CRUD
  
    private func createTrainEntity(id: UUID) -> TrainDataModel {
        let trainDataModel = TrainDataModel(context: manager.container.viewContext)
        trainDataModel.id = id
      return trainDataModel
    }
    private func createCarriageEntity(carriage: Carriage,position:Int ,trainDataModel: TrainDataModel) -> CarriageDataModel {
        let carriageDataModel = CarriageDataModel(context: manager.container.viewContext)
        carriageDataModel.id = carriage.id
        carriageDataModel.typeOfDesignation = carriage.typeOfDesignation
        carriageDataModel.manufacturer = carriage.manufacturer
        carriageDataModel.year = carriage.year
        carriageDataModel.curbWeight = (carriage.curbWeight) as NSDecimalNumber
        carriageDataModel.maxLoading = (carriage.maxLoading) as NSDecimalNumber
        carriageDataModel.maxPassengers = Int16(carriage.maxPassengers)
        if(carriage.carriageType.locomotive != nil){
            carriageDataModel.carriageType = (carriage.carriageType.locomotive?.type.rawValue)!
            carriageDataModel.tractiveEffort = (carriage.carriageType.locomotive?.tractiveEffort)! as NSDecimalNumber
        }else{
            carriageDataModel.carriageType = (carriage.carriageType.wagon?.type.rawValue)!
            carriageDataModel.tractiveEffort = 0.0
        }
        
        carriageDataModel.trainLength = (carriage.trainLength) as NSDecimalNumber
        carriageDataModel.position = Int16(position)
        trainDataModel.addToCarriagesDataModel(carriageDataModel)
        return carriageDataModel
    }
    
    private func fetchTrainDataModels() -> [TrainDataModel] {
      let request: NSFetchRequest<TrainDataModel> = TrainDataModel.fetchRequest()
      var fetchedTrainDataModels: [TrainDataModel] = []
      do {
          fetchedTrainDataModels = try manager.container.viewContext.fetch(request)
      } catch let error {
         print("Error fetching trainDataModels \(error)")
      }
      return fetchedTrainDataModels
    }
    private func fetchCarriagesDataModel(trainDataModel: TrainDataModel) -> [CarriageDataModel] {
      let request: NSFetchRequest<CarriageDataModel> = CarriageDataModel.fetchRequest()
      request.predicate = NSPredicate(format: "trainDataModel = %@", trainDataModel)
        request.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]

      var fetchedCarriageDataModels: [CarriageDataModel] = []
      do {
          fetchedCarriageDataModels = try manager.container.viewContext.fetch(request)
      } catch let error {
        print("Error fetching carriagesDataModel \(error)")
      }
      return fetchedCarriageDataModels
    }
    private func fetchTrainDataModels(withId:UUID) -> [TrainDataModel] {
      let request: NSFetchRequest<TrainDataModel> = TrainDataModel.fetchRequest()
      var fetchedTrainDataModels: [TrainDataModel] = []
        request.predicate = NSPredicate(format: "id = %@", withId as CVarArg)
      do {
          fetchedTrainDataModels = try manager.container.viewContext.fetch(request)
      } catch let error {
         print("Error fetching trainDataModels \(error)")
      }
      return fetchedTrainDataModels
    }
    private func fetchCarriagesDataModel() -> [CarriageDataModel]? {
      let request: NSFetchRequest<CarriageDataModel> = CarriageDataModel.fetchRequest()
      var fetchedCarriageDataModels: [CarriageDataModel] = []
      do {
          fetchedCarriageDataModels = try manager.container.viewContext.fetch(request)
      } catch let error {
        print("Error fetching carriagesDataModel \(error)")
      }
        return fetchedCarriageDataModels
    }
    
    private func update(atIndex: Int, carriage: Carriage,trainDataModel: TrainDataModel) {

        let carriageDataModel = CarriageDataModel(context: manager.container.viewContext)
        carriageDataModel.id = carriage.id
        carriageDataModel.typeOfDesignation = carriage.typeOfDesignation
        carriageDataModel.manufacturer = carriage.manufacturer
        carriageDataModel.year = carriage.year
        carriageDataModel.curbWeight = (carriage.curbWeight) as NSDecimalNumber
        carriageDataModel.maxLoading = (carriage.maxLoading) as NSDecimalNumber
        carriageDataModel.maxPassengers = Int16(carriage.maxPassengers)
        if(carriage.carriageType.locomotive != nil){
            carriageDataModel.carriageType = (carriage.carriageType.locomotive?.type.rawValue)!
            carriageDataModel.tractiveEffort = (carriage.carriageType.locomotive?.tractiveEffort)! as NSDecimalNumber
        }else{
            carriageDataModel.carriageType = (carriage.carriageType.wagon?.type.rawValue)!
            carriageDataModel.tractiveEffort = 0.0
        }
        
        carriageDataModel.trainLength = (carriage.trainLength) as NSDecimalNumber
        carriageDataModel.position = Int16(atIndex)
        trainDataModel.replaceCarriagesDataModel(at: atIndex, with: carriageDataModel)
        
         
     }
     
    private func delete(trainId: UUID) {
         //manager.container.viewContext.delete()
         save()
     }
    
    private func save() {
        do {
            try manager.container.viewContext.save()
        } catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
        
    }
    
    func saveTrainToDB(train: Train) {
        let trainDataModel = createTrainEntity(id: train.id)
        for (index,item) in train.carriages.enumerated(){
            let carriageDataModel = createCarriageEntity(carriage: item, position: index, trainDataModel: trainDataModel)
            print(carriageDataModel)
            save()
        }
        
        
    }
    
    func retrieveAllTrainsFromDB() -> [Train]? {
        var trains = [Train]()
        let fetchTrainDataModels = fetchTrainDataModels()
        for item in fetchTrainDataModels{
            var carriages = [Carriage]()
            let fetchCarriagesDataModel = fetchCarriagesDataModel(trainDataModel: item)
            for (index,element) in fetchCarriagesDataModel.enumerated(){
                let carriage = Carriage(element)
                carriages.insert(carriage, at: index)

            }
            print (carriages)
            var train = Train(item)
            train.carriages = carriages
            trains.append(train)
        }
        return trains
    }
    
    func retrieveSavedCarriagesFromDB() -> [UUID]? {
        let fetchCarriagesDataModel = fetchCarriagesDataModel()
        return fetchCarriagesDataModel.map { $0.map {
            $0.id
        } }
    }
    
    func updateCarriages(forTrainWithId: UUID, newIndexes: [Int], carriages: [Carriage]) {
         let fetchTrainDataModels = fetchTrainDataModels(withId: forTrainWithId)
        if fetchTrainDataModels.count > 0{
            let trainDataModel = fetchTrainDataModels[0]
            let carriageDataModel = fetchCarriagesDataModel(trainDataModel: trainDataModel)
            for position in newIndexes{
                update(atIndex:position , carriage: carriages[position], trainDataModel: trainDataModel)
                print(carriageDataModel)
                save()
            }

        }
    }
    
}
