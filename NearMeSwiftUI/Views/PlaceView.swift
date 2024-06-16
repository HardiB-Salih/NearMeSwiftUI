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
    
    private var distance: Measurement<UnitLength>? {
        guard let userLocation = LocationManager.shared.manager.location,
              let distnationLocation = mapItem.placemark.location else { return nil }
        
        return calculateDistance(from: userLocation, to: distnationLocation)
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 6){
            Text(mapItem.name ?? "")
                .font(.headline)
            Text(mapItem.address)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let distance = distance {
                Text(distance, formatter: MeasurementFormatter.distance)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay{
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1.0)
        }
    }
}

#Preview {
    ScrollView {
        PlaceView(mapItem: .placeholder)
    }.background(Color(.secondarySystemBackground))
}
