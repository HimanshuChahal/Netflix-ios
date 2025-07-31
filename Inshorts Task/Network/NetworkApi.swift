import Foundation

class NetworkApi {
    static let shared = NetworkApi()
    private let apiKey = "your_tmdb_api_key"
    private let baseURL = "https://api.themoviedb.org/3"

    func fetchTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/trending/movie/week?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let urlString = "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)&language=en-US"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                completion(.success(movieDetails))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchSearchMovie(search: String, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(search)&language=en-US"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let movies = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
