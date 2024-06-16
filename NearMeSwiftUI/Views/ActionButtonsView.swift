//
//  ActionButtonsView.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import SwiftUI
import MapKit

struct ActionButtonsView: View {
    let mapItem : MKMapItem
    
    var body: some View {
        HStack {
            
            if let phoneNumber = getNumericPhoneNumber(from: mapItem) {
                Button("Call", systemImage: "phone.fill") {
                    makeCall(to: phoneNumber)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(.systemGray5.withAlphaComponent(0.5)))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            Button("Take me there", systemImage: "car") { 
                MKMapItem.openMaps(with: [mapItem])
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color(.systemGreen.withAlphaComponent(0.5)))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Spacer()
        }
        .foregroundStyle(Color(.label))
        
    }
}

#Preview {
    ActionButtonsView(mapItem: .placeholder)
}
