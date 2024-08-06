//
//  CarriageRow.swift
//  Train
//
//  Created by Athira Krishnan on 26.01.24.
//

import SwiftUI

struct CarriageRow: View {
    var viewModel : HomeViewModel!
    @Binding var carriage: Carriage

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                Text((carriage.carriageType.locomotive != nil) ? "Locomotive":"Wagon").font(.body)
                    .foregroundColor(.textPrimary)
                let engineType = carriage.carriageType.locomotive?.type.rawValue.capitalizingFirstLetter()
                
                let wagonType = carriage.carriageType.wagon?.type.rawValue.capitalizingFirstLetter()
                Text(((carriage.carriageType.locomotive != nil) ? engineType:wagonType)!).font(.title3.bold())
                    .foregroundColor(.textSecondary)
                
                HStack{
                    Text(carriage.manufacturer).font(.footnote)
                        .foregroundColor(.textPrimary)
                    Text(carriage.year).font(.footnote)
                        .foregroundColor(.textPrimary)
                }
                Spacer()
               
            }.padding(.leading)
            .background(.clear)
            Spacer()
            VStack(alignment: .trailing) {
                Image(systemName: carriage.isSelected ? "checkmark.square" : "square")
                    .onTapGesture {
                        carriage.isSelected.toggle()
                        viewModel.carriageSelected(selectedCarriage: carriage)
                    }
                    .foregroundColor(.textSecondary)
               
                HStack{
                    Text("\(carriage.maxPassengers)").font(.body)
                    Image(systemName: "carseat.right.fill")
                        .font(.footnote)
                        .foregroundColor(.textPrimary)
                    
                }
                HStack{
                    Text("\(carriage.maxLoading)" as String).font(.body)
                    Image(systemName: "scalemass.fill")
                        .font(.body)
                        .foregroundColor(.textPrimary)
                    
                }
                
                
            }.padding(.trailing)
            .background(.clear)


        }.background(carriage.isSelected ? .appPrimary : .appSecondary)
        .cornerRadius(10)
        
    }
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
            
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        })
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

#Preview {
    @State var carriage: Carriage = Carriage(typeOfDesignation: "MODEL X", manufacturer: "BMW", year: "2024", maxPassengers: 100, trainLength: 100.0, curbWeight: 12.0, maxLoading: 2.0, carriageType: CarriageType(locomotive: Locomotive(tractiveEffort: 100.0, type: .electric), wagon: nil))
        return CarriageRow(carriage: $carriage)
       
}

