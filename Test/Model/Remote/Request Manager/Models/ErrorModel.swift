//
//  ErrorModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/5/20.
//

// TODO: - Correct with backend

struct ErrorModel: Codable {
    
    let status:     Int
    let message:    String?
    let code:       String?
    let type:       String?
}
