//
//  EJMArenaViewController.swift
//  Marvel_Battle
//
//  Created by MAC on 12/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import UIKit
import CoreData

class EJMArenaViewController: UIViewController , EJMSearchViewControllerDelegate, EJMSearchViewControllerDelegate2{
    
    
    
    @IBOutlet var nameHero1Label: UILabel!
    @IBOutlet var imageHero1: UIImageView!
    @IBOutlet var nameHero2Label: UILabel!
    @IBOutlet var imageHero2: UIImageView!
    @IBOutlet var selectHero1: UIButton!
    @IBOutlet var selectHero2: UIButton!
    @IBOutlet var combatBButton: UIButton!
    
    var getName1 = "" {
        didSet {
            nameHero1Label.text = self.getName1
        }
    }
    var getImage1 = URL(string: "") {
        didSet {
            let pathString = "http://i.annihil.us" + getImage1!.path + "/portrait_xlarge.jpg"
            let url = URL(string: pathString)
            imageHero1.image = UIImage(url: url)
        }
    }
    
    var getDescription1 = ""
    var getComics1 = 0
    
    var getName2 = "" {
        didSet{
            nameHero2Label.text = self.getName2
        }
    }
    var getImage2 = URL(string: ""){
        didSet{
            let pathString = "http://i.annihil.us" + getImage2!.path + "/portrait_xlarge.jpg"
            let url = URL(string: pathString)
            imageHero2.image = UIImage(url: url)
        }
    }
    var getDescription2 = ""
    var getComics2 = 0
    var winner = ""
    var combatWinnerCounter = +1
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectHero1.addTarget(self, action:#selector(actionSelectHero1), for: .touchUpInside)
        selectHero2.addTarget(self, action:#selector(actionSelectHero2), for: .touchUpInside)
        combatBButton.addTarget(self, action:#selector(actionCombat), for: .touchUpInside)
        

    }
    
    func addItemViewController(item: DataCharacter?) {
        self.getName1 = (item?.name)!
        self.getImage1 = item?.image
        self.getDescription1 = (item?.description)!
        self.getComics1 = item!.totalComics
        print("ELNOMBRE ES--->",getName1)
    }
    
    func addItemViewController2(item: DataCharacter?) {
        self.getName2 = (item?.name)!
        self.getImage2 = item?.image
        self.getDescription2 = (item?.description)!
        self.getComics2 = item!.totalComics
        
    }
    
    
    @objc func actionSelectHero1(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "EJMSearchViewController") as! EJMSearchViewController
        controller.delegate = self
        
        if getImage1 != nil {
            nameHero1Label.text = self.getName1
            let pathString = "http://i.annihil.us" + getImage1!.path + "/portrait_xlarge.jpg"
            let url = URL(string: pathString)
            if  url == nil {
                imageHero1.image = UIImage(named: "imgNotAvailable.jpg")
            }else{
                imageHero1.image = UIImage(url: url)
            }
        }
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    @objc func actionSelectHero2(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "EJMSearchViewController") as! EJMSearchViewController
        controller.delegate2 = self
        
        if getImage2 != nil {
            nameHero2Label.text = self.getName2
            let pathString = "http://i.annihil.us" + getImage2!.path + "/portrait_xlarge.jpg"
            let url = URL(string: pathString)
            if  url == nil {
                imageHero2.image = UIImage(named: "imgNotAvailable.jpg")
            }else{
                imageHero2.image = UIImage(url: url)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func actionCombat(){
        
        isFighterIsNil()
        isFighterIsSame()
        FightersIsOnlyOne()
        FighterReady()
        
    }
    
    func isFighterIsNil(){
        if (self.getName1 == "" && self.getName2 == "") {
            
            let alert = UIAlertController(title: "Attention", message: "You must select 2 marvel heroes", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func isFighterIsSame(){
        if (self.getName1 == self.getName2)  {
            let alert = UIAlertController(title: "Attention", message: "They must be different super heroes", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func FightersIsOnlyOne(){
        if (self.getName1 == "" || self.getName2 == ""){
            let alert = UIAlertController(title: "Attention", message: "Must have 2 fighters", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    var winnerDescription = ""
    var winnerImage = URL(string: "")
    func FighterReady(){
        
        let win = max(self.getComics1, self.getComics2)
        
        if win == self.getComics1 {
            self.winner = self.getName1
            self.winnerDescription = self.getDescription1
            self.winnerImage = self.getImage1
        } else {
            self.winner = self.getName2
            self.winnerDescription = self.getDescription2
            self.winnerImage = self.getImage2
        }
        
        persistenceCoredata()
        
        let alert = UIAlertController(title: "The Winners is...", message: " 👉 \(winner) 👈", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ranking show", style: UIAlertAction.Style.destructive, handler: { action in
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "EJMRankingViewController") as! EJMRankingViewController
            self.present(controller, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func persistenceCoredata(){
        if checkIfItemExistInCoredata(winner: self.winner) == false {
            let convertURLtoString = String(describing: winnerImage)
            saveIncoredata(name: winner, description: winnerDescription, urlString: convertURLtoString )
        }
    }
    
    func checkIfItemExistInCoredata(winner: String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContex = appDelegate!.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CharacterEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "nameChracter == %@" , self.winner)
        do {
            let count = try managedContex.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}


func saveIncoredata(name:String, description:String , urlString: String){
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContex = appDelegate.persistentContainer.viewContext
    let userEntity = NSEntityDescription.entity(forEntityName: "CharacterEntity", in: managedContex)!
    let character = NSManagedObject(entity: userEntity, insertInto: managedContex)
    
    character.setValue( name, forKey: "nameChracter")
    character.setValue(description, forKey: "descriptionCharacter")
    character.setValue(urlString, forKey: "imageCharacter")
    
    do{
        try managedContex.save()
    }catch let error as NSError{
        print("Could not save \(error)")
    }
    
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
