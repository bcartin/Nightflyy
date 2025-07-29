//
//  AddressSearchViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/23/25.
//

import SwiftUI
import MapKit
import Combine

class AddressSearchViewModel: NSObject, ObservableObject {
    
    
    @Published var searchText: String = ""
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = .init()
    @Published var selectedAddress: String = ""
    private var searchCancellable: AnyCancellable?
    
    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    override init() {
        super.init()
                
        searchCancellable = $searchText
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] fragment in
                if !fragment.isEmpty {
                    self?.localSearchCompleter.queryFragment = fragment
                }
                else {
                    self?.searchResults = []
                }
            })
    }
    
    func selectAddress(result: MKLocalSearchCompletion) async {
        let request = MKLocalSearch.Request(completion: result)
        let response = try? await MKLocalSearch(request: request).start()
        let placemark = response?.mapItems.first?.placemark
        var address = placemark?.subThoroughfare ?? ""
        address += " " + (placemark?.thoroughfare ?? "")
        address += ", " + (placemark?.locality ?? "")
        address += ", " + (placemark?.administrativeArea ?? "")
        address += " " + (placemark?.postalCode ?? "")
        selectedAddress = address
    }
    
    func getSelectedAddress() -> String? {
        return selectedAddress
    }
}

extension AddressSearchViewModel: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            searchResults = completer.results
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        print(error)
    }
    
}
