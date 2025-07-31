import UIKit

class HomeViewController: AppViewController {
    
    private let movieCellName = "MovieCell"
    let imageCarousel = ImageCarouselView(images: [])
    private lazy var trendingMovieList = horizontalMovieList()
    private lazy var nowPlayingMovieList = horizontalMovieList()
    private var trendingMovies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []
    private var bookmarkedData = CoreDataManager.shared.fetchAllBookmarksData()

    private lazy var horizontalMovieList = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(MovieCell.self, forCellWithReuseIdentifier: self.movieCellName)
        collection.backgroundColor = .velvet

        return collection
    }
    
    private lazy var topView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let searchButton = AppButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.addTarget(self, action: #selector(didPressSearch(_:)), for: .touchUpInside)
        
        let saved = AppButton()
        saved.translatesAutoresizingMaskIntoConstraints = false
        saved.setImage(UIImage(systemName: "star.fill"), for: .normal)
        saved.tintColor = .white
        saved.addTarget(self, action: #selector(didPressSaved(_:)), for: .touchUpInside)
        
        view.addSubview(searchButton)
        view.addSubview(saved)
        
        NSLayoutConstraint.activate([
            saved.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saved.topAnchor.constraint(equalTo: view.topAnchor),
            saved.widthAnchor.constraint(equalToConstant: 50),
            saved.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.trailingAnchor.constraint(equalTo: saved.leadingAnchor, constant: -10),
            searchButton.centerYAnchor.constraint(equalTo: saved.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: saved.bottomAnchor),
        ])
        
        return view
    }()
    
    private lazy var trending = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: .bold, size: 20)
        label.textColor = .white
        label.text = "Trending Movies"
        
        let movieList = trendingMovieList
        
        view.addSubview(label)
        view.addSubview(movieList)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieList.heightAnchor.constraint(equalToConstant: 130),
            movieList.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            movieList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: movieList.bottomAnchor)
        ])
        
        return view
    }()
    
    private lazy var nowPlaying = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: .bold, size: 20)
        label.textColor = .white
        label.text = "Now Playing Movies"
        
        let movieList = nowPlayingMovieList
        
        view.addSubview(label)
        view.addSubview(movieList)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieList.heightAnchor.constraint(equalToConstant: 130),
            movieList.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            movieList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: movieList.bottomAnchor)
        ])
        
        return view
    }()
    
    private lazy var carousel = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        
        imageCarousel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageCarousel)
        
        NSLayoutConstraint.activate([
            imageCarousel.topAnchor.constraint(equalTo: view.topAnchor),
            imageCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCarousel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCarousel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
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
        
        view.backgroundColor = .velvet
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topView)
        contentView.addSubview(carousel)
        contentView.addSubview(trending)
        contentView.addSubview(nowPlaying)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            carousel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
            carousel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            carousel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            carousel.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.3),
            
            trending.topAnchor.constraint(equalTo: carousel.bottomAnchor, constant: 20),
            trending.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trending.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nowPlaying.topAnchor.constraint(equalTo: trending.bottomAnchor, constant: 20),
            nowPlaying.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nowPlaying.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nowPlaying.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NetworkApi.shared.fetchTrendingMovies { result in
            switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        let urls = movies.filter { movie in movie.posterPath != nil }
                            .map { movie in Images(url: String.posterBaseUrl + movie.posterPath!, movieId: movie.id) }
                        self.imageCarousel.setImages(images: urls)
                        self.trendingMovies = movies
                        self.trendingMovieList.reloadData()
                        
                        CoreDataManager.shared.deleteAllTrending()
                        let context = CoreDataManager.shared.context
                        var modelMovies: Set<MovieModel> = []
                        for movie in movies {
                            let movieModel = MovieModel(context: context)
                            movieModel.title = movie.title
                            movieModel.posterPath = movie.posterPath
                            movieModel.id = Int32(movie.id)
                            movieModel.overview = movie.overview
                            modelMovies.insert(movieModel)
                        }
                        let trendingModel = Trending(context: context)
                        trendingModel.movies = modelMovies as NSSet

                        CoreDataManager.shared.saveContext()
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                            showToast(message: "Failed to load trending movies: \(error.localizedDescription)", in: window)
                        }
                    }
            }
        }
        
        NetworkApi.shared.fetchNowPlayingMovies { result in
            switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self.nowPlayingMovies = movies
                        self.nowPlayingMovieList.reloadData()
                        
                        CoreDataManager.shared.deleteAllNowPlaying()
                        let context = CoreDataManager.shared.context
                        var modelMovies: Set<MovieModel> = []
                        for movie in movies {
                            let movieModel = MovieModel(context: context)
                            movieModel.title = movie.title
                            movieModel.posterPath = movie.posterPath
                            movieModel.id = Int32(movie.id)
                            movieModel.overview = movie.overview
                            modelMovies.insert(movieModel)
                        }
                        let nowPlayingModel = NowPlaying(context: context)
                        nowPlayingModel.movies = modelMovies as NSSet

                        CoreDataManager.shared.saveContext()
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                            showToast(message: "Failed to load now playing movies: \(error.localizedDescription)", in: window)
                        }
                    }
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookmarkedData = CoreDataManager.shared.fetchAllBookmarksData()
        trendingMovieList.reloadData()
        nowPlayingMovieList.reloadData()
    }
    
    @objc func didPressSaved(_ sender: UIButton) {
        let bookmarkVC = BookmarkViewController()
        self.navigationController?.pushViewController(bookmarkVC, animated: true)
    }
    
    @objc func didPressSearch(_ sender: UIButton) {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == trendingMovieList {
            return trendingMovies.count
        } else {
            return nowPlayingMovies.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellName, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        var movies: [Movie]
        if collectionView == trendingMovieList {
            movies = trendingMovies
        } else {
            movies = nowPlayingMovies
        }
        let urls = movies.filter { movie in movie.posterPath != nil }
            .map { movie in String.posterBaseUrl + movie.posterPath! }
        cell.imageCell.setImage(from: urls[indexPath.item])
        let movie = movies[indexPath.item]
        cell.imageCell.button.tag = movie.id
        cell.imageCell.button.addTarget(self, action: #selector(didPressImageCell(_:)), for: .touchUpInside)
        cell.bookmarkButton.movieId = movie.id
        if movie.posterPath != nil {
            cell.bookmarkButton.posterUrl = String.posterBaseUrl + movie.posterPath!
        }
        cell.bookmarkButton.title = movie.title
        cell.bookmarkButton.setBookmarked(marked: bookmarkedData[movie.id] != nil)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    @objc func didPressImageCell(_ sender: UIButton) {
        let movieId = sender.tag
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movieId = movieId
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

private class MovieCell: UICollectionViewCell {
    let imageCell = ImageCell()
    let bookmarkButton = BookmarkButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.setSize(size: 30)
        
        contentView.addSubview(imageCell)
        contentView.addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
