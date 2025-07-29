//
//  ContactRequest.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/26/25.
//

import Foundation

class ContactRequest {
    
    var body: ContactRequestBody
    var httpRequest: URLRequest
    
    init?(body: ContactRequestBody) {
        self.body = body
        guard let url = NetworkHelper.BuildApiUrl(base: "SENDGRID_BASEURL", endPoint: "/v3/marketing/contacts") else {
            return nil
        }
        self.httpRequest = URLRequest(url: url)
        
        httpRequest.httpMethod = "PUT"
        
        guard let data =  try? JSONEncoder().encode(body) else {
            return nil
        }
        
        httpRequest.httpBody = data
        
        guard let apiKey: String = try? AppConfiguration.value(for: "SENDGRID_KEY") else { return nil }
        
        httpRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
