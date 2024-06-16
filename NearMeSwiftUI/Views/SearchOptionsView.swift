//
//  SearchOptionsView.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import SwiftUI

// Step 1: Define the SearchOption enum
enum SearchOption: Int, CaseIterable, Identifiable {
    case restaurants
    case parks
    case hotels
    case gasStations
    
    var id: Int { return self.rawValue }

    // Step 2: Add title and SFIcon properties
    var title: String {
        switch self {
        case .restaurants: return "Restaurants"
        case .parks: return "Parks"
        case .hotels: return "Hotels"
        case .gasStations: return "Gas Stations"
        }
    }

    var sfIcon: String {
        switch self {
        case .restaurants: return "fork.knife"
        case .parks: return "leaf"
        case .hotels: return "bed.double"
        case .gasStations: return "fuelpump"
        }
    }
    
    var color: UIColor {
        switch self {
        case .restaurants: return .systemOrange.withAlphaComponent(0.2)
        case .parks: return .systemGreen.withAlphaComponent(0.2)
        case .hotels: return .systemPurple.withAlphaComponent(0.2)
        case .gasStations: return .systemBlue.withAlphaComponent(0.2)
        }
    }
}

struct SearchOptionsView: View {
    let onSelected: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(SearchOption.allCases) { searchOption in
                    Button(action: { onSelected(searchOption.title) }, label: {
                        HStack (spacing: 12){
                            Image(systemName: searchOption.sfIcon)
                            Text(searchOption.title)
                        }
                        .foregroundStyle(Color(.label))
                        .padding(8)
                        .background(Color(searchOption.color))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color(.systemGray5), lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                        }
                        
                    })
                }
            }
            
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SearchOptionsView(onSelected: { _ in })
}
