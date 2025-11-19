import Foundation

struct PaymentMethod: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let ticker: String
    let iconName: String
    
    static let all: [PaymentMethod] = [
        .init(name: "Bitcoin",   ticker: "BTC",  iconName: "bitcoin"),
        .init(name: "Dogecoin",  ticker: "DOGE", iconName: "doge"),
        .init(name: "Tether",    ticker: "USDT", iconName: "usdt"),
        .init(name: "Apecoin",   ticker: "APE",  iconName: "ape"),
        .init(name: "Solana",    ticker: "SOL",  iconName: "sol"),
        .init(name: "Ethereum",  ticker: "ETH",  iconName: "eth"),
        .init(name: "Cardano",   ticker: "ADA",  iconName: "ada"),
        .init(name: "Shiba Inu", ticker: "SHIB", iconName: "shib")
    ]
}
