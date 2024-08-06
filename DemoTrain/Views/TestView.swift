//
//  StructureView.swift
//  DemoTrain
//
//  Created by Athira Krishnan on 26.01.24.
//

import SwiftUI

struct TestView: View {
    @State var editMode: EditMode = .inactive
    @EnvironmentObject private var viewModel : TrainViewModel
    @Binding var carriages: [Carriage]
    @Binding var trainID: UUID
    
    var body: some View {
        
            VStack (alignment:.leading){
             
                List{
                    ForEach(carriages) { carriage in
                        HStack{
                            Rectangle()
                                .frame(width: 20)
                                .foregroundColor(carriage.carriageType.locomotive != nil ? .textPrimary :.textSecondary)
                                .cornerRadius(10)
                            Coach(item: carriage)
                        }
                        .moveDisabled(carriage.carriageType.locomotive != nil)
                        .listRowSeparator(.hidden)
                    }.onMove(perform: move)
                    .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .listRowBackground(Color.appSecondary)
                }
                .scrollContentBackground(.hidden)
        }
         .navigationTitle("Composition")
            .environment(\.editMode, $editMode)
            .background(.appSecondary)
            .environment(\.defaultMinListRowHeight, 50)
     }
    
    func move(from source: IndexSet, to destination: Int) {
        print("from \(source)  to  \(destination)")
        carriages.move(fromOffsets: source, toOffset: destination)
        viewModel.changeComposition(newComposition: carriages,trainID: trainID)

        }
   
 }

#Preview {
    @State var carriages: [Carriage] = [Carriage(typeOfDesignation: "MODEL X", manufacturer: "BMW", year: "2024", maxPassengers: 100, trainLength: 100.0, curbWeight: 12.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: Locomotive(tractiveEffort: 100.0, type: .electric), wagon: nil)), Carriage(typeOfDesignation: "MODEL 234", manufacturer: "LG", year: "1998", maxPassengers: 100, trainLength: 100.0, curbWeight: 15.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .goods)))]
    @State var trainId: UUID = UUID()
        return StructureView( carriages: $carriages, trainID: $trainId)
}




