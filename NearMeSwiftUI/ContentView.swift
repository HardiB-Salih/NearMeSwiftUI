//
//  ContentView.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/15/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var query: String = "Coffee"
    @State private var selectedDetents: PresentationDetent = .fraction(0.15)
    @State private var locationManager = LocationManager.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isSearching: Bool = false
    @State private var mapItems: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion?
    

    private func search() async {
        do {
            mapItems = try await performSearch(searchTerm: query, visibleRegion: visibleRegion)
            print(mapItems[0])
            isSearching = false
        } catch {
            mapItems = []
            print(error.localizedDescription)
            isSearching = false
        }
    }
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                ForEach(mapItems, id: \.self) { mapItem in
                    Marker(item: mapItem)
                }
                
                UserAnnotation()
            }
            .onChange(of: locationManager.region, {
                position = .region(locationManager.region)
            })
            .sheet(isPresented: .constant(true), content: {
                VStack {
                    TextField("Search", text: $query)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color(.systemGray5), lineWidth: 1.0)
                        }
                        .padding()
                        .onSubmit { isSearching = true }
                    
                    List(mapItems, id: \.self) { mapItem in
                        PlaceView(mapItem: mapItem)
                    }
                    
                    Spacer()
                    
                    
                }
                //MARK: Stick the Sheet in the bottom of the screen.
                .presentationDetents([.fraction(0.15), .medium, .large], selection: $selectedDetents)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            })
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .task(id: isSearching, {
            if isSearching {
                await search()
            }
        })
        
    }
}

#Preview {
    ContentView()
}
