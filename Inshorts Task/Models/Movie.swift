struct MovieResponse: Codable {
    let results: [Movie]
}

class Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
    }
}

struct MovieDetails: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double?
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, runtime
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
