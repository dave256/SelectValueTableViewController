//
//  MasterViewController.swift
//  SelectValueDemo
//
//  Created by David M Reed on 11/24/14.
//  Copyright (c) 2014 David M Reed. All rights reserved.
//

//
//  MasterViewController.swift
//  ClosureTableViewDemo
//
//  Created by David M. Reed on 10/14/14.
//  Copyright (c) 2014 David Reed. All rights reserved.
//

import UIKit
import SelectValueTableViewController

typealias ItemType = String // Int

class MasterViewController: UITableViewController {

    // use didSet so tableview is redisplayed with updated values
    var x : ItemType = ItemType(3) { didSet { self.tableView.reloadData() } }
    var y : ItemType = ItemType(4) { didSet { self.tableView.reloadData() } }
    var z : ItemType = ItemType(5) { didSet { self.tableView.reloadData() } }
    var values = ["x", "y", "z"]


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 

        let varName = values[indexPath.row]
        let value = self.value(forKey: varName) as! ItemType
        cell.textLabel!.text = "\(varName) = \(value)"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "selectRowSegue", sender: indexPath)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectRowSegue" {
            let indexPath = sender as! IndexPath
            let varName = values[indexPath.row]

            let dvc = segue.destination as! SelectValueTableViewController
            dvc.title = "\(values[indexPath.row])"

            // initialize array with either ItemType objects
            var items : [ItemType] = []
            for i in 0..<20 {
                items.append(ItemType(i))
            }

            dvc.registerClass = UITableViewCell.self
            dvc.cellReuseIdentifier = "Cell"
            dvc.listOfItems = items as [AnyObject]
            dvc.selectedItem = self.value(forKey: varName) as AnyObject

            dvc.configureCellClosure = { (cell, indexPath, item) in
                cell.textLabel!.text = "\(item)"
            }

            // set completion call back to update with the selected value
            dvc.selectValueCompletionCallback = { value in
                self.setValue(value as! ItemType, forKey: varName)
            }

            // or can use $0 for the closure parameter
            dvc.selectValueCompletionCallback = {
                self.setValue($0 as! ItemType, forKey: varName)
            }
        }
    }
    
}

