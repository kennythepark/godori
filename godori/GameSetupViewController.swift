//
//  GameSetupViewController.swift
//  godori
//
//  Created by KP on 2018-03-26.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit
import CoreData

class GameSetupViewController: UIViewController {
    
    @IBOutlet weak var gameStartButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var userSelectionTableView: UITableView!
    
    private let cellIdentifier = "userSelectCellz"
    private var users: [CDUser] = []
    private var checked: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        fetchUsers()
        
        userSelectionTableView.delegate = self
        userSelectionTableView.dataSource = self
        userSelectionTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func setupButtons() {
        gameStartButton.layer.cornerRadius = 14.0
        cancelButton.layer.cornerRadius = 14.0
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor.black.cgColor
        
    }
    
    @IBAction func gameStartAction(_ sender: Any) {
        guard let navVC = presentingViewController?.childViewControllers[0] as? UINavigationController,
            let gameVC = navVC.childViewControllers[0] as? GameViewController
            else { return }
        
        var selectedUsers: [CDUser] = []
        
        checked.forEach { index in
            selectedUsers.append(users[index])
        }
        
        if selectedUsers.count >= 2 {
            gameVC.startGameWithNewUsers(selectedUsers)
        } else {
            let errorAlert = UIAlertController(title: "이건 아니지", message: "너가 멀 잘못했는지 생각해봐", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "넵 ㅠㅠ", style: .cancel, handler: nil))
                
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func fetchUsers() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let moc = appDelegate.persistentContainer.viewContext
        
        let usersFetch: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        
        do {
            let fetchedUsers = try moc.fetch(usersFetch)
            users = fetchedUsers
        } catch {
            fatalError("Failed to fetch users: \(error)")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension GameSetupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].name
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                
                guard let indexToRemove = checked.index(of: indexPath.row) else { return }
                checked.remove(at: indexToRemove)
            } else {
                cell.accessoryType = .checkmark
                checked.append(indexPath.row)
            }
        }
    }
    
}
