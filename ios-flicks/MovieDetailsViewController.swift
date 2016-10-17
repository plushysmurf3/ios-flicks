//
//  MovieDetailsViewController.swift
//  ios-flicks
//
//  Created by Savio Tsui on 10/15/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import AFNetworking
import SwiftIconFont
import UIKit

class MovieDetailsViewController: UIViewController {

    var dataPosterBackgroundImageViewUrl: String!
    var dataMovieTitle: String!
    var dataOverview: String!
    var dataReleaseDate: String!
    var dataLanguage: String!
    var dataPopularity: Float!
    var dataVoteAverage: Float!

    @IBOutlet weak var posterBackgroundImageView: UIImageView!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var movieContentView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var popularity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.posterBackgroundImageView.contentMode = .scaleAspectFill
        if (self.dataPosterBackgroundImageViewUrl != nil)
        {
            let url = URL(string: self.dataPosterBackgroundImageViewUrl!)!
            self.posterBackgroundImageView.setImageWith(url)
        }
        else {
            self.posterBackgroundImageView.image = nil
        }
        self.posterBackgroundImageView.alpha = 0
        self.posterBackgroundImageView.center.y = UIScreen.main.bounds.height + self.posterBackgroundImageView.frame.height / 2
        UIView.animate(withDuration: 1.0, animations: {
            self.posterBackgroundImageView.alpha = 1
            self.posterBackgroundImageView.center.y = UIScreen.main.bounds.height / 2
        })
        
        self.movieTitle.text = self.dataMovieTitle
        self.releaseDate.text = self.dataReleaseDate
        self.language.text = getTranslatedLanguageFromCode(lang: self.dataLanguage)
        self.voteAverage.font = UIFont.icon(from: .FontAwesome, ofSize: 17)
        self.voteAverage.text = String.fontAwesomeIcon("star")! + " " + String(self.dataVoteAverage) + " / 10"
        self.popularity.font = UIFont.icon(from: .FontAwesome, ofSize: 17)
        self.popularity.text = String.fontAwesomeIcon("trophy")! + " " + String(format: "%.0f", self.dataPopularity) + "%"
        self.overview.text = self.dataOverview
        
        let originalOverviewHeight = self.overview.frame.height
        self.overview.sizeToFit()
        let resizedOverviewHeight = self.overview.frame.height
        let extraHeight = (resizedOverviewHeight - originalOverviewHeight + 10)
        let resizedMovieContentViewHeight = movieContentView.frame.height + extraHeight
        
        let contentWidth = detailsScrollView.bounds.width
        let contentHeight = detailsScrollView.bounds.height
        detailsScrollView.frame = CGRect(x: detailsScrollView.frame.origin.x, y: detailsScrollView.frame.origin.y - extraHeight, width: contentWidth, height: contentHeight + extraHeight)
        detailsScrollView.contentSize = CGSize(width: contentWidth, height: detailsScrollView.frame.height + extraHeight + 10)
        movieContentView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.65)
        movieContentView.frame = CGRect(x: movieContentView.frame.origin.x, y: movieContentView.frame.origin.y, width: contentWidth, height: resizedMovieContentViewHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getTranslatedLanguageFromCode(lang:String) -> String
    {
        let locale = NSLocale(localeIdentifier: lang)
        return locale.displayName(forKey: NSLocale.Key.identifier, value: lang)!
    }

}
