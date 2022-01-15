//
//  MainView.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/27/21.
//

import SwiftUI

struct MainView: View {
    @State private var tabSelection = 0
    @State private var tappedTwice: Bool = false

    var handler: Binding<Int> {
        Binding(
            get: { self.tabSelection },
            set: {
                if $0 == self.tabSelection { // Lands here if user tapped more than once
                    tappedTwice = true
                }
                print("self.tabSelection = \(self.tabSelection)")
                print("tappedTwice = \(self.tappedTwice)")
                self.tabSelection = $0
            }
        )
    }

    func scrollToTop(proxy: ScrollViewProxy, scrollId: UUID) {
        print("scrollToTop! tabSelection=\(tabSelection), scrollId=\(scrollId)")
        withAnimation {
            proxy.scrollTo(scrollId, anchor: .top)
        }
        tappedTwice = false
    }

    var body: some View {
        ScrollViewReader { proxy in
            TabView(selection: handler) {
                InsectList()
                    .onChange(of: tappedTwice) { tapped in
                        if tapped && tabSelection == 0 {
                            scrollToTop(proxy: proxy, scrollId: InsectList.scrollTopId)
                        }
                    }
                    .tabItem {
                        Label("Insects", systemImage: "ladybug")
                    }
                    .tag(0)

                ArtList()
                    .onChange(of: tappedTwice) { tapped in
                        if tapped && tabSelection == 1 {
                            scrollToTop(proxy: proxy, scrollId: ArtList.scrollTopId)
                        }
                    }
                    .tabItem {
                        Label("Art", systemImage: "person.crop.artframe")
                    }
                    .tag(1)
            }
            .accentColor(.purple)
            .preferredColorScheme(.light)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
