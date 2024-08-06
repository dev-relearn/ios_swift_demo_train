//
//  StructureView.swift
//  DemoTrain
//
//  Created by Athira Krishnan on 26.01.24.
//

import SwiftUI

struct StructureView: View {
    @State var editMode: EditMode = .inactive
    @EnvironmentObject private var viewModel : TrainViewModel
    @Binding var carriages: [Carriage]
    @Binding var trainID: UUID
    
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
    
    var body: some View {
        VStack {
           
            VStack (alignment:.leading){
            List{
                Section {
                    ForEach(allLocomotives) { item in
                        VStack(alignment: .leading){
                            Text("\(item.carriageType.locomotive?.type.rawValue.capitalizingFirstLetter() ?? "") Locomotive")
                                .foregroundColor(.textPrimary)
                                .font(.title3.bold())
                            Text("Passenger Capacity: \(item.maxPassengers)" as String)
                                .foregroundColor(.textSecondary)
                                .font(.footnote)
                            Text("Loading Capacity: \(item.maxLoading)" as String)
                                .foregroundColor(.textSecondary)
                                .font(.footnote)
                        }
                        
                        .listRowSeparator(.hidden)
                    }
                    
                    .onMove(perform: move)
                }
                Section {
                    ForEach(allPassengerWagons) { item in
                        CoachView(item: item)
                    }
                    
                    .onMove(perform: move)
                }
                Section {
                    ForEach(allDineWagons) { item in
                        CoachView(item: item)
                    }
                    
                    .onMove(perform: move)
                }
                Section {
                    ForEach(allSleepWagons) { item in
                        CoachView(item: item)
                    }
                    
                    .onMove(perform: move)
                }
                Section {
                    ForEach(allGoodsWagons) { item in
                        CoachView(item: item)
                        
                    }
                    
                    .onMove(perform: move)
                }
            }.listSectionSpacing(8)
        }
         }.navigationTitle("Composition")
            .environment(\.editMode, $editMode)
     }
    
    func move(from source: IndexSet, to destination: Int) {
        print("from \(source)  to  \(destination)")
        carriages.move(fromOffsets: source, toOffset: destination)
        }
    
 }

#Preview {
    @State var carriages: [Carriage] = [Carriage(typeOfDesignation: "MODEL X", manufacturer: "BMW", year: "2024", maxPassengers: 100, trainLength: 100.0, curbWeight: 12.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: Locomotive(tractiveEffort: 100.0, type: .electric), wagon: nil)), Carriage(typeOfDesignation: "MODEL 234", manufacturer: "LG", year: "1998", maxPassengers: 100, trainLength: 100.0, curbWeight: 15.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .goods)))]
    @State var trainId: UUID = UUID()
        return StructureView(carriages: $carriages,trainID: $trainId)
}



struct CoachView: View {
    var item : Carriage
    var body: some View {
        VStack(alignment: .leading){
            Text("\(item.carriageType.wagon?.type.rawValue.capitalizingFirstLetter() ?? "") Wagon")
                .foregroundColor(.textPrimary)
                .font(.title3.bold())
            Text("Passenger Capacity \(item.maxPassengers)")
                .foregroundColor(.textSecondary)
                .font(.footnote)
            Text("Loading Capacity \(item.maxLoading)" as String)
                .foregroundColor(.textSecondary)
                .font(.footnote)
        }
    }
}
