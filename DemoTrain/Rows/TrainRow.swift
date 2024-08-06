//
//  TrainRow.swift
//  DemoTrain
//
//  Created by Athira Krishnan on 26.01.24.
//

import SwiftUI


struct TrainRow: View {
    @Binding var train: Train
    var body: some View {
        VStack {
            HStack{
                Image(systemName:  "train.side.front.car")
                    .foregroundColor(.textPrimary)
                VStack(alignment: .leading){
                    Text("\(train.trainLength) meters long train weighing \(train.trainWeight) Tons" as String).font(.title3.bold())
                        .foregroundColor(.textPrimary)
                    Text("\(train.numberOfConductors) Conductors needed").font(.footnote)
                        .foregroundColor(.textSecondary)
                }
                Spacer()
            }
            
        }.background(.appSecondary)
        
    }
}

#Preview {
    @State var train: Train = Train(id: UUID(),carriages: [Carriage(typeOfDesignation: "MODEL X", manufacturer: "BMW", year: "2024", maxPassengers: 100, trainLength: 100.0, curbWeight: 12.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: Locomotive(tractiveEffort: 100.0, type: .electric), wagon: nil)), Carriage(typeOfDesignation: "MODEL 234", manufacturer: "LG", year: "1998", maxPassengers: 100, trainLength: 100.0, curbWeight: 15.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: nil, wagon: Wagon(type: .goods)))])
    return TrainRow(train: $train)
}

