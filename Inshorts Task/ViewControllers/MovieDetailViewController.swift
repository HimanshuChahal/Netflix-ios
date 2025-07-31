import UIKit

class MovieDetailViewController: AppViewController {
    
    var movieId: Int? = nil
    
    private var movieDetails: MovieDetails? = nil
    
    private let imageCell = ImageCell()
    
    private let bookmarkedData = CoreDataManager.shared.fetchAllBookmarksData()
    
    func addStars(to view: UIView, rating: Double, maxStars: Int = 10) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center

        for i in 1...maxStars {
            let imageView = UIImageView()
            if Double(i) <= rating {
                imageView.image = UIImage(systemName: "star.fill")
            } else if Double(i) - rating < 1 {
                imageView.image = UIImage(systemName: "star.leadinghalf.filled")
            } else {
                imageView.image = UIImage(systemName: "star")
            }
            imageView.tintColor = .systemYellow
            imageView.contentMode = .scaleAspectFit
            imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            stackView.addArrangedSubview(imageView)
        }

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private lazy var releaseDate = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: .bold, size: 16)
        label.textColor = .white
        label.text = "Released on"
        
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: .regular, size: 14)
        dateLabel.textColor = .lightGray
        
        view.addSubview(label)
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    private lazy var genres = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: .bold, size: 16)
        label.textColor = .white
        label.text = "Genres"
        
        let genresLabel = UILabel()
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.font = UIFont(name: .regular, size: 14)
        genresLabel.textColor = .lightGray
        genresLabel.numberOfLines = 0
        genresLabel.text = (movieDetails?.genres ?? []).map { genre in genre.name }.joined(separator: ", ")
        
        view.addSubview(label)
        view.addSubview(genresLabel)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genresLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            genresLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            genresLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    private lazy var overView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: .regular, size: 14)
        label.text = movieDetails?.overview ?? "No overview"
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var rating = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if movieDetails?.voteAverage != nil {
            addStars(to: view, rating: movieDetails!.voteAverage!)
        }
        
        return view
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: .bold, size: 20)
        label.textColor = .white
        label.text = movieDetails?.title ?? ""
        return label
    }()
    
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = .blackVelvet
        
        let bookmarkButton = BookmarkButton(frame: .zero)
        bookmarkButton.movieId = movieId
        
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        imageCell.layer.cornerRadius = 10
        
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageCell)
        contentView.addSubview(rating)
        contentView.addSubview(overView)
        contentView.addSubview(genres)
        contentView.addSubview(releaseDate)
        imageCell.addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageCell.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.2),
            
            bookmarkButton.topAnchor.constraint(equalTo: imageCell.topAnchor, constant: 20),
            bookmarkButton.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: -20),
            
            rating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rating.topAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: 20),

            overView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overView.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 20),
            overView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            genres.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genres.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genres.topAnchor.constraint(equalTo: overView.bottomAnchor, constant: 20),
            
            releaseDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            releaseDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            releaseDate.topAnchor.constraint(equalTo: genres.bottomAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 20)
        ])
        
        guard let movieId = movieId else {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                showToast(message: "Movie ID not found", in: window)
            }
            return
        }
        
        NetworkApi.shared.fetchMovieDetails(movieId: movieId) { result in
            switch (result) {
            case .success(let details):
                DispatchQueue.main.async {
                    self.movieDetails = details
                    self.titleLabel.text = details.title
                    self.imageCell.setImage(from: String.posterBaseUrl + (details.posterPath ?? ""))

                    self.overView.text = details.overview
                    if details.voteAverage != nil {
                        self.addStars(to: self.rating, rating: details.voteAverage!)
                    }
                    
                    let genreNames = details.genres.map { $0.name }.joined(separator: ", ")
                    self.genres.subviews.compactMap { $0 as? UILabel }.last?.text = genreNames
                    if self.movieDetails?.releaseDate != nil {
                        self.releaseDate.subviews.compactMap { $0 as? UILabel }.last?.text = formatDateWithSuffix(from: self.movieDetails!.releaseDate!)
                        if let isFuture = isDateInFuture(self.movieDetails!.releaseDate!) {
                            if isFuture {
                                if let label = self.releaseDate.subviews.compactMap({ $0 as? UILabel }).first {
                                    label.text = "Releasing on"
                                }
                            }
                        }
                    }
                    bookmarkButton.title = self.movieDetails?.title
                    if self.movieDetails != nil, self.movieDetails?.posterPath != nil {
                        bookmarkButton.posterUrl = String.posterBaseUrl + self.movieDetails!.posterPath!
                    }
                    bookmarkButton.setBookmarked(marked: self.bookmarkedData[details.id] != nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                        showToast(message: "Details not found \(error.localizedDescription)", in: window)
                    }
                }
            }
        }
    }
}
