//
//  Home.swift
//  AdaptiveLayoutDesign
//
//  Created by Richard Uzor on 13/10/2024.
//

import SwiftUI

struct Home: View {
    var body: some View {
        SideBarView()
            .frame(width: 250)
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

#Preview {
    ContentView()
}
