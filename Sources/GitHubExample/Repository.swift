public struct Repository: Codable {
    public let id: Int
    public let fullName: String
    public let description: String
    public let htmlURL: String
    public let owner: User

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case htmlURL = "html_url"
        case owner
    }
}

public struct User: Codable {
    public let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
