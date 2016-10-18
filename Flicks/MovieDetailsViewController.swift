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

        if let poster = movie?.lowResPoster {
            let loResRequest = URLRequest(url: poster)
            
            self.posterImage.setImageWith(
                loResRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterImage.alpha = 0.0
                    self.posterImage.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        self.posterImage.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            if let hiResUrl = self.movie?.hiResPoster {
                                let hiResRequest = URLRequest(url: hiResUrl)
                                self.posterImage.setImageWith(
                                    hiResRequest,
                                    placeholderImage: smallImage,
                                    success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                        
                                        self.posterImage.image = largeImage;
                                        
                                    },
                                    failure: { (request, response, error) -> Void in
                                        
                                })
                            }
                    })
                },
                failure: { (request, response, error) -> Void in
            })
        }
        
        self.addDetailsToScrollView()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
