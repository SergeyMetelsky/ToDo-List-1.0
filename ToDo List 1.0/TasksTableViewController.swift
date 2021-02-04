//
//  TasksTableViewController.swift
//  ToDo List 1.0
//
//  Created by Sergey on 1/29/21.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    var objects: [Task] = [
        Task(rating: 0, taskText: "Заправить постель", isDone: false),
        Task(rating: 0, taskText: "Почистить зубы", isDone: false),
        Task(rating: 0, taskText: "Закипятить воду", isDone: false),
        Task(rating: 0, taskText: "Одеться", isDone: false),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Just do it"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem!.image = UIImage(systemName: "minus")
    }
    
    @IBAction func unwingSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        
        let sourceViewController = segue.source as! NewTaskTableViewController
        let task = sourceViewController.task
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            objects[selectedIndexPath.row] = task
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            objects.append(task)
            sortArrayOfTasks()
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "editTask" else { return }
        
        let indexPath = tableView.indexPathForSelectedRow!
        let task = objects[indexPath.row]
        let navigationViewController = segue.destination as! UINavigationController
        let newTaskViewController = navigationViewController.topViewController as! NewTaskTableViewController
        
        newTaskViewController.task = task
        
        newTaskViewController.title = "Edit"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        
        let object = objects[indexPath.row]

        switch object.rating {
        case 1:
            cell.contentView.backgroundColor = .systemGray4
        case 2:
            cell.contentView.backgroundColor = .systemGray2
        case 3:
            cell.contentView.backgroundColor = .systemGray
        case 0:
            cell.contentView.backgroundColor = .yellow
        default:
            break
        }
        
        cell.ratingLabel.text = object.rating == 0 ? "?" : String(object.rating) + "."
        cell.ratingLabel.textColor = cell.ratingLabel.text == "?" ? .systemRed : .black

        //зачеркивание строки
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: object.taskText)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        if !object.isDone {
            cell.taskTextLabel.attributedText = nil
            cell.taskTextLabel.text = object.taskText
        } else {
            cell.taskTextLabel.attributedText =  attributeString
        }


        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

//---------------------------leadingSwipeActions
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let ratingOne = setRating(1, at: indexPath)
        let ratingTwo = setRating(2, at: indexPath)
        let ratingThree = setRating(3, at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [done, ratingOne, ratingTwo, ratingThree])
    }
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let ratingOne = setRatingOne(at: indexPath)
//        return UISwipeActionsConfiguration(actions: [ratingOne]) //  проблема с установкой экшенов справа
//    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = objects[indexPath.row]

        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completion) in
            // сюда надо всунуть зачеркивание таски
            
            object.isDone = !object.isDone
            self.objects[indexPath.row] = object
            self.tableView.reloadData()
            completion(true)
        }
        action.backgroundColor = .systemGreen
        return action
    }
    
    func setRating(_ rating: Int, at indexPath: IndexPath) -> UIContextualAction {
        var object = objects[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: String(rating)) { (action, view, completion) in
            object.rating = rating
            self.objects[indexPath.row] = object
            self.tableView.reloadData()
            self.sortArrayOfTasks()
            
            completion(true)
        }
        
        switch rating {
        case 1:
            action.backgroundColor = .systemGray4
        case 2:
            action.backgroundColor = .systemGray2
        case 3:
            action.backgroundColor = .systemGray
        default:
            break
        }
        return action
    }
    
    func sortArrayOfTasks() {
        self.objects = self.objects.sorted {
            $0.rating < $1.rating
        }
    }
}
