//
//  NewsRealmModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/7/20.
//

import RealmSwift

class NewsRealmModel: Object {
    
    @objc dynamic var category:         String = ""
    @objc dynamic var title:            String = ""
    @objc dynamic var body:             String = ""
    @objc dynamic var shareUrl:         String = ""
    @objc dynamic var coverPhotoUrl:    String = ""
    @objc dynamic var date:             Double = 0
    
    var gallery =                       List<GalleryItemRealmModel>()
    var video =                         List<VideoItemRealmModel>()
    
    @objc  dynamic var realmId:         String = ""
    
    override static func primaryKey() -> String? {
        return "realmId"
    }
    
    convenience init(from newsModel: NewsModel) {
        self.init()
        
        category = newsModel.category ?? ""
        title = newsModel.title ?? ""
        body = newsModel.body ?? ""
        shareUrl = newsModel.shareUrl ?? ""
        coverPhotoUrl = newsModel.coverPhotoUrl ?? ""
        date = newsModel.date ?? 0
        
        if let newsModelGallery = newsModel.gallery, !newsModelGallery.isEmpty {
            let newsModelGalleryRealm = newsModelGallery.map { GalleryItemRealmModel(from: $0) }
            gallery.append(objectsIn: newsModelGalleryRealm)
        }
        if let newsModelVideo = newsModel.video, !newsModelVideo.isEmpty {
            let newsModelVideoRealm = newsModelVideo.map { VideoItemRealmModel(from: $0) }
            video.append(objectsIn: newsModelVideoRealm)
        }
        
        realmId = "\(title)\(date)"
    }
}
