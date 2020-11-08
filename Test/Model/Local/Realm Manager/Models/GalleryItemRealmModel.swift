//
//  GalleryItemRealmModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/7/20.
//

import RealmSwift

class GalleryItemRealmModel: Object {
    
    @objc dynamic var title:            String = ""
    @objc dynamic var thumbnailUrl:     String = ""
    @objc dynamic var contentUrl:       String = ""
    
    convenience init(from galleryItemModel: GalleryItemModel) {
        self.init()
        
        title = galleryItemModel.title ?? ""
        thumbnailUrl = galleryItemModel.thumbnailUrl ?? ""
        contentUrl = galleryItemModel.contentUrl ?? ""
    }
}
