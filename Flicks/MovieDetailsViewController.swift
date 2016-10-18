//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Stephen Chudleigh on 10/17/16.
//  Copyright © 2016 Stephen Chudleigh. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movie: Movie?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var popularityRating: UILabel!
    @IBOutlet weak var runningTime: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let poster = movie?.poster {
            self.posterImage.setImageWith(poster)
        }
        
        self.addDetailsToScrollView()
        
        let contentWidth = detailView.bounds.width
        let contentHeight = movieTitle.bounds.height +
            releaseDate.bounds.height +
            popularityRating.bounds.height +
            overview.bounds.height +
            50
        print("details height=\(contentHeight)")
        detailView.frame.size = CGSize(width: contentWidth, height: contentHeight)
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight + 500)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDetailsToScrollView() {
        if let movie = self.movie {
            let popRating = Int(round(movie.popularityRating))
            self.movieTitle.text = movie.title
            self.releaseDate.text = movie.releaseDate
            self.popularityRating.text = "\(popRating)%"
            self.overview.text = movie.overview
            self.overview.sizeToFit()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
