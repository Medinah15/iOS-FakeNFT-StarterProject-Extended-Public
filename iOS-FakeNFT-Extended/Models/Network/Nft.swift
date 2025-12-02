import Foundation

struct Nft: Decodable {
    let id: String
    let title: String
    let images: [URL]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case image
        case images
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try c.decode(String.self, forKey: .id)
        
        title = try c.decodeIfPresent(String.self, forKey: .title)
        ?? c.decodeIfPresent(String.self, forKey: .name)
        ?? "Untitled"
        
        var urls: [URL] = []
        
        if let arr = try c.decodeIfPresent([String].self, forKey: .images) {
            urls = arr.compactMap { URL(string: $0) }
        } else if let single = try c.decodeIfPresent(String.self, forKey: .image),
                  let u = URL(string: single) {
            urls = [u]
        }
        
        images = urls
    }
}
