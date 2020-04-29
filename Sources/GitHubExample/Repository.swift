public struct Repository: Codable {
    public let id: Int
    public let fullName: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
    }

    public init(id: Int, fullName: String) {
        self.id = id
        self.fullName = fullName
    }
}
