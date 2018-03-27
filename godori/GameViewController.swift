//
//  GameViewController.swift
//  godori
//
//  Created by KP on 2018-03-05.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var newGameButton: UIButton!
    
    private let headerHeight: CGFloat = 100
    
    private let gameCellNibName = "GameTableViewCell"
    private let gameCellReuseIdentifier = "GameCellIdentifier"
    
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
        
        for users in selectedUsers {
            print(users.name)
        }
        
    }
}

// MARK: TableView Data Source
extension GameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = resultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: gameCellReuseIdentifier, for: indexPath)
        
        // Set up the cell
        guard let object = self.resultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        return cell
    }
    
    
}

// MARK: TableView Delegate
extension GameViewController: UITableViewDelegate {
    
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
        } catch let error as NSError {
            print("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // TODO:
        gameTableView?.reloadData()
    }
    
}
