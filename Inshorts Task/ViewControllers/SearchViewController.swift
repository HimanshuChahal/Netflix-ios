import UIKit

class SearchViewController: AppViewController, UITextFieldDelegate {
    private let gridView = GridView()
    private var loadingView: LoadingView? = nil
    
    private var searchDebounceTimer: Timer?
    
    private lazy var textField = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        
        let searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont(name: .regular, size: 14)
        searchTextField.textColor = .blackVelvet
        searchTextField.placeholder = "Search movies..."
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 5
        searchTextField.delegate = self
        searchTextField.accessibilityIdentifier = "searchTextField"
        
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            view.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10)
        ])
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blackVelvet
        
        loadingView = LoadingView(frame: view.bounds)
        
        view.addSubview(textField)
        view.addSubview(gridView)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gridView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    deinit {
        searchDebounceTimer?.invalidate()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            debounceSearch(with: updatedText)
        }
        return true
    }
    
    func debounceSearch(with text: String) {
        searchDebounceTimer?.invalidate()
        
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { [weak self] _ in
            guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            self?.view.addSubview(self!.loadingView!)
            NetworkApi.shared.fetchSearchMovie(search: text) { result in
                DispatchQueue.main.async {
                    self!.loadingView?.removeFromSuperview()
                }
                switch(result) {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self?.gridView.items = movies.results.map { movie in
                            var g = GridData(id: movie.id, name: movie.title, url: nil)
                            if movie.posterPath != nil {
                                g.url = (String.posterBaseUrl + movie.posterPath!)
                            }
                            return g
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                            showToast(message: "Failed to load searched movies: \(error.localizedDescription)", in: window)
                        }
                    }
                }
            }
        }
    }
}
