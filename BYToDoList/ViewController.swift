import UIKit

class ViewController: UITableViewController {
    
    private var todoItems = [ToDoItem]()
    private static var userdefaults : UserDefaults!
    private var longpressRecognizer = UILongPressGestureRecognizer()
    private lazy var datePicker = UIDatePicker()
    let formatter = DateFormatter()
    var isFirst = true
    var presspoint = CGPoint()
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_todo", for: indexPath)
        if indexPath.row < todoItems.count {
            let item = todoItems[indexPath.row]
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.time
            let accessory: UITableViewCellAccessoryType = item.done ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            cell.accessoryType = accessory
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < todoItems.count {
            todoItems[indexPath.row].done = !todoItems[indexPath.row].done
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
   @objc func didLongPressShowDatePicker (_ sender: UILongPressGestureRecognizer) {
        
        
        if longpressRecognizer.state == .began && isFirst {
            
            presspoint = longpressRecognizer.location(in: self.tableView)
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 400, width: 375, height: 162))
            datePicker.datePickerMode = .dateAndTime
            datePicker.minuteInterval = 5
            datePicker.date = Date()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let fromDateTime = formatter.date(from:"\(Date())")
            datePicker.minimumDate = fromDateTime
            datePicker.addTarget(self, action: #selector(didSaveTime(_:)), for: .valueChanged)
            self.view.addSubview(datePicker)
        } else if !isFirst && sender.state == .began{
            for i in self.view.subviews {
                if i is UIDatePicker {
                    i.removeFromSuperview()
                }
            }
        }
        
        isFirst = !isFirst
        
    }
    
    @objc func didSaveTime(_ sender: UIDatePicker) {
        if let indexpath = tableView.indexPathForRow(at: presspoint){
            if indexpath.row < todoItems.count {
                todoItems[indexpath.row].time = formatter.string(from: sender.date)
                tableView.reloadRows(at: [indexpath], with: .automatic)
            }
        }
    }
    
    
    @objc func didTapAddItemButton (_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Todo item", message: "Insert the title of the new to-do item:", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ (_) in
            if let title = alert.textFields?[0].text {
                self.addNewToDoItem(title: title,time: "")
            }
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addNewToDoItem (title: String,time: String) {
        let newIndex = todoItems.count
        todoItems.append(ToDoItem(title: title,time: time))
        tableView.insertRows(at: [IndexPath(row: newIndex,section: 0)], with: .top)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < todoItems.count {
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAddItemButton(_:)))
        ViewController.userdefaults = UserDefaults.standard
        let arr = ViewController.userdefaults.object(forKey: "array") as? [ToDoItem] ?? [ToDoItem]()
        todoItems = arr
        
        longpressRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(didLongPressShowDatePicker(_:)))
        longpressRecognizer.minimumPressDuration = 1.5
        self.tableView.addGestureRecognizer(longpressRecognizer)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ViewController.userdefaults.set(todoItems, forKey: "array")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

