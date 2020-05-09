//
//  EJHSearchViewController.swift
//  Marvel_Battle
//
//  Created by MAC on 09/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import UIKit

class EJMSearchViewController:  UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var marvelArray = [DataCharacter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Include logo in Navigation Bar
        let logo = UIImage(named: "MarvelBattleHorizontalLogo.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        
        // Call to API
        parseJSON()
        
    }
    
    func parseJSON(){
        let jsonBase = "https://gateway.marvel.com/v1/public/characters?"
        let jsonAPI = ApiURL.getCredentials()
        let jsonUrlString = jsonBase + jsonAPI
        print("+++++",jsonUrlString)
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            do{
                let decoder = JSONDecoder()
                let response = try decoder.decode(Characters.self, from: data)
                self.marvelArray = response.data!.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch let error {
                print("JSON ERROR",error)
            }
        }.resume()
    }
}

extension EJMSearchViewController :  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.marvelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = self.marvelArray[indexPath.row].name
        
        return cell
    }
}
