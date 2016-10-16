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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    let refreshControl = UIRefreshControl()
    
    private let tmdbApiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    private var movies:Array<JSON> = Array<JSON>()
    private var moviePageOffset = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        getNowPlaying()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsViewController = segue.destination as! MovieDetailsViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        let movie = self.movies[(indexPath?.row)!]
        let posterImageFilename = movie["poster_path"].string
        let movieTitle = movie["title"].string
        let overview = movie["overview"].string
        let releaseDate = movie["release_date"].string
        let language = movie["original_language"].string
        let popularity = movie["popularity"].float
        let voteAverage = movie["vote_average"].float
        
        if (posterImageFilename != nil)
        {
            detailsViewController.dataPosterBackgroundImageViewUrl = "https://image.tmdb.org/t/p/w500\(posterImageFilename!)"
        }
        detailsViewController.dataMovieTitle = movieTitle
        detailsViewController.dataOverview = overview
        detailsViewController.dataReleaseDate = releaseDate
        detailsViewController.dataLanguage = language
        detailsViewController.dataPopularity = popularity
        detailsViewController.dataVoteAverage = voteAverage
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.movies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.iosflicks.MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"].string
        let overview = movie["overview"].string
        let posterImageFilename = movie["poster_path"].string
        
        cell.titleLabel.text = title
        cell.overviewLabel.numberOfLines = 0
        cell.overviewLabel.text = overview
        
        if (posterImageFilename != nil)
        {
            let posterImageUrl = URL(string:"https://image.tmdb.org/t/p/w500\(posterImageFilename!)")
            cell.posterImage.contentMode = .scaleAspectFit
            cell.posterImage.setImageWith(posterImageUrl!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getNowPlaying(page: self.moviePageOffset, showProgress: false)
    }
    
    private func getNowPlaying(page: Int = 1, showProgress: Bool = true) {
        let lang = "en-US"
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(tmdbApiKey)&language=\(lang)&page=\(page)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        self.networkErrorView.isHidden = true
        if (showProgress)
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let task : URLSessionDataTask = session.dataTask(
            with: request,
            completionHandler: {
                (dataOrNil, response, error) in
                
                if (error != nil) {
                    self.networkErrorView.isHidden = false
                }
                else if let data = dataOrNil {
                    // remove this before submission
                    sleep(2)
                
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
                
                self.refreshControl.endRefreshing()
        });
        task.resume()

    }
}
