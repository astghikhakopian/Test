//
//  ResponseModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/6/20.
//

struct NewsResponseModel: Codable {
    
    let success:        Bool
    let errors:         [ErrorModel]    // TODO: - Correct type with backend
    let internalErrors: [ErrorModel]    // TODO: - Correct type with backend
    let metadata:       [NewsModel]?
    
    enum CodingKeys: String, CodingKey {
        case internalErrors = "internal_errors"
        case success, errors, metadata
    }
}

