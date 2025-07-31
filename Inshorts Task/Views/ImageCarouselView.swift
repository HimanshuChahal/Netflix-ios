import UIKit

struct Images {
    let url: String
    let movieId: Int
}

class ImageCarouselView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var images: [Images] = []
    private var timer: Timer?
    private var currentIndex: Int = 0

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.layer.cornerRadius = 10
        collection.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collection
    }()
    
    func setImages(images: [Images]) {
        self.images = images
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    init(images: [Images]) {
        self.images = images
        super.init(frame: .zero)
        setupView()
        startAutoScroll()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.cornerRadius = 10
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    // MARK: - UICollectionView DataSource & Delegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        cell.setImage(from: images[indexPath.item].url)
        cell.button.tag = images[indexPath.item].movieId
        cell.button.addTarget(self, action: #selector(didPressCarouselItem(_:)), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    // MARK: - Auto Scroll

    private func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
    }

    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func scrollToNext() {
        guard images.count > 0 else { return }
        currentIndex = (currentIndex + 1) % images.count
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    // MARK: - Pause on User Interaction

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        startAutoScroll()
    }
    
    @objc func didPressCarouselItem(_ sender: UIButton) {
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movieId = sender.tag
        parentViewController()?.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
