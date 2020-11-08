//
//  NewsModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/5/20.
//

struct NewsModel: Codable {
    
    let category:       String?
    let title:          String?
    let body:           String?
    let shareUrl:       String?
    let coverPhotoUrl:  String?
    let date:           Double?
    let gallery:        [GalleryItemModel]?
    let video:          [VideoItemModel]?
    
    
    init(from newsRealmModel: NewsRealmModel) {
        category = newsRealmModel.category
        title = newsRealmModel.title
        body = newsRealmModel.body
        shareUrl = newsRealmModel.shareUrl
        coverPhotoUrl = newsRealmModel.coverPhotoUrl
        date = newsRealmModel.date
        gallery = newsRealmModel.gallery.map { GalleryItemModel(from: $0) }
        video = newsRealmModel.video.map { VideoItemModel(from: $0) }
    }
}
