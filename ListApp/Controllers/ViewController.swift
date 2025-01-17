//
//  ViewController.swift
//  ListApp
//
//  Created by Esra HAYTAOĞLU on 16.01.2025.
//

import UIKit

class ViewController: UIViewController {
    
    var alertController = UIAlertController()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
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
                self.data.append((text)!)
                self.tableView.reloadData()
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
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (_, _, _) in
            self.data.remove(at: indexPath.row)
            tableView.reloadData()
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
                    self.data[indexPath.row] = text!
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

