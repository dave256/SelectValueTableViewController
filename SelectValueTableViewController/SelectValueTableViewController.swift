//
//  SelectValueTableViewController.swift
//  SelectValueTableViewController
//
//  Created by David M Reed on 11/24/14.
//  Copyright (c) 2014 David M Reed. All rights reserved.
//


import UIKit

// closure to be called when item is selected. it is passed the selected object
public typealias SelectValueCompletionClosure = (_ selectedValue: AnyObject) -> Void

// closure to use to display a cell at the indexPath using the specified object
public typealias ConfigureCellClosure = (_ cell: UITableViewCell, _ indexPath: IndexPath, _ object: AnyObject) -> Void

open class SelectValueTableViewController: UITableViewController {

    // declare closure property that takes a String parameter and returns Void
    open var selectValueCompletionCallback : SelectValueCompletionClosure?
    // or without the typealias
    // var selectValueCompletionCallback : ((selectedValue: Int) -> Void)?

    // must set one of registerClass or registerNib
    // for example: registerClass = UITableViewCell.self
    open var registerClass: AnyClass? = nil
    open var registerNib: UINib? = nil

    // closure to use to display the cell contents
    open var configureCellClosure : ConfigureCellClosure?

    // the UITableViewCell re-use identifier from Interface Builder
    // make optional nil so we get a crash if forget to set
    open var cellReuseIdentifier: String? = nil

    // the list of items to display for selecting one
    open var listOfItems : [AnyObject]?

    // the currently selected item (which will be marked with a checkmark)
    open var selectedItem : AnyObject?

    open override func viewDidLoad() {
        super.viewDidLoad()

        if registerClass != nil {
            self.tableView.register(registerClass!, forCellReuseIdentifier: cellReuseIdentifier!)
        }
        else if registerNib != nil {
            self.tableView.register(registerNib!, forCellReuseIdentifier: cellReuseIdentifier!)
        }
        else {
            print("need to set registerClass or registerNib for SelectValueTableViewController")
            abort()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = listOfItems {
            return items.count
        }
        return 0;
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier!, for: indexPath) 

        cell.accessoryType = UITableViewCellAccessoryType.none
        if let items = listOfItems {
            let item : AnyObject = items[indexPath.row]

            // if user specified a closure for displaying the cell, use it
            if let ccc = configureCellClosure {
                ccc(cell, indexPath, item)
            }
                // otherwise use string interpolation on the object
            else {
                cell.textLabel?.text = "\(item)"
            }

            // if item selected, put a checkmark next to it
            if item.isEqual(selectedItem) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        else {
            cell.textLabel?.text = ""
        }

        return cell
    }

    //----------------------------------------------------------------------
    // MARK: delegate methods
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let items = listOfItems {
            let value: AnyObject = items[indexPath.row]
            // call the closure if it's not nil using optional chaining
            self.selectValueCompletionCallback?(value)
        }
        // return to previous screen after selection
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
