//
//  HomeView.swift
//  Train
//
//  Created by Athira Krishnan on 26.01.24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel = HomeViewModel()
    var body: some View {
        NavigationStack {
        VStack {
            HStack{
                Spacer()
                Text("Tractive Effort: \(viewModel.tempTractiveEffort)" as String)
                    .font(.title3.bold())
                    .foregroundColor(viewModel.disableCreateButton ? Color(.error) : Color(.success))
                Spacer()
                Button("Create Train") {
                    viewModel.createTrain()
                }.disabled(viewModel.disableCreateButton)
                    .buttonStyle(.borderedProminent)
                    .padding(8)
                    .frame(width: 150,height: 30)
                    .foregroundColor(.appSecondary)
                
            }.padding(0)
            
           
            List {
                ForEach($viewModel.carriages) { $carriage in
                    CarriageRow(viewModel: viewModel, carriage: $carriage)
                        .listRowSeparator(.hidden)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                .listRowBackground(Color.appSecondary)
            }.navigationTitle("Carriages")
            .navigationBarTitleDisplayMode(.inline)
            .padding(0)
            .scrollContentBackground(.hidden)
            
            
            
        }.background(.appSecondary)
        .environment(\.defaultMinListRowHeight, 50)
        .task {
            viewModel.fetchCarriages()
                }
        .onDisappear{
            viewModel.onDisapper()
        }
        .padding(0)
    }
        
        
    }
}

#Preview {
    HomeView()
}
