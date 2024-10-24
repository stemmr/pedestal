//
//  TabView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

struct SwitchView: View {
    var body: some View {
        TabView {
            // First Tab - Received
            Text("World")
                .tabItem {
                    Image(systemName: "globe.desk")
                    Text("Explore")
                }

            // Second Tab - Sent
            Text("Hello")
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Sent")
                }

            // Third Tab - Account
            Text("Practice")
                .tabItem {
                    Image(systemName: "book")
                    Text("Practice")
                }
        }
    }
}
struct SwitchView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchView()
    }
}
