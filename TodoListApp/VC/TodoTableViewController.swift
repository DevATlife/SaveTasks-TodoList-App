//
//  TodoTableViewController.swift
//  TodoListApp
//
//  Created by jear on 2018-12-03.
//  Copyright © 2018 jear. All rights reserved.
//

import UIKit
import CoreData  /*--- (8) ----*/


class TodoTableViewController: UITableViewController {
    
    // /*--- (8) ----*/ below is generic method of fetching result so we have to spesify the <object> that responsible for managing the list
    var resultController: NSFetchedResultsController<Todo>!
   let saveCoreD = saveCoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*--- (8) requiest ----*/
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true) // to sort newset by data (date is the attribute we created in DB)
        
        
        // --- Init
        request.sortDescriptors = [sortDescriptors]  // provide sortDescriptors inside the array 
        resultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: saveCoreD.managedContext,
            sectionNameKeyPath: nil,  // we don't need it here
            cacheName: nil   // we don't need it here
        )
        
        /*---------(15)----------*/
        resultController.delegate = self
        
        // now let's tell it to perform Fetch
        do {
            try resultController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }

 
  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
/*----------------------(9)----------------------------------------------------*/
        return resultController.sections?[section].objects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)

        // Configure the cell...
/*----------------------(10)----------------------------------------------------*/
        let todo = resultController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        
        return cell
    }
    

    
    
    
    
    
    
    
    
    
    
    /*--------------(7)---- adding the swiping action checked/delete-----------------*/
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // TODO: Delete todo
            /*---------- (19)------to delete  permanently------*/
            let todo = self.resultController.object(at: indexPath)
            self.resultController.managedObjectContext.delete(todo)
            do {
                try self.resultController.managedObjectContext.save()
                completion(true)
            } catch {
                print("delete failed: \(error)")
                completion(false)
            }
           /*--------------------------------------------------*/
          
        }
        action.image = #imageLiteral(resourceName: "trash")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
             // TODO: Save todo
            /*---------- (19)------to delete  permanently------*/
            let todo = self.resultController.object(at: indexPath)
            self.resultController.managedObjectContext.delete(todo)
            do {
                try self.resultController.managedObjectContext.save()
                completion(true)
            } catch {
                print("delete failed: \(error)")
                completion(false)
            }
            /*--------------------------------------------------*/
        }
        action.image = #imageLiteral(resourceName: "checked")
        action.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
   /*---------------------------------------------------*/
    
   
    
  /*---------------(20)-----------------------*/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAddTodo", sender: tableView.cellForRow(at: indexPath))  //where showAddTodo  is the identifier that I give to the segue connection
    }
   /*--------------------------------------*/
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
/*---------------(14)--------------sender is the + button -----*/
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddTodoViewController {
            vc.managedContext = resultController.managedObjectContext
        }
 /*-------------------------------------------------*/
        
    /*---------(21) to open the form to edit the cell once you click on the cell ------*/
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddTodoViewController {
            vc.managedContext = resultController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell) {
            }
           /*---------(22) to open the form to edit the cell once you click on the cell ------*/
            if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddTodoViewController {
                vc.managedContext = resultController.managedObjectContext
                if let indexPath = tableView.indexPath(for: cell) {
                    let TODO = resultController.object(at: indexPath)
                    vc.TODO = TODO
                }
            }
        }
        
      /*-----------------------------------------------*/
    }
    

}






/*-----------------------(14) to update the the list with the todos which  come from CoreData -------*/
extension TodoTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                let todo = resultController.object(at: indexPath)  // where resultController is a variable been define in top code
                cell.textLabel?.text = todo.title
            }
        default:
            break
        }
    }
}/*------------------------------*/

