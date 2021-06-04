//
//  ViewController.swift
//  Bugar
//
//  Created by Anno Musa on 04/06/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testRapid()
        testFlickr()
    }
    
    private func testFlickr() {
        URLSession.shared.dataTask(with: URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrKey)&tags=fitness&format=json&nojsoncallback=1")!) { data, response, error in
            if error != nil {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        }.resume()
    }
    
    private func testRapid() {

        let headers = [
            "x-rapidapi-key": "d6e79b749fmsh5de470e54ff8e4dp1bba99jsn3b560231062b",
            "x-rapidapi-host": "instagram-facebook-media-downloader.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://instagram-facebook-media-downloader.p.rapidapi.com/api?igurl=https%3A%2F%2Fwww.instagram.com%2Fexplore%2Ftags%2Ffitness%2F")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })

        dataTask.resume()
    }
    
}
