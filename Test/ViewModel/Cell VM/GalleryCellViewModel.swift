//
//  GalleryCellViewModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/7/20.
//

import Foundation

enum GalleryCellType {
    
    case photo(cellViewModel: PhotoCellViewModel)
    case video(cellViewModel: VideoCellViewModel)
    case error(message: String)
    case empty
    
    var photoCellViewModel: PhotoCellViewModel? {
        switch self {
        case let .photo(cellViewModel):    return cellViewModel
        default:                            return nil
        }
    }
    
    var videoCellViewModel: VideoCellViewModel? {
        switch self {
        case let .video(cellViewModel):    return cellViewModel
        default:                            return nil
        }
    }
}


struct PhotoCellViewModel {
    
    let id:             String
    let model:          GalleryItemModel
    
    let title:          String?
    let thumbnailUrl:   URL?
    let contentUrl:     URL?

    
    // MARK: - Init
    
    init(model: GalleryItemModel) {
        
        id = UUID().uuidString
        self.model = model
        
        title = model.title
     
        // thumbnailUrl
        if let thumbnailUrlString = model.thumbnailUrl, let thumbnailUrl = URL(string: thumbnailUrlString) {
            self.thumbnailUrl = thumbnailUrl
        } else {
            self.thumbnailUrl = nil
        }
        
        // contentUrl
        if let contentUrlString = model.contentUrl, let contentUrl = URL(string: contentUrlString) {
            self.contentUrl = contentUrl
        } else {
            self.contentUrl = nil
        }
    }
}

struct VideoCellViewModel {
    
    let id:             String
    let model:          VideoItemModel
    
    let title:          String?
    let thumbnailUrl:   URL?
    let youtubeId:      String?

    
    // MARK: - Init
    
    init(model: VideoItemModel) {
        
        id = UUID().uuidString
        self.model = model
        
        title = model.title
        youtubeId = model.youtubeId
     
        // thumbnailUrl
        if let thumbnailUrlString = model.thumbnailUrl, let thumbnailUrl = URL(string: thumbnailUrlString) {
            self.thumbnailUrl = thumbnailUrl
        } else {
            self.thumbnailUrl = nil
        }
    }
}
