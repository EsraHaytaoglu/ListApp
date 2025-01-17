//
//  ViewController.swift
//  ListApp
//
//  Created by Esra HAYTAOĞLU on 16.01.2025.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var alertController = UIAlertController()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetch()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteBarButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAlert(title: "Uyarı!",
                     message: "Listedeki bütün elemanları silmek istediğinize emin misiniz?",
                     okButtonTitle: "Vazgeç",
                     defaultButtonTitle: "Evet",
                     defaultButtonHandler: { _ in
            self.data.removeAll()
            self.tableView.reloadData()
        })
    }
    @IBAction func addBarButtonItemTapped(_ sender: UIBarButtonItem) {
        
        presentAddAlert()
        
    }
    func presentAddAlert() {
        
        presentAlert(title: "Yeni Eleman Ekle",
                     message: nil,
                     okButtonTitle: "Vazgeç",
                     defaultButtonTitle: "Ekle",
                     isTextFieldAvailable: true,
                     defaultButtonHandler: { _ in
            let text = self.alertController.textFields?.first?.text
            if text != "" {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedObjectContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedObjectContext)!
                let ListItem = NSManagedObject(entity: entity, insertInto: managedObjectContext)
                ListItem.setValue(text, forKey: "title")
                try? managedObjectContext.save()
                self.fetch()
            } else {
                self.presentWarningAlert()
                
            }
        })
    }
    func presentWarningAlert() {
        presentAlert(title: "Hata", message: "Lütfen bir değer giriniz", okButtonTitle: "Tamam")
        
    }
    func presentAlert(title: String?,
                      message: String?,
                      preferredStyle: UIAlertController.Style = .alert,
                      okButtonTitle: String?,
                      defaultButtonTitle: String? = nil,
                      isTextFieldAvailable: Bool = false,
                      defaultButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        alertController = UIAlertController(title:title, message: message, preferredStyle: preferredStyle)
        let okButton = UIAlertAction(title: okButtonTitle, style: .cancel)
        if defaultButtonTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitle, style: .default,handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
        }
        
        
        if isTextFieldAvailable {
            alertController.addTextField()
        }
        
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    func fetch() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        data = try! managedObjectContext.fetch(fetchRequest)
        tableView.reloadData()
        
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (_, _, _) in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            managedObjectContext.delete(self.data[indexPath.row])
            try? managedObjectContext.save()
            self.fetch()
        }
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            self.presentAlert(title: "Elemanı düzenle",
                              message: nil,
                              okButtonTitle: "Vazgeç",
                              defaultButtonTitle: "Düzenle",
                              isTextFieldAvailable: true,
                              defaultButtonHandler: { _ in
                let text = self.alertController.textFields?.first?.text
                if text != "" {
                    //self.data[indexPath.row] = text!
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedObjectContext = appDelegate.persistentContainer.viewContext
                    self.data[indexPath.row].setValue(text!, forKey: "title")
                    if managedObjectContext.hasChanges {
                        try? managedObjectContext.save()
                    }
                    
                    self.tableView.reloadData()
                } else {
                    self.presentWarningAlert()
                    
                }
            })
        }
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return config
    }
}

