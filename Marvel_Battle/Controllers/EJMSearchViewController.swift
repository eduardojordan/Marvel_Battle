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
    
    let requestCharacter = RequestData()
    var currentPage = 0
    var total = 0
    var nameSearch = ""
    
    var marvelArray = [DataCharacter]()
    var searchCharacter = [DataCharacter]()
    var searching = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "MarvelBattleHorizontalLogo.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        
        loadData()
        searchBar.searchTextField.textColor = .white
        searchBar.placeholder = "Search hero"
        searchBar.searchTextField.font = UIFont(name: "Helvetica", size: 14)
        
        tableView.backgroundColor = UIColor.darkGray
        tableView.rowHeight = 100
        if self.marvelArray.count == 0{
            self.initActivityIndicator()
        }
    }
    
    private func loadData(){
        
        let jsonUrlString = ApiURL.basePath + ApiURL.getCredentials()
        requestCharacter.networkRequest(MethodType: Type.GET, url: jsonUrlString, codableType: Characters.self) { (response) in
            self.marvelArray = response.data!.results
            
            print("!!!",self.marvelArray )
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    func initActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = (UIColor (white: 0.2, alpha: 0.8))   //create a background behind the spinner
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.layer.cornerRadius = 10
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
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

        cell.textLabel?.font = UIFont(name: "Helvetica Bold", size: 20.0)
        cell.textLabel?.textColor = .white
        
        cell.textLabel?.text = self.marvelArray[indexPath.row].name
        
        let imgData = self.marvelArray[indexPath.row].image
        let pathString = "http://i.annihil.us" + imgData!.path + "/portrait_xlarge.jpg"
        let url = URL(string: pathString)
        if  url == nil {
            cell.imageView?.image = UIImage(named: "imgNotAvailable.jpg")
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

