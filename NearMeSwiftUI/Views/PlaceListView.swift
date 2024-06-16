//
//  PlaceListView.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import SwiftUI
import MapKit

struct PlaceListView: View {
    let mapItems: [MKMapItem]
    @Binding var selectedMapItem: MKMapItem?
    
    private var sortedItems: [MKMapItem] {
        sortMapItemsByDistance(mapItems: mapItems, order: .ascending)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(sortedItems, id: \.self) { mapItem in
                    PlaceView(mapItem: mapItem)
                        .onTapGesture {
                            selectedMapItem = mapItem
                        }
                        .padding(.horizontal)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    let apple = Binding<MKMapItem?>(get: {.placeholder}, set: { _ in })
    return PlaceListView(mapItems: [.placeholder], selectedMapItem: apple)
}
