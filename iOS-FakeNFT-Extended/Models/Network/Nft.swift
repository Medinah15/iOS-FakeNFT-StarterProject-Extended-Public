import Foundation

struct Nft: Decodable {
    let id: String
    let title: String
    let images: [URL]
    let priceETH: Decimal?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case image
        case images
        case price
        case priceETH = "price_eth"
        case eth
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
        
        if let d = try? c.decodeIfPresent(Decimal.self, forKey: .priceETH) {
            priceETH = d
        } else if let d = try? c.decodeIfPresent(Decimal.self, forKey: .price) {
            priceETH = d
        } else if let d = try? c.decodeIfPresent(Decimal.self, forKey: .eth) {
            priceETH = d
        } else {
            let s = (try? c.decodeIfPresent(String.self, forKey: .priceETH)) ??
            (try? c.decodeIfPresent(String.self, forKey: .price)) ??
            (try? c.decodeIfPresent(String.self, forKey: .eth)) ?? nil
            priceETH = s.flatMap { Decimal(string: $0) }
        }
    }
}
