//
//  TrainView.swift
//  Train
//
//  Created by Athira Krishnan on 26.01.24.
//

import SwiftUI

struct TrainView: View {
    @ObservedObject private var viewModel = TrainViewModel()
    init() {
            UITableView.appearance().backgroundColor = .appSecondary
        }

    var body: some View {
      
        NavigationStack {
            HStack{
                List($viewModel.trains) { $train in
                    NavigationLink() {
                                //StructureView(carriages: $train.carriages,trainID: $train.id)
                        TestView(carriages: $train.carriages,trainID: $train.id)
                            
                            }label: {
                                TrainRow(train: $train)
                            }.listRowBackground(Color.appSecondary)

                        }
                        .listStyle(.plain)
                        .navigationTitle("Trains")
                        .background(.appSecondary)
                        .scrollContentBackground(.hidden)
            }
           
        }.task {
            viewModel.getData()
        }
        .environment(viewModel)
        .navigationBarTitleDisplayMode(.inline)
        .background(.appSecondary)
    }
}

#Preview {
    TrainView()
}


