//
//  Coach.swift
//  DemoTrain
//
//  Created by Athira Krishnan on 29.01.24.
//

import SwiftUI

struct Coach: View {
    var item : Carriage
    var body: some View {
        VStack{
            Spacer()
            HStack{
                if(item.carriageType.locomotive != nil){
                    let titleText = "\(item.carriageType.locomotive?.type.rawValue.capitalizingFirstLetter() ?? "") Locomotive"
                    Text("\(titleText)")
                        .foregroundColor(.textPrimary)
                        .font(.title3.bold())
                }else{
                    let titleText = "\(item.carriageType.wagon?.type.rawValue.capitalizingFirstLetter() ?? "") Wagon"
                    Text("\(titleText)")
                        .foregroundColor(.textPrimary)
                        .font(.title3.bold())
                }
                Spacer()
            }
            HStack{
                Text("Passenger Capacity \(item.maxPassengers)")
                    .foregroundColor(.textSecondary)
                    .font(.footnote)
                Spacer()
            }
            HStack{
                Text("Loading Capacity \(item.maxLoading)" as String)
                    .foregroundColor(.textSecondary)
                    .font(.footnote)
                Spacer()
            }
            Spacer()
        }.background(.appSecondary)
        .shadow(color:.appPrimary, radius: 10, x: 5, y: 5)
        .cornerRadius(20)
    }
}

/*
 #Preview {
 var item = Carriage(typeOfDesignation: "MODEL X", manufacturer: "BMW", year: "2024", maxPassengers: 100, trainLength: 100.0, curbWeight: 12.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: Locomotive(tractiveEffort: 100.0, type: .electric), wagon: nil))
 Coach(item: item)
 }
 */
