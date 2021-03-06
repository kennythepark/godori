//
//  GameViewController.swift
//  godori
//
//  Created by KP on 2018-03-05.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit
import CoreData

private let headerHeight: CGFloat = 100

private let gameCellNibName = "GameTableViewCell"
private let gameCellReuseIdentifier = "GameCellIdentifier"

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var newGameButton: UIButton!

    var selectedGame: CDSession?
    
    private var resultsController: NSFetchedResultsController<NSManagedObject>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartGameButton()
        initializeResultsController()
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: gameCellNibName, bundle: nil),
                               forCellReuseIdentifier: gameCellReuseIdentifier)
    }
}

// MARK: UIButton Related
extension GameViewController {
    func setupStartGameButton() {
        newGameButton.layer.cornerRadius = 14.0
        newGameButton.setTitle("새로운 게임 가즈아!", for: .normal)
    }
    
    @IBAction func startNewGame(_ sender: Any) {
        performSegue(withIdentifier: "toSetup", sender: self)
    }
    
    func startGameWithNewUsers(_ selectedUsers: [CDUser]) {
        // Dismiss setup view controller
        dismiss(animated: true, completion: nil)
        
        guard let moc = self.managedObjectContext else { fatalError("Unable retrieve Managed Object Context") }
        
        let newGame = NSEntityDescription.insertNewObject(forEntityName: "CDSession", into: moc) as! CDSession
        newGame.createdAt = Date()
        newGame.addToUsers(NSSet(array: selectedUsers))
        
        // Create ledger
        let newLedger = NSEntityDescription.insertNewObject(forEntityName: "CDLedger", into: moc) as! CDLedger
        newLedger.session = newGame
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}

// MARK: TableView Related
extension GameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = resultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: gameCellReuseIdentifier, for: indexPath)
        
        let game = resultsController.object(at: indexPath) as! CDSession
        
        var cellText = ""

        for case let user as CDUser in game.users! {
            cellText.append(user.name! + "     ")
        }
        
        cell.textLabel?.text = cellText
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = resultsController.object(at: indexPath) as! CDSession
        selectedGame = game
        
        performSegue(withIdentifier: "toGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            if let gamePlayVC = segue.destination as? GamePlayViewController {
                guard let selectedGame = selectedGame else { return }
                gamePlayVC.session = selectedGame
            }
        }
    }
}

// MARK: Core Data
extension GameViewController: NSFetchedResultsControllerDelegate {
    
    // TODO: create singleton to manage this, ideally with all the core data stuff
    var managedObjectContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    func initializeResultsController() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CDSession")
        let firstNameSort = NSSortDescriptor(key: "createdAt", ascending: true)
        request.sortDescriptors = [firstNameSort]
        
        guard let moc = managedObjectContext else { fatalError("Unable retrieve Managed Object Context") }
        resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        
        do {
            try resultsController.performFetch()
            print("\(Date()) : GameViewController's FetchedResultsController has successfully been initialized.")
        } catch let error as NSError {
            print("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // TODO:
        gameTableView?.reloadData()
    }
    
}
