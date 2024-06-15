//
//  MapUtilities.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/15/24.
//

import Foundation
import MapKit
import Contacts

/**
 Performs a local search for points of interest within a specified region.

 - Parameters:
    - searchTerm: The search term used to query points of interest.
    - visibleRegion: The region within which to search for points of interest.

 - Returns: An array of `MKMapItem` objects representing the search results.

 - Throws: An error if the search request fails.

 - Note: If `visibleRegion` is `nil`, the function returns an empty array.
*/
func performSearch(
    searchTerm: String,
    visibleRegion: MKCoordinateRegion?
) async throws -> [MKMapItem] {
    
    // Create a search request
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchTerm
    request.resultTypes = .pointOfInterest
    
    // Ensure the region is provided, else return an empty array
    guard let region = visibleRegion else { return [] }
    request.region = region
    
    // Perform the search
    let search = MKLocalSearch(request: request)
    let response = try await search.start()
    
    // Return the search results
    return response.mapItems
}


/**
 Returns an `MKMapItem` with a specified coordinate and address details.

 - Parameters:
    - latitude: The latitude of the coordinate.
    - longitude: The longitude of the coordinate.
    - name: The name of the location.
    - street: The street address of the location.
    - city: The city of the location.
    - state: The state of the location.
    - zip: The postal code of the location.
    - country: The country of the location.

 - Returns: An `MKMapItem` object with the provided details.
*/
func createMapItem(
    latitude: CLLocationDegrees,
    longitude: CLLocationDegrees,
    name: String,
    street: String,
    city: String,
    state: String,
    zip: String,
    country: String
) -> MKMapItem {
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let addressDict: [String: Any] = [
        CNPostalAddressStreetKey: street,
        CNPostalAddressCityKey: city,
        CNPostalAddressStateKey: state,
        CNPostalAddressPostalCodeKey: zip,
        CNPostalAddressCountryKey: country
    ]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = name
    return mapItem
}
