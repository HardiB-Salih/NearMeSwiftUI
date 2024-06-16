//
//  ContentView.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/15/24.
//

import SwiftUI
import MapKit

enum DisplayMode {
    case list
    case detail
}


struct ContentView: View {
    @State private var query: String = ""
    @State private var selectedDetents: PresentationDetent = .fraction(0.15)
    @State private var locationManager = LocationManager.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isSearching: Bool = false
    @State private var mapItems: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var selectedMapItem: MKMapItem?
    @State private var displayMode : DisplayMode = .list
    @State private var lookaroundScene: MKLookAroundScene?
    @State private var route: MKRoute?
    
    
    private func requestCalculateDirections() async {
        route = nil
        if let selectedMapItem {
            guard let currentUserLocation = locationManager.manager.location else { return }
            let startingMapItem = MKMapItem(placemark: MKPlacemark(coordinate: currentUserLocation.coordinate))
            self.route = await calculateDirections(from: startingMapItem, to: selectedMapItem)
        }
    }
    

    private func search() async {
        do {
            mapItems = try await performSearch(searchTerm: query, visibleRegion: visibleRegion)
//            print(mapItems[0])
            isSearching = false
        } catch {
            mapItems = []
            print(error.localizedDescription)
            isSearching = false
        }
    }
    
    var body: some View {
        ZStack {
            Map(position: $position, selection: $selectedMapItem) {
                ForEach(mapItems, id: \.self) { mapItem in
                    Marker(item: mapItem)
                }
                
                if let route {
                    MapPolyline(route)
                        .stroke(Color.red, lineWidth: 5)
                }
                
                UserAnnotation()
            }
            .onChange(of: locationManager.region, {
                position = .region(locationManager.region)
            })
            .sheet(isPresented: .constant(true), content: {
                VStack {
                    switch displayMode {
                    case .list:
                        searchAndList
                    case .detail:
                        SelectedPlaceDetailView(mapItem: $selectedMapItem) { route = nil }
                            .padding(.horizontal)
                        if selectedDetents == .medium || selectedDetents == .large {
                            if let selectedMapItem {
                                ActionButtonsView(mapItem: selectedMapItem)
                                    .padding(.horizontal)
                            }
                            LookAroundPreview(initialScene: lookaroundScene)
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                                .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
                .padding(.top, 20)
                //MARK: Stick the Sheet in the bottom of the screen.
                .presentationDetents([.fraction(0.15), .medium, .large], selection: $selectedDetents)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            })
        }
        .onChange(of: selectedMapItem) {
            if selectedMapItem != nil {
                
                displayMode = .detail
            } else {
                displayMode = .list
            }
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .task(id: selectedMapItem) {
            lookaroundScene = nil
            if let selectedMapItem {
                let request = MKLookAroundSceneRequest(mapItem: selectedMapItem)
                lookaroundScene = try? await request.scene
                await requestCalculateDirections()
            }
        }
        .task(id: isSearching, {
            if isSearching {
                await search()
            }
        })
        
    }
    
    var searchAndList: some View {
        VStack {
            SearchBarView(search: $query, isSearching: $isSearching) {
                withAnimation {
                    selectedDetents = .fraction(0.15)
                    query = ""
                    isSearching = false
                    mapItems.removeAll()
                   
                    
                }
            }
            PlaceListView(mapItems: mapItems, selectedMapItem: $selectedMapItem)
        }
    }
}

#Preview {
    ContentView()
}
