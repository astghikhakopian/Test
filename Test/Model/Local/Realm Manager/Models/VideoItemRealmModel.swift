//
//  VideoItemRealmModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/7/20.
//

import RealmSwift

class VideoItemRealmModel: Object {
    
    @objc dynamic var title:            String = ""
    @objc dynamic var thumbnailUrl:     String = ""
    @objc dynamic var youtubeId:        String = ""
    
    convenience init(from videoItemModel: VideoItemModel) {
        self.init()
        
        title = videoItemModel.title ?? ""
        thumbnailUrl = videoItemModel.thumbnailUrl ?? ""
        youtubeId = videoItemModel.youtubeId ?? ""
    }
}

