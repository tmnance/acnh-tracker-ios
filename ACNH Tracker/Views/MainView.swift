//
//  MainView.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/27/21.
//

import SwiftUI

struct MainView: View {
    private enum Tab: Hashable {
        case insects
        case art
    }

    @State private var tabSelection: Tab = .insects
    @State private var tappedTwice: Bool = false
    private var tabSelectionHandler: Binding<Tab> {
        Binding(
            get: { self.tabSelection },
            set: {
                if $0 == self.tabSelection { // user tapped more than once
                    tappedTwice = true
                }
                self.tabSelection = $0
            }
        )
    }

    var body: some View {
        ScrollViewReader { proxy in
            TabView(selection: tabSelectionHandler) {
                InsectListView()
                    .onChange(of: tappedTwice) { tapped in
                        if tapped && tabSelection == Tab.insects {
                            scrollToTop(proxy: proxy, scrollId: InsectListView.scrollTopId)
                        }
                    }
                    .tabItem {
                        Label("Insects", systemImage: "ladybug")
                    }
                    .tag(Tab.insects)

                ArtListView()
                    .onChange(of: tappedTwice) { tapped in
                        if tapped && tabSelection == Tab.art {
                            scrollToTop(proxy: proxy, scrollId: ArtListView.scrollTopId)
                        }
                    }
                    .tabItem {
                        Label("Art", systemImage: "person.crop.artframe")
                    }
                    .tag(Tab.art)
            }
            .accentColor(.purple)
            .preferredColorScheme(.light)
        }
    }

    func scrollToTop(proxy: ScrollViewProxy, scrollId: UUID) {
        withAnimation {
            proxy.scrollTo(scrollId, anchor: .top)
        }
        tappedTwice = false
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
