//
//  UsersCollectionViewController.swift
//  godori
//
//  Created by KP on 2018-03-21.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit
import CoreData

enum UserSections: Int {
    case users
    case totalNumberOfSections
}

class UsersCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let userCellNibName = "UserCollectionViewCell"
    private let userCellReuseIdentifier = "UserCellIdentifier"
    private let userCellWidth = 240.0
    private let userCellHeight = 240.0
    
    private var resultsController: NSFetchedResultsController<NSManagedObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        initializeResultsController()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView!.register(UINib(nibName: userCellNibName, bundle: nil),
                                      forCellWithReuseIdentifier: userCellReuseIdentifier)
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "선수님들"
        
        // Add button
        let addBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add,
                                                    target: self,
                                                    action: #selector(addUser(sender:)))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: userCellWidth, height: userCellHeight)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return resultsController.sections!.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = resultsController.sections else { fatalError("No sections in results controller") }
        
        return sections[section].numberOfObjects
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userCellReuseIdentifier,
                                                      for: indexPath) as! UserCollectionViewCell
        
        let user = resultsController.object(at: indexPath) as! CDUser
        
        // TO-DO: 6 is the number of random images, get rid of the code smell once image uploading is complete
        cell.userImageView.image = UIImage(named: "sample" + "\(indexPath.row % 6)")?.withRenderingMode(.alwaysOriginal)
        cell.userNameLabel.text = user.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

// MARK: Add User Logic
extension UsersCollectionViewController {
    @objc func addUser(sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "선수 이름을 넣어라", message: "한번 들어오면 못 나간다", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "나 그냥 평범하게 살래", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "타짜 가즈아!", style: .default, handler: { alert -> Void in
            let nameField = ac.textFields![0] as UITextField
            
            if nameField.text != "" {
                guard let moc = self.managedObjectContext else { fatalError("Unable retrieve Managed Object Context") }
                
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "CDUser", into: moc) as! CDUser
                newUser.userID = UUID()
                newUser.name = nameField.text
                newUser.createdAt = Date()
                
                do {
                    try moc.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            } else {
                let errorAlert = UIAlertController(title: "이름 쓰라고", message: "머저리야", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "넵", style: .cancel, handler: {
                    alert -> Void in
                    self.present(ac, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        ac.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "선수 이름"
            textField.textAlignment = .center
        })
        
        present(ac, animated: true, completion: nil)
    }
}

// MARK: Core Data
extension UsersCollectionViewController: NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    func initializeResultsController() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CDUser")
        let firstNameSort = NSSortDescriptor(key: "createdAt", ascending: false)
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
        collectionView?.reloadData()
    }
}

