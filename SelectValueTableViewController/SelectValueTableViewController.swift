//
//  SelectValueTableViewController.swift
//  SelectValueTableViewController
//
//  Created by David M Reed on 11/24/14.
//  Copyright (c) 2014 David M Reed. All rights reserved.
//


import UIKit

// closure to be called when item is selected. it is passed the selected object
public typealias SelectValueCompletionClosure = (selectedValue: AnyObject) -> Void

// closure to use to display a cell at the indexPath using the specified object
public typealias ConfigureCellClosure = (cell: UITableViewCell, indexPath: NSIndexPath, object: AnyObject) -> Void

public class SelectValueTableViewController: UITableViewController {

    // declare closure property that takes a String parameter and returns Void
    public var selectValueCompletionCallback : SelectValueCompletionClosure?
    // or without the typealias
    // var selectValueCompletionCallback : ((selectedValue: Int) -> Void)?

    // must set one of registerClass or registerNib
    // for example: registerClass = UITableViewCell.self
    public var registerClass: AnyClass? = nil
    public var registerNib: UINib? = nil

    // closure to use to display the cell contents
    public var configureCellClosure : ConfigureCellClosure?

    // the UITableViewCell re-use identifier from Interface Builder
    // make optional nil so we get a crash if forget to set
    public var cellReuseIdentifier: String? = nil

    // the list of items to display for selecting one
    public var listOfItems : [AnyObject]?

    // the currently selected item (which will be marked with a checkmark)
    public var selectedItem : AnyObject?

    public override func viewDidLoad() {
        super.viewDidLoad()

        if registerClass != nil {
            self.tableView.registerClass(registerClass!, forCellReuseIdentifier: cellReuseIdentifier!)
        }
        else if registerNib != nil {
            self.tableView.registerNib(registerNib!, forCellReuseIdentifier: cellReuseIdentifier!)
        }
        else {
            println("need to set registerClass or registerNib for SelectValueTableViewController")
            abort()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = listOfItems {
            return items.count
        }
        return 0;
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! UITableViewCell

        cell.accessoryType = UITableViewCellAccessoryType.None
        if let items = listOfItems {
            let item : AnyObject = items[indexPath.row]

            // if user specified a closure for displaying the cell, use it
            if let ccc = configureCellClosure {
                ccc(cell: cell, indexPath: indexPath, object: item)
            }
                // otherwise use string interpolation on the object
            else {
                cell.textLabel?.text = "\(item)"
            }

            // if item selected, put a checkmark next to it
            if item.isEqual(selectedItem) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        else {
            cell.textLabel?.text = ""
        }

        return cell
    }

    //----------------------------------------------------------------------
    // MARK: delegate methods
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let items = listOfItems {
            var value: AnyObject = items[indexPath.row]
            // call the closure if it's not nil using optional chaining
            self.selectValueCompletionCallback?(selectedValue: value)
        }
        // return to previous screen after selection
        self.navigationController?.popViewControllerAnimated(true)
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
