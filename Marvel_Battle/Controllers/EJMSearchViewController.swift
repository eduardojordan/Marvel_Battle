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
    var searchCharacter = [DataCharacter]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "MarvelBattleHorizontalLogo.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        
        parseJSON()
        searchBar.searchTextField.textColor = .white
        searchBar.placeholder = "Search hero"
        searchBar.searchTextField.font = UIFont(name: "Helvetica", size: 14)
        
        tableView.rowHeight = 100
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

extension EJMSearchViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return self.searchCharacter.count
        }else{
            return self.marvelArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Adjust Cell Style
        cell.textLabel?.font = UIFont(name: "Helvetica Bold", size: 20.0)
        cell.textLabel?.textColor = .white
        //        cell.imageView?.layer.cornerRadius = 75.0
        //        cell.imageView?.layer.masksToBounds = true
        
        // Cell Data
        cell.textLabel?.text = self.marvelArray[indexPath.row].name
        
        let imgData = self.marvelArray[indexPath.row].image
        let pathString = "http://i.annihil.us" + imgData!.path + "/portrait_xlarge.jpg"
        let url = URL(string: pathString)
        if  url == nil {
            cell.imageView?.image = UIImage(named: "placeholder.png")
        }else{
            
            cell.imageView?.image = UIImage(url: url)
        }
        if searching {
            cell.textLabel?.text = self.searchCharacter[indexPath.row].name
            return cell
        } else {
            cell.textLabel?.text = self.marvelArray[indexPath.row].name
            return cell
        }
    }
}

extension EJMSearchViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchCharacter = self.marvelArray.filter({$0.name!.prefix(searchText.count) == searchText})
        searching = true
        tableView.reloadData()
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

