//
//  ContentView.swift
//  Train
//
//  Created by Athira Krishnan on 26.01.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Carriages", systemImage: "list.dash")
                }
                .toolbarBackground(
                    Color.appSecondary,
                    for: .tabBar)
            TrainView()
                .tabItem {
                    Label("Trains", systemImage: "train.side.front.car")
                }
                .toolbarBackground(
                    Color.appSecondary,
                    for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
}
