//
//  EJMRankingViewController.swift
//  Marvel_Battle
//
//  Created by MAC on 12/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import UIKit
import CoreData

class EJMRankingViewController: UIViewController {
    
    var arrayName = [String]()
    var arrayDescription = [String]()
    var arrayImage = [URL?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        
    }
    
    func retrieveData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContex = appDelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterEntity")
        
        do{
            let result = try managedContex.fetch(fetchrequest)
            for data in result as! [NSManagedObject]{
                self.arrayName.append(data.value(forKey: "nameChracter") as! String)
                self.arrayDescription.append(data.value(forKey: "descriptionCharacter") as! String)
                
                let imageReceiveInString = (data.value(forKey: "imageCharacter") as! String)
                let convertUrlString = URL(string: imageReceiveInString)!
                self.arrayImage.append(convertUrlString)
            }
        } catch let error as NSError{
            print("Could not save \(error)")
        }
    }
}

extension EJMRankingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRanking", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .white
        
        let sortArray =  self.arrayName.sorted(by: { $0 < $1 })
        cell.textLabel?.text = sortArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  presentingViewController == nil{
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "EJMDetailViewController") as! EJMDetailViewController
            controller.getName =  self.arrayName[indexPath.row]
            controller.getDescription = self.arrayDescription[indexPath.row]
            
            let imageReceive = "\(String(describing: self.arrayImage[indexPath.row]))"
            let imageStringFix = imageReceive.replacingOccurrences(of: "Optional(", with: "")
            let imageStringFix2 = imageStringFix.replacingOccurrences(of: "))", with: "")
            controller.getImage = URL(string:imageStringFix2)
            self.navigationController!.pushViewController(controller, animated: true)
        }
        
        if  presentingViewController != nil{
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "EJMDetailViewController") as! EJMDetailViewController
            controller.getName =  self.arrayName[indexPath.row]
            controller.getDescription = self.arrayDescription[indexPath.row]
            
            let imageReceive = "\(String(describing: self.arrayImage[indexPath.row]))"
            let imageStringFix = imageReceive.replacingOccurrences(of: "Optional(", with: "")
            let imageStringFix2 = imageStringFix.replacingOccurrences(of: "))", with: "")
            controller.getImage = URL(string:imageStringFix2)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}

