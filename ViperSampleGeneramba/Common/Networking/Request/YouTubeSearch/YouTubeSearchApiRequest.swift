import Foundation

final class YouTubeSearchApiResource: ApiResource {
    
    typealias Model = YouTubeData
    
    var baseURL: String {
        return "https://www.googleapis.com/youtube/v3"
    }
    
    var path: String {
        return "/search"
    }
    
    var method: HttpMethod {
        return .get
    }
    
    let parameter: ApiParameter
    init(q: String,
         key: String,
         part: YouTubeSearchPartParameter,
         maxResults: Int,
         order: String,
         pageToken: String) {

        self.parameter = YouTubeSearchParameter(
            q: q,
            key: key,
            part: part,
            maxResults: maxResults,
            order: order,
            pageToken: pageToken)
    }    
}
