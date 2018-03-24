//
//  GameViewController.swift
//  godori
//
//  Created by KP on 2018-03-05.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit
import CoreData

private let headerHeight: CGFloat = 200.0

private let gameCellNibName = "GameTableViewCell"
private let gameCellReuseIdentifier = "GameCellIdentifier"

private var resultsController: NSFetchedResultsController<NSManagedObject>!

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        
        gameTableView.register(UINib(nibName: gameCellNibName, bundle: nil),
                               forCellReuseIdentifier: gameCellReuseIdentifier)
    }
}

// MARK: TableView Data Source
extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.zero)
        
        let innerInset: Int = 20
        let startGameButton: UIButton = UIButton(frame: CGRect(x: innerInset,
                                                     y: innerInset,
                                                     width: 1000,
                                                     height: 80))
//                                                     width: Int(headerView.frame.width) - 2 * innerInset,
//                                                     height: Int(headerView.frame.height) - 2 * innerInset))
            
        startGameButton.layer.cornerRadius = 14.0
        startGameButton.setTitle("게임 가즈아!", for: .normal)
        startGameButton.setTitleColor(.white, for: .normal)
        startGameButton.backgroundColor = .blue
        headerView.addSubview(startGameButton)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
    
    
}

// MARK: TableView Delegate
extension GameViewController: UITableViewDelegate {
    
}

// MARK: Core Data
extension GameViewController: NSFetchedResultsControllerDelegate {
    
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
    
}
