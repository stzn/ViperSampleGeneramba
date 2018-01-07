import Foundation

extension API {
    
    final class YouTubeSearchApi {
        
        let apiRequest: ApiRequest<YouTubeSearchApiResource>
        
        init(q: String, partList: [YouTubeSearchPartParameter.Keys], order: String, pageToken: String) {
            
            let part = YouTubeSearchPartParameter(list: partList)
            let apiResource = YouTubeSearchApiResource(
                q: q,
                key: Environments.youtubeDataApiKey,
                part: part,
                maxResults: MaxResultsPerPage.YouTubeSearch,
                order: order,
                pageToken: pageToken)
            self.apiRequest = ApiRequest(resource: apiResource)
        }
        
        func fetchYouTubeSearchData() -> Task<YouTubeData, Error> {
            
            let task = Task<YouTubeData, Error> { [weak self] result in
                self?.apiRequest.load() { apiResult in
                    return result(apiResult)
                }
            }
            return task
        }
    }
}
