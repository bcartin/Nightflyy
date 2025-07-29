//
//  RouterView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/29/24.
//

import SwiftUI

struct RouterView<Content: View>: View {
    
    @Environment(Router.self) private var router
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }
        .tint(.white)
    }
}
