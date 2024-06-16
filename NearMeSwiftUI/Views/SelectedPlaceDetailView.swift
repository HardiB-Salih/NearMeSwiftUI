//
//  SelectedPlaceDetailView.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import SwiftUI
import MapKit

struct SelectedPlaceDetailView: View {
    @Binding var mapItem : MKMapItem?
    let onClear: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading) {
                if let mapItem {
                    PlaceView(mapItem: mapItem)
                        .overlay(alignment: .topTrailing) {
                            Button(action: {
                                withAnimation {
                                    self.mapItem = nil
                                    onClear()
                                }
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .padding(5)
                                    .foregroundStyle(Color(.label))
                            })
                        }
                }
            }
        }
    }
}

#Preview {
    let apple = Binding<MKMapItem?>(
        get: {MKMapItem.placeholder},
        set: { _ in} )
    return SelectedPlaceDetailView(mapItem: apple, onClear: {})
}
