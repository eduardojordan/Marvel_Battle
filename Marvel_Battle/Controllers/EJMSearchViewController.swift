//
//  EJHSearchViewController.swift
//  Marvel_Battle
//
//  Created by MAC on 09/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import UIKit


protocol EJMSearchViewControllerDelegate : NSObjectProtocol{
    
    func addItemViewController( item: DataCharacter?)
}

protocol EJMSearchViewControllerDelegate2 : NSObjectProtocol{
    
    func addItemViewController2(item: DataCharacter?)
}

class EJMSearchViewController:  UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    let requestCharacter = RequestData()
    var currentPage = 0
    var page = 0
    
    var marvelArray = [DataCharacter]()
    var searchCharacter = [DataCharacter]()
    var searching = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
   weak var delegate: EJMSearchViewControllerDelegate?
    weak var delegate2: EJMSearchViewControllerDelegate2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let logo = UIImage(named: "MarvelBattleHorizontalLogo.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.tabBarController?.navigationItem.titleView = imageView
    }
    
    private func loadData(){
        
        let offset = page * ApiURL.limit
        let queryParams: [String:String] = ["offset": String(offset), "limit": String(ApiURL.limit)]
        let jsonUrlString = ApiURL.basePath + queryParams.queryString! + ApiURL.getCredentials()
        
        requestCharacter.networkRequest(MethodType: Type.GET, url: jsonUrlString, codableType: Characters.self) { (response) in
            self.marvelArray.append(contentsOf: response.data!.results)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    func initActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = (UIColor (white: 0.2, alpha: 0.8))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.layer.cornerRadius = 10
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    var valueToPass:String!
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
        cell.selectionStyle = .none
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  presentingViewController != nil{

            let dataArray = self.marvelArray[indexPath.row]
            
            delegate?.addItemViewController(item: dataArray)
            delegate2?.addItemViewController2(item: dataArray)
            
            self.dismiss(animated: true, completion: nil)
            
        }

        if  presentingViewController == nil{

            let controller = self.storyboard!.instantiateViewController(withIdentifier: "EJMDetailViewController") as! EJMDetailViewController
            controller.getName = self.marvelArray[indexPath.row].name!
            controller.getDescription = self.marvelArray[indexPath.row].description!
            controller.getImage = self.marvelArray[indexPath.row].image!
            self.navigationController!.pushViewController(controller, animated: true)
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.marvelArray.count - 1{
            
            page =  page + 1
            loadData()
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width:tableView.bounds.width, height: CGFloat(44))
            spinner.color = UIColor.white
            
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            
        }
    }
    
}

extension EJMSearchViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchCharacter = self.marvelArray.filter({$0.name!.prefix(searchText.count) == searchText})
        
        
        searching = true
        //        self.marvelArray.removeAll()
        //        self.marvelArray = self.searchCharacter
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

