# Tech Stack

### `Swift with UIKit`

# 📦 Installation

Clone this repository, open the `.xcodeproj` folder in `Xcode`.

Then run, `Cmd+Shift+K` to clean the build -> `Cmd+B` to build the project -> `Cmd+R` to run the project.

# 📱 Movie Browser App

An iOS application built using swift and UIKit that allows users to search movies using The Movie Database (TMDb) API, view search results in a grid layout, and manage bookmarks using Core Data.

## 📐 Architecture

### Pattern: MVC (Model-View-Controller)

The app follows the traditional MVC architecture with clear separation between: Models, Views and Controllers.

### Model:

All the required models are in the `Models` folder.

### View:

Custom UI components using UIView, UICollectionView and UIButton are present in the `Views` folder.

Reusable components like UIImage, LoadingView, etc. are also inside the `Views` directory.

### Controller:

All the View Controllers are inside the `ViewControllers` directory.

AppViewController: A reusable ViewController to implement interactive gestures like swipe to pop gesture.

HomeViewController: Manages the home screen to show trending and now playing movies.

MovieDetailViewController: Used to display the details of a movie.

SearchViewController: Manages movie search, debounced input, and updates UI.

BookmarkViewController: Displays saved bookmarks from Core Data.

### Network calls

All the network call related code is implemented in the `Network/NetworkApi.swift` file. Each API is defined in a separate function to maintain code clarity.

### CoreData for internal data storage

`CoreData/CoreDataManager.swift` file contains all the helper functions to manage the CoreData entities.

## 🧩 Features

🔍 Search movies via TMDb API (debounced input).

🧱 3-column grid layout for displaying search results.

📌 Bookmark functionality to save favorite movies using Core Data.

🧭 Navigation between search and bookmarks screen.

⏳ Loading indicator while fetching results.

## 🚀 Setup Instructions

### 🔧 Requirements

Xcode (Preferably version 15+)

### 🔑 API Key

Create a free account on TMDb. - [Setup TMDB account](https://www.themoviedb.org/settings/api)

Generate an API key.

Open NetworkApi.swift and set this variable:

`private let apiKey = "your_tmdb_api_key"`

## Thanks!
