//
//  PlaceView.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import SwiftUI
import MapKit

struct PlaceView: View {
    let mapItem: MKMapItem
    
    var body: some View {
        VStack (alignment: .leading){
            Text(mapItem.name ?? "")
                .fontWeight(.semibold)
            Text(mapItem.address)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PlaceView(mapItem: .placeholder)
}
