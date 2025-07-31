import UIKit

class BookmarkButton: AppButton {
    private let bookmarkImage = UIImageView()
    
    var movieId: Int? = nil
    var posterUrl: String? = nil
    var title: String? = nil
    
    private var bookmarkedData = CoreDataManager.shared.fetchAllBookmarksData()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }
    
    func setSize(size: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.layer.cornerRadius = size / 2
    }
    
    func setBookmarked(marked: Bool) {
        if (marked) {
            bookmarkImage.image = UIImage(systemName: "star.fill")
        } else {
            bookmarkImage.image = UIImage(systemName: "star")
        }
    }
    
    private func layout() {
        let button = self
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.backgroundColor = .blackVelvet
        button.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
        
        bookmarkImage.translatesAutoresizingMaskIntoConstraints = false
        bookmarkImage.image = UIImage(systemName: "star")
        bookmarkImage.tintColor = .white
        bookmarkImage.contentMode = .scaleAspectFit
        
        button.addSubview(bookmarkImage)
        
        NSLayoutConstraint.activate([
            bookmarkImage.topAnchor.constraint(equalTo: button.topAnchor, constant: 5),
            bookmarkImage.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            bookmarkImage.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5),
            bookmarkImage.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -5),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func didPressButton(_ sender: UIButton) {
        guard let movieId = movieId else {
            return
        }
        
        bookmarkedData = CoreDataManager.shared.fetchAllBookmarksData()
        
        if bookmarkedData[movieId] != nil {
            CoreDataManager.shared.deleteBookmark(bookmarkedData[movieId]!)
            setBookmarked(marked: false)
            return
        }
        
        let context = CoreDataManager.shared.context
        let movie = Bookmarks(context: context)
        movie.name = title
        movie.url = posterUrl
        movie.id = Int32(movieId)

        CoreDataManager.shared.saveContext()
        setBookmarked(marked: true)
    }
}
