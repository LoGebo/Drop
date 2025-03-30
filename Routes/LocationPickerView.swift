//
//  LocationPickerView.swift
//  Drop
//
//  Created by Dario on 30/03/25.
//

import SwiftUI
import MapKit

class SearchCompleterWrapper: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var results: [MKLocalSearchCompletion] = []
    private let completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = .pointOfInterest
    }
    
    func search(with query: String) {
        completer.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error getting search results: \(error.localizedDescription)")
    }
}

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLocation: CLLocation?
    @State private var position: MapCameraPosition
    @State private var pinLocation: CLLocationCoordinate2D
    @State private var searchText = ""
    @State private var showSearchResults = false
    @StateObject private var searchCompleter = SearchCompleterWrapper()
    
    init(selectedLocation: Binding<CLLocation?>, initialLocation: CLLocation?) {
        _selectedLocation = selectedLocation
        let initialCoordinate = initialLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 25.6694, longitude: -100.3098)
        _position = State(initialValue: .region(MKCoordinateRegion(
            center: initialCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
        _pinLocation = State(initialValue: initialCoordinate)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Map(position: $position) {
                    Marker("Selected Location", coordinate: pinLocation)
                        .tint(.red)
                }
                .ignoresSafeArea(edges: .bottom)
                .mapStyle(.standard)
                .onMapCameraChange { context in
                    pinLocation = context.region.center
                }
                
                // Search bar and results
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search location", text: $searchText)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled()
                            .onChange(of: searchText) { newValue in
                                if newValue.isEmpty {
                                    showSearchResults = false
                                } else {
                                    searchCompleter.search(with: newValue)
                                    showSearchResults = true
                                }
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                showSearchResults = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(10)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
                    
                    if showSearchResults && !searchCompleter.results.isEmpty {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(searchCompleter.results, id: \.self) { result in
                                    Button(action: {
                                        Task {
                                            await selectSearchResult(result)
                                        }
                                    }) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(result.title)
                                                .foregroundColor(.primary)
                                                .font(.body)
                                            Text(result.subtitle)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.vertical, 8)
                                    }
                                    Divider()
                                }
                            }
                            .padding(.horizontal)
                        }
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(maxHeight: 300)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Set Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Confirm") {
                        selectedLocation = CLLocation(
                            latitude: pinLocation.latitude,
                            longitude: pinLocation.longitude
                        )
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
    
    private func selectSearchResult(_ result: MKLocalSearchCompletion) async {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        
        do {
            let response = try await search.start()
            if let item = response.mapItems.first {
                withAnimation {
                    position = .region(MKCoordinateRegion(
                        center: item.placemark.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                    pinLocation = item.placemark.coordinate
                }
                searchText = result.title
                showSearchResults = false
            }
        } catch {
            print("Error searching location: \(error.localizedDescription)")
        }
    }
}

#Preview {
    LocationPickerView(
        selectedLocation: .constant(nil),
        initialLocation: CLLocation(latitude: 25.6694, longitude: -100.3098)
    )
}
