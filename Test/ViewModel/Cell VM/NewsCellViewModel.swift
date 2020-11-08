//
//  NewsCellViewModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/5/20.
//

import Foundation

enum NewsCellType: Equatable {
    
    case normal(cellViewModel: NewsCellViewModel)
    case error(message: String)
    case empty
    
    var cellViewModel: NewsCellViewModel? {
        switch self {
        case let .normal(cellViewModel):    return cellViewModel
        default:                            return nil
        }
    }
    
    static func == (lhs: NewsCellType, rhs: NewsCellType) -> Bool {
        return lhs.cellViewModel?.id == rhs.cellViewModel?.id
    }
}


struct NewsCellViewModel: Equatable {
    
    let id:             String
    let model:          NewsModel
    var isRead:         Bool
    
    let categoryTitle:  String?
    let title:          String?
    let body:           NSAttributedString?
    let shareUrl:       URL?
    let coverPhotoUrl:  URL?
    let date:           Date?
    let gallery:        [GalleryItemModel]
    let video:          [VideoItemModel]

    
    // MARK: - Init
    
    init(model: NewsModel, isRead: Bool = false) {
        
        id = UUID().uuidString
        self.model = model
        self.isRead = isRead
        
        categoryTitle = model.category
        title = model.title
        
        // body
        if let bodyData = model.body?.data(using: .utf8) {
            body = try? NSAttributedString(data: bodyData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } else {
            body = nil
        }
        
        // shareUrl
        if let shareUrlString = model.shareUrl, let shareUrl = URL(string: shareUrlString) {
            self.shareUrl = shareUrl
        } else {
            self.shareUrl = nil
        }
        
        // coverPhotoUrl
        if let coverPhotoUrlString = model.coverPhotoUrl, let coverPhotoUrl = URL(string: coverPhotoUrlString) {
            self.coverPhotoUrl = coverPhotoUrl
        } else {
            self.coverPhotoUrl = nil
        }
        
        // date
        if let dateInt = model.date {
            self.date = Date(timeIntervalSince1970: dateInt)
        } else {
            self.date = nil
        }
        
        // gallery
        if let gallery = model.gallery {
            self.gallery = gallery
        } else {
            self.gallery = []
        }
        
        // video
        if let video = model.video {
            self.video = video
        } else {
            self.video = []
        }
    }
    
    static func == (lhs: NewsCellViewModel, rhs: NewsCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
