import UIKit

class ContatoTableViewController: UITableViewController {
    // MARK: Properties
    
    var contatos = [Contato]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved contatos, otherwise load sample data.
        if let savedContatos = loadContatos() {
            contatos += savedContatos
        } else {
            // Load the sample data.
            loadContatos()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contatos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ContatoTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContatoTableViewCell
        
        // Fetches the appropriate contato for the data source layout.
        let contato = contatos[indexPath.row]
        
        cell.nameLabel.text = contato.name
        cell.emailLabel.text = contato.email
        cell.photoImageView.image = contato.photo
        cell.ratingControl.rating = contato.rating
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            contatos.removeAtIndex(indexPath.row)
            saveContatos()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let contatoDetailViewController = segue.destinationViewController as! ContatoViewController
            
            // Get the cell that generated this segue.
            if let selectedContatoCell = sender as? ContatoTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedContatoCell)!
                let selectedContato = contatos[indexPath.row]
                contatoDetailViewController.contato = selectedContato
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new contato.")
        }
    }
    
    
    @IBAction func unwindToContatoList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ContatoViewController, contato = sourceViewController.contato {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing contato.
                contatos[selectedIndexPath.row] = contato
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new contato.
                let newIndexPath = NSIndexPath(forRow: contatos.count, inSection: 0)
                contatos.append(contato)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // Save the contatos.
            saveContatos()
        }
    }
    
    // MARK: NSCoding
    
    func saveContatos() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(contatos, toFile: Contato.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save contatos...")
        }
    }
    
    func loadContatos() -> [Contato]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Contato.ArchiveURL.path!) as? [Contato]
    }
}
