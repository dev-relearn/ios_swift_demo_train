//
//  HomeViewModel.swift
//  sample
//
//  Created by Athira Krishnan on 25.01.24.
//

import Foundation

class HomeViewModel:ObservableObject,Observable{
    @Published var carriages = [Carriage]()
    private var selectedcarriages = [Carriage]()
    @Published var disableCreateButton: Bool = true
    let defaults = UserDefaults.standard
    private var apiData: [Carriage]?
    @Published var tempTractiveEffort: Decimal = 0.0
    
    let serviceHandler: CarriageServiceDelegate
    let dataHandler: CarriageDelegate
    var trainserviceHandler : TrainServiceDelegate
    let databaseHandler : DatabaseDelegate
       
       init(serviceHandler: CarriageServiceDelegate = CarriageService(),
            dataHandler: CarriageDelegate = DataHandler(),trainserviceHandler: TrainServiceDelegate = TrainService(),databaseHandler: DatabaseDelegate = CoreDataDataService(manager: PersistenceController.shared)) {
           self.serviceHandler = serviceHandler
           self.dataHandler = dataHandler
           self.trainserviceHandler = trainserviceHandler
           self.databaseHandler = databaseHandler
       
       }
    func fetchCarriages() {
        retrieveFromdefaults()
            if isConnected() {
                serviceHandler.getCarriages { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let carriages):
                            self.carriages = carriages
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                }
            } else {
                if(apiData != nil && apiData!.count > 0){
                    setData(carriages:apiData!)
                }else{
                    dataHandler.getCarriages { result in
                        DispatchQueue.main.async { [self] in
                            switch result {
                            case .success(let carriages):
                               setData(carriages: carriages)
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                        
                    }
                }
                
            }
            
        }
        
        private func isConnected()-> Bool {
            return false
        }
    
    private func setData(carriages:[Carriage]) -> Void{
        if let uuids: [UUID] = databaseHandler.retrieveSavedCarriagesFromDB(){
            self.carriages = carriages.filter { !uuids.contains($0.id) }
        }else{
            self.carriages = carriages
        }
        savetoDefaults(carriages: carriages)
    }
        
    func carriageSelected(selectedCarriage: Carriage){
        selectedCarriage.isSelected ? collectCarriage(selectedCarriage: selectedCarriage) : removeCarriage(selectedCarriage: selectedCarriage)
        }
    private func collectCarriage(selectedCarriage: Carriage){
        print("carriage Selected")
        trainserviceHandler.collectCarriage(selectedCarriage: selectedCarriage) { [self] result in
            DispatchQueue.main.async {[self] in
            switch result{
            case .success(_):
                updateSelectionListAfterSelection(withCarriage: selectedCarriage)
                disableCreateButton = selectedcarriages.count > 0 ? false : true
            case .failure(let error):
                print(error.rawValue)
                updateSelectionListAfterSelection(withCarriage: selectedCarriage)
                disableCreateButton = true
            }
        }
        }
    }
    private func removeCarriage(selectedCarriage: Carriage){
        print("carriage DeSelected")
        trainserviceHandler.removeCollectedCarriage(selectedCarriage: selectedCarriage) {[self] result in
            DispatchQueue.main.async {[self] in
            switch result {
            case .success(_):
               updateSelectionListAfterDeSelection(withCarriage: selectedCarriage)
                disableCreateButton = selectedcarriages.count > 0 ? false : true
            case .failure(let error):
                updateSelectionListAfterDeSelection(withCarriage: selectedCarriage)
                disableCreateButton = true
                print(error)
            }
        }
        }
    }
    
    private func updateSelectionListAfterSelection(withCarriage: Carriage){
        selectedcarriages.append(withCarriage)
        tempTractiveEffort =  updateTractiveEffort()

    }
    private func updateSelectionListAfterDeSelection(withCarriage: Carriage){
        if let index = selectedcarriages.firstIndex(where: {$0.id == withCarriage.id}){
            selectedcarriages.remove(at: index)
            tempTractiveEffort =  updateTractiveEffort()

            
        }
    }
    
    func createTrain(){
        trainserviceHandler.createTrain(collectedCarriages: selectedcarriages) { [self] result in
            DispatchQueue.main.async { [self] in
            switch result{
            case .success(let train):
                saveTrain(train: train)
                print("train created")
                disableCreateButton = true
                removeAllocatedCarriages()
            case .failure(let error):
                print(error)
            }
        }
            }
        }
    
    private func saveTrain(train: Train){
        print(train)
        databaseHandler.saveTrainToDB(train: train)
    }
    
    private func removeAllocatedCarriages() -> Void {
        DispatchQueue.main.async { [self] in
            self.carriages = self.carriages.filter { !selectedcarriages.contains($0) }
            print("remove from list")
            resetData()
        }
    }
    
    private func resetData(){
        selectedcarriages = [Carriage]()
        trainserviceHandler.tempTrain = Train()
        setData(carriages: carriages)
        retrieveFromdefaults()
        tempTractiveEffort = updateTractiveEffort()
    }
    
    private func updateTractiveEffort() -> Decimal{
        guard selectedcarriages.count < 0 else {
            if(trainserviceHandler.tempTrain.hasLocomotive)
            {
                return trainserviceHandler.tempTrain.tractiveEffort
            }
            return 0.0
        }
        return 0.0
    }
    private func savetoDefaults(carriages:[Carriage]){
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(carriages)
            defaults.set(data, forKey: "apiData")
            defaults.synchronize()
        } catch let error {
           print("Error saving to usedefaults \(error)")
        }
        
    }
    private func retrieveFromdefaults(){
        if let data = UserDefaults.standard.data(forKey: "apiData") {
            
            do{
                let decoder = JSONDecoder()
                apiData = try decoder.decode([Carriage].self, from: data)
                
            } catch let error {
                print("Error fetching from userdefaults \(error)")
            }
        }
        
    }
    func onDisapper(){
        print("disapper")
        disableCreateButton = true
        resetData()
    }
}
