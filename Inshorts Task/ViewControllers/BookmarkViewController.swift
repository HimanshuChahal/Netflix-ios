import UIKit

class BookmarkViewController: AppViewController {
    private let gridView = GridView()
    
    private var bookmarkedData = CoreDataManager.shared.fetchAllBookmarksData()
    
    private let label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: .bold, size: 20)
        label.textColor = .white
        label.text = "Bookmarks"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = .velvet
        
        view.addSubview(label)
        view.addSubview(gridView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gridView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        gridView.items = bookmarkedData.keys.map { key in GridData(id: Int(bookmarkedData[key]!.id), name: (bookmarkedData[key]?.name ?? ""), url: (bookmarkedData[key]?.url)) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bookmarkedData = CoreDataManager.shared.fetchAllBookmarksData()
        gridView.items = bookmarkedData.keys.map { key in GridData(id: Int(bookmarkedData[key]!.id), name: (bookmarkedData[key]?.name ?? ""), url: (bookmarkedData[key]?.url)) }
    }
}
