//
//  SearchManaging.swift
//  Nightflyy
//

import Foundation

protocol SearchManaging {
    func reloadClient()
    func performSearch(searchText: String) -> [AlgoliaSearchResult]
    func updateSearchIndex(objectID: String, objectType: SearchObjectType, name: String?, username: String?, venue: String?) throws
}
