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
    @State private var panGesture: UIPanGestureRecognizer?
    
    /// Navigation Path
    @State private var navigationPath: NavigationPath = .init()
    
    var body: some View {
        AdaptiveView{ size, isLandscape in
            
            let sideBarWidth: CGFloat = isLandscape ? 220 : 250
            let layout = isLandscape ?
            AnyLayout(HStackLayout(spacing: 0)) :
            AnyLayout(ZStackLayout(alignment: .leading))
            
            NavigationStack(path: $navigationPath){
            layout{
                
                SideBarView(path: $navigationPath){
                    toggleSideBar()
                }
                    .frame(width: sideBarWidth)
                    .offset(x: isLandscape ? 0 : -sideBarWidth)
                    .offset(x: isLandscape ? 0 : offset)
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
                .tabViewStyle(.tabBarOnly)
                .overlay{
                    Rectangle()
                        .fill(.black.opacity(0.25))
                        .ignoresSafeArea()
                        .opacity(isLandscape ? 0 : progress)
                }
                .offset(x: isLandscape ? 0 : offset)
            }
            .gesture(
                CustomGesture(isEnabled: !isLandscape){ gesture in
                    if panGesture == nil { panGesture = gesture }
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
            .onChange(of: isLandscape) { oldValue, newValue in
                panGesture?.isEnabled = !newValue
            }
            .navigationDestination(for: String.self){ value in
                Text("Hello, This is Detail \(value) View")
                    .navigationTitle(value)
                
            }
        }
        }
        
    }
    
    func toggleSideBar(){
        withAnimation(.snappy(duration: 0.25, extraBounce: 0)){
            progress = 0
            offset = 0
            lastDragOffset = 0
        }
    }
}

struct SideBarView: View {
    @Binding var path: NavigationPath
    var toggleSideBar: () -> ()
    var body: some View{
        GeometryReader{
            let safeArea = $0.safeAreaInsets
            let isSidesHavingValues = safeArea.leading != 0 || safeArea.trailing != 0
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
                            toggleSideBar()
                            /// You can even pass the entire action here (by conforming it as a Hashable) and push views based on it, but we just pass the rawValue (String) and using it as a navigation title for now
                            path.append(action.rawValue)
                        }
                    }
                }
                .padding(.top, 25)
                
            }
            .padding(.vertical, 15)
            .padding(.horizontal, isSidesHavingValues ? 5 : 15)
            
        }
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .background{
            Rectangle()
                .fill(.background)
                .overlay(alignment: .trailing) {
                    Rectangle()
                        .fill(.gray.opacity(0.35))
                        .frame(width: 1)
                }
                .ignoresSafeArea()
        }
    }
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
    var isEnabled: Bool
    var handle: (UIPanGestureRecognizer) -> ()
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer{
        let gesture = UIPanGestureRecognizer()
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        recognizer.isEnabled = isEnabled
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        handle(recognizer)
    }
}

/// Adaptive View
struct AdaptiveView<Content: View>: View {
    var showSideBarOniPadPotrait: Bool = true
    @ViewBuilder var content: (CGSize, Bool) -> Content
    @Environment(\.horizontalSizeClass) private var hClass
    var body: some View {
        GeometryReader{
            let size = $0.size
            let isLandscape = size.width > size.height || (hClass == .regular && showSideBarOniPadPotrait)
            
            content(size, isLandscape)
        }
    }
}

#Preview {
    ContentView()
}
