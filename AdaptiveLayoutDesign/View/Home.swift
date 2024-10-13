//
//  Home.swift
//  AdaptiveLayoutDesign
//
//  Created by Richard Uzor on 13/10/2024.
//

import SwiftUI

/// Tabs
enum TabState: String, CaseIterable{
    case home = "Home"
    case search = "Search"
    case notifications = "Notifications"
    case profile = "Profile"
    
    var symbolImage: String {
        switch self {
        case .home: "house"
        case .search: "magnifyingglass"
        case .notifications: "bell"
        case .profile: "person.crop.circle"
        }
    }
}

struct Home: View {
    /// View Properties
    @State private var activeTab: TabState = .home
    /// Gesture Properties
    @State private var offset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    @State private var progress: CGFloat = 0
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            let sideBarWidth: CGFloat = 250
            
            ZStack(alignment: .leading){
                
                SideBarView()
                    .frame(width: sideBarWidth)
                    .offset(x: -sideBarWidth)
                    .offset(x: offset)
                TabView(selection: $activeTab){
                    
                    Tab(TabState.home.rawValue, systemImage: TabState.home.symbolImage, value: .home){
                        Text("Home")
                    }
                    
                    Tab(TabState.search.rawValue, systemImage: TabState.search.symbolImage, value: .search){
                        Text("Search")
                    }
                    
                    Tab(TabState.notifications.rawValue, systemImage: TabState.notifications.symbolImage, value: .notifications){
                        Text("Notifications")
                    }
                    
                    Tab(TabState.profile.rawValue, systemImage: TabState.profile.symbolImage, value: .profile){
                        Text("Profile")
                    }
                }
                .overlay{
                    Rectangle()
                        .fill(.black.opacity(0.25))
                        .ignoresSafeArea()
                        .opacity(progress)
                }
                .offset(x: offset)
            }
            .gesture(
                CustomGesture{ gesture in
                    let state = gesture.state
                    let translation = gesture.translation(in: gesture.view).x + lastDragOffset
                    let velocity = gesture.velocity(in: gesture.view).x
                    
                    if state == .began || state == .changed {
                        /// onChanged
                        offset = max(min(translation, sideBarWidth), 0)
                        /// Storing Drag Progress, for fading tab view when dragging
                        progress = max(min(offset / sideBarWidth, 1), 0)
                    }else{
                        /// onEnded
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)){
                            
                            if(velocity + offset) > (sideBarWidth * 0.5) {
                                
                                /// Expand Fully
                                offset = sideBarWidth
                                progress = 1
                            }else{
                                /// Reset to zero
                                offset = 0
                                progress = 0
                            }
                            
                        }
                        /// Saving Last Drag Offset
                        lastDragOffset = offset
                    }
                    }
            )
        }
    }
}

struct SideBarView: View {
    var body: some View{
        ScrollView(.vertical){
            VStack(alignment: .leading, spacing: 6){
                
                Image(.luomy)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(.circle)
                
                Text("Luomy")
                    .font(.callout)
                    .fontWeight(.semibold)

                Text("@luomy")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                HStack(spacing: 4){
                    Text("3.1k")
                        .fontWeight(.semibold)
                    Text("Following")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text("1.8M")
                        .fontWeight(.semibold)
                        .padding(.leading, 5)
                    Text("Followers")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .font(.system(size:14))
                .lineLimit(1)
                .padding(.top, 5)
                
                /// Side Bar Navigation Items
                VStack(alignment: .leading, spacing: 20){
                    ForEach(SideBarAction.allCases, id: \.rawValue){action in
                        SideBarActionButton(value: action){
                            
                        }
                    }
                }
                .padding(.top, 25)
                
            }.padding(15)
            
        }
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func SideBarActionButton(value: SideBarAction, action: @escaping () -> ()) -> some View {
        Button(action: action){
            HStack(spacing: 12){
                Image(systemName: value.symbolImage)
                    .font(.title3)
                    .frame(width: 30)
                
                Text(value.rawValue)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
            }
            .foregroundStyle(Color.primary)
            .padding(.vertical, 10)
            .contentShape(.rect)
        }
    }
}

/// Side Bar Actions
enum SideBarAction: String, CaseIterable{
    case communities = "Communities"
    case bookmarks = "Bookmarks"
    case lists = "Lists"
    case messages = "Messages"
    case monetization = "Monetization"
    case settings = "Settings"
    
    var symbolImage: String{
        switch self{
        case .communities: "person.2"
        case .bookmarks: "bookmark"
        case .lists: "list.bullet.clipboard"
        case .messages: "message.badge.waveform"
        case .monetization: "banknote"
        case .settings: "gearshape"
        }
    }
    
}

/// Custom Gesture
struct CustomGesture: UIGestureRecognizerRepresentable{
    var handle: (UIPanGestureRecognizer) -> ()
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer{
        let gesture = UIPanGestureRecognizer()
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        handle(recognizer)
    }
}

#Preview {
    ContentView()
}
