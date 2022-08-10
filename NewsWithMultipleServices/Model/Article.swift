import Foundation

// MARK: - Article
struct Article: Codable, Equatable {
    let author, title, url, urlToImage, content: String?
    
    enum CodingKeys: String, CodingKey {
        case author, title, url, urlToImage, content
    }
}
