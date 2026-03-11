//
//  SearchManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/25/25.
//

import Foundation
import Firebase
import AlgoliaSearchClient
import OSLog

class SearchManager: SearchManaging {
    
    private init() {
        getSearchKeys()
    }
    
    static let shared = SearchManager()
    
    var searchClient: SearchClient?
    let C_DEVSEARCHINDEX = "dev_search_index"
    let C_PRODSEARCHINDEX = "prod_search_index"
    
    func reloadClient() {
        if self.searchClient == nil {
            getSearchKeys()
        }
    }
    
    func getSearchKeys() {
        do {
            let appID: String = try AppConfiguration.value(for: "APPID")
            let apiKey: String = try AppConfiguration.value(for: "ALGOLIA_SEARCH_KEY")
            
            self.searchClient = SearchClient(appID: ApplicationID(rawValue: appID), apiKey: APIKey(rawValue: apiKey))
        }
        catch {
            Logger.search.error("Error getting Algolia API key: \(error.localizedDescription)")
        }
    }
    
    func performSearch(searchText: String) -> [AlgoliaSearchResult] {
        #if RELEASE
        if let client = searchClient {
            do {
                let index = client.index(withName: IndexName(rawValue: C_PRODSEARCHINDEX))
                let response = try index.search(query: Query(searchText))
                let results: [AlgoliaSearchResult] = try response.extractHits()
                return results
            }
            catch {
                Logger.search.error("Error performing search: \(error.localizedDescription)")
            }
        }
        #endif
        return .init()
    }
    
    func updateFirestoreSearchIndex(object: AlgoliaSearchResult) throws {
        #if RELEASE
        try FirebaseManager.shared.db.collection(C_PRODSEARCHINDEX).document(object.objectID).setData(from: object)
        #endif
    }
    
    func updateSearchIndex(objectID: String, objectType: SearchObjectType, name: String?, username: String?, venue: String?) throws {
        let searchResult = AlgoliaSearchResult(type: objectType, objectID: objectID, name: name, username: username, venue: venue)
        try self.updateFirestoreSearchIndex(object: searchResult)
    }
}

struct AlgoliaSearchResult: Codable {
    
    let type: SearchObjectType
    let objectID: String
    let name: String?
    let username: String?
    let venue: String?
    
}
