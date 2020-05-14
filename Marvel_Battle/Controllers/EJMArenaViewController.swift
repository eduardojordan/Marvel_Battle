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
    
    var getName1 = ""
    var getImage1 = URL(string: "")
    var getComics1 = 0
    
    var getName2 = ""
    var getImage2 = URL(string: "")
    var getComics2 = 0
    
    var winner = ""
    var combatWinnerCounter = +1
    
    func addItemViewController(_ controller: EJMSearchViewController?, didFinishEnteringItem item: DataCharacter?) {
        self.getName1 = (item?.name)!
        self.getImage1 = item?.image
        self.getComics1 = item!.totalComics
        print("COMBATIENTE (1)",getName1)
    }
    
    func addItemViewController2(_ controller: EJMSearchViewController?, didFinishEnteringItem item: DataCharacter?) {
        self.getName2 = (item?.name)!
        self.getImage2 = item?.image
        self.getComics2 = item!.totalComics
        print("COMBATIENTE (2)",getName2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  self.navigationController?.navigationBar.topItem?.title = "title"
        
        
        
        
        //        let logo = UIImage(named: "MarvelBattleHorizontalLogo.png")
        //             let imageView = UIImageView(image:logo)
        //             imageView.contentMode = UIView.ContentMode.scaleAspectFit
        //             self.navigationItem.titleView = imageView
        
        //super.tabBarController?.title = "Arena"
        //   super.tabBarController?.
        
        selectHero1.addTarget(self, action:#selector(actionSelectHero1), for: .touchUpInside)
        selectHero2.addTarget(self, action:#selector(actionSelectHero2), for: .touchUpInside)
        combatBButton.addTarget(self, action:#selector(actionCombat), for: .touchUpInside)
    }
    
    @objc func actionSelectHero1(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "EJMSearchViewController") as! EJMSearchViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        
        nameHero1Label.text = self.getName1
        print(">",self.getName1)
        if getImage1 != nil {
            let pathString = "http://i.annihil.us" + getImage1!.path + "/portrait_xlarge.jpg"
            let url = URL(string: pathString)
            if  url == nil {
                imageHero1.image = UIImage(named: "imgNotAvailable.jpg")
            }else{
                imageHero1.image = UIImage(url: url)
            }
        }
    }
    
    
    @objc func actionSelectHero2(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "EJMSearchViewController") as! EJMSearchViewController
        controller.delegate2 = self
        self.present(controller, animated: true, completion: nil)
        
        nameHero2Label.text = self.getName2
        print(">",self.getName2)
        if getImage2 != nil {
            let pathString = "http://i.annihil.us" + getImage2!.path + "/portrait_xlarge.jpg"
            let url = URL(string: pathString)
            if  url == nil {
                imageHero2.image = UIImage(named: "imgNotAvailable.jpg")
            }else{
                imageHero2.image = UIImage(url: url)
            }
        }
    }
    
    @objc func actionCombat(){
        
        isFighterIsNil()
        isFighterIsSame()
        FightersIsOnlyOne()
        FighterReady()
        
    }
    
    func isFighterIsNil(){
        if (self.getName1 == "" && self.getName2 == "") {
            print("DEBE SELECCIONAR 2 HEROES")
            let alert = UIAlertController(title: "Attention", message: "You must select 2 marvel heroes", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func isFighterIsSame(){
        if (self.getName1 == self.getName2)  {
            print("COMBATIENTES",self.getName1, self.getName2)
            
            print("EL RESULTADO SIEMPRE SERA EMPATE")
            let alert = UIAlertController(title: "Attention", message: "They must be different super heroes", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func FightersIsOnlyOne(){
        if (self.getName1 == "" || self.getName2 == ""){
            print("DEBE COLOCAR 2 ")
            
            let alert = UIAlertController(title: "Attention", message: "Must have 2 fighters", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func FighterReady(){
        // WIN BIGGER COMICS SHOW
        let win = max(self.getComics1, self.getComics2)
        print("COMBAT \((self.getName1,self.getComics1)) vs \((self.getName2,self.getComics2))")
        
        if win == self.getComics1 {
            self.winner = self.getName1
        } else {
            self.winner = self.getName2
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
            print("NO ESTA GRABADO EN COREDATA Y SE SALVA")
            saveIncoredata(winner: self.winner, combatWinnerCounter: self.combatWinnerCounter)
        } else {
            print("ESTA GRABADO EN COREDATA Y SE ACTUALIZA")
            updateCoredata(winner: self.winner, combatWinnerCounter: self.combatWinnerCounter)
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

func saveIncoredata(winner: String, combatWinnerCounter: Int){
    
    print("COREDATA SAVE!!")
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContex = appDelegate.persistentContainer.viewContext
    let userEntity = NSEntityDescription.entity(forEntityName: "CharacterEntity", in: managedContex)!
    let character = NSManagedObject(entity: userEntity, insertInto: managedContex)
    
    character.setValue( combatWinnerCounter, forKey: "combatWinner")
    character.setValue( winner, forKey: "nameChracter")
    
    do{
        try managedContex.save()
    }catch let error as NSError{
        print("Could not save \(error)")
    }
    
}

func updateCoredata(winner: String, combatWinnerCounter: Int){
    
//    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//    let managedContex = appDelegate.persistentContainer.viewContext
//    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CharacterEntity")
//    //
//    fetchRequest.predicate = NSPredicate(format: "combatWinner = %@" , winner)
//   // fetchRequest.predicate = NSPredicate(format: "combatWinnerCounter = %d", combatWinnerCounter)
//    //
//    do {
//        let test = try managedContex.fetch(fetchRequest)
//        let objectUpdate = winner as! NSManagedObject
//       
//        objectUpdate.setValue( combatWinnerCounter, forKey: "combatWinnerCounter")
//        //            objectUpdate.setValue( self.price, forKey: "product_price")
//        //            print("objectUpdate2 ->",objectUpdate)
//        do{
//            try managedContex.save()
//            //               // self.tableViewOrder.reloadData()
//        }
//    } catch{
//        print(error)
//    }
    
}


extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
