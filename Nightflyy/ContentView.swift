//
//  ContentView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/21/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State var presentOverlay = true
    @State private var showMenu: Bool = false
    @State private var selection = 0 // Home is default
    @State private var expandSheet: Bool = false
    @Namespace private var animation
    @State var menuViewModel = SideBarMenuViewModel()
    @Environment(ToastsManager.self) private var toastsManager
    
    var body: some View {
        @Bindable var toastsManager = toastsManager
 
            AnimatedSideBar(showMenu: $showMenu)
            { safeArea in
                TabView(selection: $selection) {
                    Tab("", image: "ic_home", value: 0) {
                        HomeView(showMenu: $showMenu, viewModel: HomeViewModel())
                            .toolbarVisibility(Router.shared.path.isEmpty ? .visible : .hidden, for: .tabBar)
                    }
                    Tab("", image: "ic_search", value: 1) {
                        DiscoverView(showMenu: $showMenu, viewModel: DiscoverViewModel())
                            .toolbarVisibility(Router.shared.path.isEmpty ? .visible : .hidden, for: .tabBar)
                    }
                    Tab("", image: "ic_hub", value: 2) {
                        HubView(showMenu: $showMenu, viewModel: HubViewModel())
                            .toolbarVisibility(Router.shared.path.isEmpty ? .visible : .hidden, for: .tabBar)
                    }
                    Tab("", image: "ic_bell", value: 3) {
                        NotificationsView(showMenu: $showMenu, viewModel: NotificationsViewModel())
                            .toolbarVisibility(Router.shared.path.isEmpty ? .visible : .hidden, for: .tabBar)
                    }
                    Tab("", image: "ic_message", value: 4) {
                        InboxView(showMenu: $showMenu, viewModel: InboxViewModel())
                            .toolbarVisibility(Router.shared.path.isEmpty ? .visible : .hidden, for: .tabBar)
                    }
                }
                .accentColor(.mainPurple)
                .environment(\.colorScheme, .dark)
                .task {
                    do {
                        try PushNotificationsManager.shared.requestPermission()
                        LocationManager.shared.askPermission()
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            
            } menuView: { safeArea in
                SideBarMenuView(showMenu: $showMenu, safeArea: safeArea, viewModel: $menuViewModel)
            }
            .sheet(isPresented: $menuViewModel.presentSheet, content: {
                menuViewModel.selectedMenuItem.associatedView
            })
            .interactiveToast($toastsManager.toasts)
    }

}

//#Preview {
//    ContentView()
//        .preferredColorScheme(.dark)
//}



