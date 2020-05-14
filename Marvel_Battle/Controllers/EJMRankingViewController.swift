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
    
    
    var arrayRanking = [String]()
    
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
                self.arrayRanking.append(data.value(forKey: "nameChracter") as! String)
                // self.arrayRanking.append(data.value(forKey: "nameChracter") as! String)
            }
           
        } catch let error as NSError{
            print("Could not save \(error)")
        }
    }
    
    
}

extension EJMRankingViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRanking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRanking", for: indexPath)
        
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .white
        
       let sortArray =  self.arrayRanking.sorted(by: { $0 < $1 })
        cell.textLabel?.text = sortArray[indexPath.row]
        return cell
    }
    
    
    
    
    
    
    
}
