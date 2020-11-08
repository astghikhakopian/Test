//
//  GalleryItemModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/5/20.
//

struct GalleryItemModel: Codable {
    
    let title:          String?
    let thumbnailUrl:   String?
    let contentUrl:     String?
    
    init(from galleryItemRealmModel: GalleryItemRealmModel) {
        title = galleryItemRealmModel.title
        thumbnailUrl = galleryItemRealmModel.thumbnailUrl
        contentUrl = galleryItemRealmModel.contentUrl
    }
}
