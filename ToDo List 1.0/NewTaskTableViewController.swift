//
//  NewTaskTableViewController.swift
//  ToDo List 1.0
//
//  Created by Sergey on 2/1/21.
//

import UIKit

class NewTaskTableViewController: UITableViewController {
    
    var task = Task(rating: 0, taskText: "", isDone: false)

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var newTaskTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "New task"
        
        
        updateUI()
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let newTaskText = newTaskTextField.text ?? "" // если текста нет, то равен пустой строке
        
        saveButton.isEnabled = !newTaskText.isEmpty
    }
    
    private func updateUI() {
        newTaskTextField.text = task.taskText
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }
        
        let taskText = newTaskTextField.text ?? ""
        
        self.task = Task(rating: self.task.rating, taskText: taskText, isDone: self.task.isDone)
    }
}
