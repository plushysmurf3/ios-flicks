//
//  MoviesViewController.swift
//  ios-flicks
//
//  Created by Savio Tsui on 10/15/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import AFNetworking
import SwiftyJSON
import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    var apiAction: String = ""
    var navigationTitle: String = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    let refreshControl = UIRefreshControl()
    
    private let tmdbApiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    private var movies:Array<JSON> = Array<JSON>()
    private var filteredMovies:Array<JSON> = Array<JSON>()
    private var moviePageOffset = 1
    private var isSearchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        if (apiAction.isEmpty)
        {
            apiAction = "now_playing"
            navigationTitle = "Now Playing"
        }
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchBarHideKeyboard(sender:)))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false;
        tapGestureRecognizer.delegate = tableView as! UIGestureRecognizerDelegate?
        
        getMovies(action: apiAction)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsViewController = segue.destination as! MovieDetailsViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        let movie: JSON
            
        if (isSearchActive)
        {
            movie = self.filteredMovies[(indexPath?.row)!]
        }
        else
        {
            movie = self.movies[(indexPath?.row)!]
        }
        
        let posterImageUrlString = getPosterImageUrl(movie: movie)
        let movieTitle = movie["title"].string
        let overview = movie["overview"].string
        let releaseDate = movie["release_date"].string
        let language = movie["original_language"].string
        let popularity = movie["popularity"].float
        let voteAverage = movie["vote_average"].float
        
        if (posterImageUrlString != nil)
        {
            detailsViewController.dataPosterBackgroundImageViewUrl = posterImageUrlString!
        }
        
        detailsViewController.dataMovieTitle = movieTitle
        detailsViewController.dataOverview = overview
        detailsViewController.dataReleaseDate = releaseDate
        detailsViewController.dataLanguage = language
        detailsViewController.dataPopularity = popularity
        detailsViewController.dataVoteAverage = voteAverage
    }
    
    // searchBar methods
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty)! {
            isSearchActive = false
        }
        else {
            isSearchActive = true
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
    }
    
    public func searchBarHideKeyboard(sender: AnyObject) {
        self.searchBar.endEditing(true)
    }

    // tableView methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (isSearchActive) {
            return filteredMovies.count
        }
        
        return self.movies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.iosflicks.MovieCell", for: indexPath) as! MovieCell
        let movie:JSON
            
        if (isSearchActive)
        {
            movie = filteredMovies[indexPath.row]
        }
        else
        {
            movie = movies[indexPath.row]
        }
        
        let title = movie["title"].string
        let overview = movie["overview"].string
        let posterImageUrlString = getPosterImageUrl(movie: movie)
        
        cell.titleLabel.text = title
        cell.overviewLabel.numberOfLines = 0
        cell.overviewLabel.text = overview
        
        cell.posterImage.contentMode = .scaleAspectFit
        cell.posterImage.image = nil
        if (posterImageUrlString != nil)
        {
            let posterImageUrl = URL(string:posterImageUrlString!)
            cell.posterImage.setImageWith(posterImageUrl!)
        }
        
        cell.posterImage.alpha = 0
        UIView.animate(withDuration: 0.25 * (Double(indexPath.row % 4) + 1), animations: {
            cell.posterImage.alpha = 1
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getMovies(action: apiAction, page: self.moviePageOffset, showProgress: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (!searchText.isEmpty)
        {
            isSearchActive = true
            filterContentForSearchText(searchText: searchText)
        }
        else
        {
            isSearchActive = false
        }
        
        self.tableView.reloadData()
    }
    
    private func filterContentForSearchText(searchText: String) {
        self.filteredMovies = self.movies.filter({( movie: JSON) -> Bool in
            return (movie["title"].string?.lowercased().contains(searchText.lowercased()))!
        })
    }
    
    private func getPosterImageUrl(movie: JSON) -> String?
    {
        let tmdbImageBaseUrl: String = "https://image.tmdb.org/t/p/w500"
        let posterImageFilename = movie["poster_path"].string
        let backdropImageFilename = movie["backdrop_path"].string
        
        if (posterImageFilename != nil)
        {
            return "\(tmdbImageBaseUrl)\(posterImageFilename!)"
        }
        else if (backdropImageFilename != nil)
        {
            return "\(tmdbImageBaseUrl)\(backdropImageFilename!)"
        }
        else
        {
            return nil
        }
    }
    
    private func getMovies(action: String = "now_playing", page: Int = 1, showProgress: Bool = true) {
        let tmdbNowPlayingBaseUrl: String = "https://api.themoviedb.org/3/movie/"
        let lang = "en-US"
        let url = URL(string:"\(tmdbNowPlayingBaseUrl)\(action)?api_key=\(tmdbApiKey)&language=\(lang)&page=\(page)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        self.navigationItem.title = navigationTitle
        self.networkErrorView.isHidden = true
        if (showProgress)
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let task : URLSessionDataTask = session.dataTask(
            with: request,
            completionHandler: {
                (dataOrNil, response, error) in
                sleep(1)
                
                self.refreshControl.endRefreshing()
                
                if (error != nil) {
                    self.networkErrorView.isHidden = false
                }
                else if let data = dataOrNil {
                    let json = JSON(data: data)
                    NSLog("json: \(json)")
                    let newMovies = json["results"].arrayValue as Array<JSON>
                    self.movies.insert(contentsOf: newMovies, at: 0)
                    self.moviePageOffset += 1
                    self.tableView.reloadData()
                }
                
                if (showProgress)
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
        });
        task.resume()

    }
}
