//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Stephen Chudleigh on 10/14/16.
//  Copyright © 2016 Stephen Chudleigh. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorLabel: UIView!
    @IBOutlet weak var searchBarTop: UISearchBar!

    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    let ApiUrl = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBarTop.delegate = self
        
        self.navigationItem.titleView = self.searchBarTop
        
        // network error hidden initially
        networkErrorLabel.isHidden = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovieDataTrigger(refreshControl:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        refreshControl.isHidden = true
        
        loadMovieData(refreshControl: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = movie.overview
        cell.overviewLabel.sizeToFit()
        
        if let url = movie.poster {
            cell.posterView.setImageWith(url)
        }

        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let search = searchText.lowercased()
        if search == "" {
            self.filteredMovies = self.movies
        } else {
            self.filteredMovies = self.movies.filter { movie in movie.title.lowercased().contains(search) }
        }
        self.tableView.reloadData()
    }
    
    func refreshMovieDataTrigger(refreshControl: UIRefreshControl) {
        loadMovieData(refreshControl: refreshControl)
    }
    
    func loadMovieData(refreshControl: UIRefreshControl?) {
        // Load movies
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let request = URLRequest(url: ApiUrl!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if error != nil {
                self.networkErrorLabel.isHidden = false
                return
            } else {
                self.networkErrorLabel.isHidden = true
            }

            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.movies.removeAll()
                    for movieData in responseDictionary["results"] as! [NSDictionary] {
                        let movie = Movie(movie: movieData)
                        self.movies.append(movie)
                    }
                    self.filteredMovies = self.movies
                    self.tableView.reloadData()
                    if let rc = refreshControl {
                        rc.endRefreshing()
                    }
                }
            }
        });
        task.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let details = segue.destination as! MovieDetailsViewController
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            details.movie = self.filteredMovies[indexPath.row]
        }
    }

}
