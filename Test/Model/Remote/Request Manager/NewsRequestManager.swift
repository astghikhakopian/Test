//
//  NewsRequestManager.swift
//  Test
//
//  Created by Astghik Hakopian on 11/5/20.
//

import Alamofire
import RxSwift

class NewsRequestManager {

    enum GetTracksFailureReason: String, Error {
        
        case unknown    = "UNKNOWN"
        case unparsable = "UNPARSABLE"
    }

    // MARK: - News

    func getNewsList() -> Observable<[NewsModel]> {

        let url = RestAPIConstants.News.getNewsList

        return Observable.create { observer -> Disposable in

            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let resultData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let result = try JSONDecoder().decode(NewsResponseModel.self, from: resultData)
                        if result.success, let metadata = result.metadata {
                            observer.onNext(metadata)
                        } else {
                            observer.onError(GetTracksFailureReason(rawValue: result.errors.first?.type ?? "") ?? GetTracksFailureReason.unknown)
                        }
                    } catch {
                        observer.onError(GetTracksFailureReason.unparsable)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create()
        }
    }
}
