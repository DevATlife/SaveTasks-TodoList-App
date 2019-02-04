//
//  AddTodoViewController.swift
//  TodoListApp
//
//  Created by jear on 2018-12-03.
//  Copyright © 2018 jear. All rights reserved.
//

import UIKit
/*----(11)-----*/
import CoreData

class AddTodoViewController: UIViewController {
  
    /*----(11)-----*/
    var managedContext: NSManagedObjectContext!   // same managedContext but ended with (!) to force unwrape because we need instance of it
    
    /*------------(22-A)----------*/
    var TODO: Todo?   // NEW VARIABLE type of Todo (DB name or CoreData entities)
    
    
/*--------------(1)---------------------*/
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedBtn: UISegmentedControl!
    @IBOutlet weak var DoneBtn: UIButton!
    @IBOutlet weak var CancelBtn: UIButton!
    /*-----------------------------------*/
   /*--------------(6)---------------------*/
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!  //keyboard push the view up
    /*-----------------------------------*/
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DoneBtn.layer.cornerRadius = 11
        DoneBtn.clipsToBounds = true
        
        CancelBtn.layer.cornerRadius = 11
        CancelBtn.clipsToBounds = true
/*--------------(4)-------keyboard push the view up--------------*/
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
/*-----------(22-C)  to bring the text inside the cell and edit it in form -------*/
        textView.becomeFirstResponder()
        
        if let TODO = TODO {
            textView.text = TODO.title
            textView.text = TODO.title
            segmentedBtn.selectedSegmentIndex = Int(TODO.priority)
        }
/*-----------------------------------*/
    }
    
    /*--------------(5)--------keyboard push the view up-------------*/
    @objc func keyboardWillShow(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
/*--------------(2)---------------------*/
   
    @IBAction func cancelAction(_ sender: UIButton) {
      /*--------------(3)------------close keyboard and return to main view---------*/
       dismiss(animated: true)     // to close the view and return to main view when you click cancel
       textView.resignFirstResponder()   // to hide keyboard as soon as you click cancel
                                          // textView is the name I give to my input field
      /*-----------------------------------*/
    }
    

    @IBAction func doneAction(_: UIButton) {
        print("doneBTn clicked")
        
         /*----(12)---first let check if we have text in inside textView where user type--*/
        
      guard let title = textView.text, !title.isEmpty else{
            return
        }
        
          /*------------(22-B)----------*/
        if let TODO = self.TODO {
            TODO.title = title
            TODO.priority = Int16(segmentedBtn.selectedSegmentIndex)
        } else {
        let todo = Todo(context: managedContext)
        todo.title = title   // .title that attribute comes from CoreData DB
        todo.priority = Int16(segmentedBtn.selectedSegmentIndex)  // .priority that attribute comes from CoreData DB
        todo.date = Date()  // .date that attribute comes from CoreData  DB
        }
      /*----------------------*/
        /*------ (13)telling managedContext to save the above data ------*/
        do {
            try managedContext.save()
            dismiss(animated: true) // only time we want to dismiss is when save is successful
            textView.resignFirstResponder()
        } catch {
            print("Error saving todo: \(error)")
        }
    }
  /*-----------------------------------*/
}
