//
//  MainView.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/27/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
//            ContentView()
//                .tabItem {
//                    Label("Content", systemImage: "list.dash")
//                }

            ArtList()
                .tabItem {
                    Label("Art", systemImage: "person.crop.artframe")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
