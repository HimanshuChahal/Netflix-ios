import UIKit

struct GridData {
    let id: Int
    let name: String
    var url: String?
}

class GridView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!

    var items: [GridData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    private func setupCollectionView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "GridCell")

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let url = items[indexPath.item].url
        if url != nil {
            cell.setImage(from: url!)
        }
        cell.button.tag = Int(items[indexPath.item].id)
        cell.button.addTarget(self, action: #selector(didPressGridItem(_:)), for: .touchUpInside)
        return cell
    }

    // MARK: - Layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 10 * 2 + 10 * 2 // Padding + spacing
        let width = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: width, height: width * 1.2)
    }
    
    @objc func didPressGridItem(_ sender: UIButton) {
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movieId = sender.tag
        parentViewController()?.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
