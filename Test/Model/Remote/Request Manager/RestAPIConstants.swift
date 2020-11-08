//
//  RestAPIConstants.swift
//  Test
//
//  Created by Astghik Hakopian on 11/5/20.
//

struct RestAPIConstants {
    
    // MARK: - Protocol
    
    static let newsBaseProtocol             = "https://"
    
    
    // MARK: - Hostname
    
    static let newsHostName                 = "www.helix.am"
    
    
    // MARK: - Port
    
    static let newsPort                     = ""                    // ex. ":8080"
    
    
    // MARK: - Version
    
    static let newsVersion                  = ""                    // ex. "/api/v1"
    
    
    // MARK: - Full
    
    static let newsFullUrl                  = newsBaseProtocol      + newsHostName      + newsPort      + newsVersion       + "/temp/json.php"
    
    
    // MARK: - News
    
    struct News {
        
        static let getNewsList              = newsFullUrl
    }
}
