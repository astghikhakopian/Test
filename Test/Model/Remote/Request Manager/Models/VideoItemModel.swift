//
//  VideoItemModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/6/20.
//

struct VideoItemModel: Codable {
    
    let title:          String?
    let thumbnailUrl:   String?
    let youtubeId:     String?
    
    init(from videoItemRealmModel: VideoItemRealmModel) {
        title = videoItemRealmModel.title
        thumbnailUrl = videoItemRealmModel.thumbnailUrl
        youtubeId = videoItemRealmModel.youtubeId
    }
}
