//
//  NotificationVC.swift
//  Smartech Demo
//
//  Created by Apple on 11/04/22.
//

import UIKit
import SmartechAppInbox

class AppInboxController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var appInboxArray: [SMTAppInboxMessage]?
    var appInboxCategoryArray: [SMTAppInboxCategoryModel]?
    var pullControl = UIRefreshControl()
//    var firstViewed = false
    
    static let tableViewCellIdentifier = "appinboxCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //        SmartechAppInbox.sharedInstance().getViewController()
        fetchDataFromNetcore()
        setupPullToRefresh()
        messageTypes()
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.appBecomeActive), name: NSNotification.Name.UIApplication.willEnterForeground, object: nil )
    }
    
    @objc func appBecomeActive() {
        //reload your Tableview here
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NSLog("SMTLOGGER WILL APPEAR :")
        setupPullToRefresh()
        var All = SmartechAppInbox.sharedInstance().getMessages(SMTAppInboxMessageType.all)
        print("SMT ALL:: \(All.description)")
        
    }
    
    func fetchDataFromNetcore() {
        appInboxArray = []
        appInboxCategoryArray = SmartechAppInbox.sharedInstance().getCategoryList()
        appInboxArray = SmartechAppInbox.sharedInstance().getMessageWithCategory(appInboxCategoryArray as? NSMutableArray)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.appInboxArray?.count ?? 0 > 0{
                self.tableView.backgroundView = nil
                print("ENTERED VC")
            }
            else{
                print("ENTERED DATA VC")
                //                self.tableView.backgroundView = .appearance()
                //
            }
            print(self.appInboxArray as Any)
            print(self.appInboxCategoryArray as Any)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the table view
        
        return self.appInboxArray?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        appInboxArray = []
        appInboxCategoryArray = SmartechAppInbox.sharedInstance().getCategoryList()
        appInboxArray = SmartechAppInbox.sharedInstance().getMessageWithCategory(appInboxCategoryArray as? NSMutableArray)
        
        let inboxEvent = appInboxArray?[indexPath.row] as? SMTAppInboxMessage
        
        let notificationPayload = inboxEvent?.payload
        let notificationCategory = notificationPayload?.aps.category
        var cell = tableView.dequeueReusableCell(withIdentifier: AppInboxCellTableViewCell.identifier)
        
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: AppInboxCellTableViewCell.identifier)
        }
        cell?.textLabel?.text = notificationPayload?.aps.alert.title
        cell?.detailTextLabel?.text = notificationPayload?.aps.alert.body
        print(cell?.detailTextLabel?.text! ?? "EMPTY")
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appInboxArray = SmartechAppInbox.sharedInstance().getMessageWithCategory(appInboxCategoryArray as? NSMutableArray)
        
        let selectedItem = appInboxArray?[indexPath.row] as? SMTAppInboxMessage
        
        
        SmartechAppInbox.sharedInstance().markMessage(asViewed: selectedItem)
        SmartechAppInbox.sharedInstance().markMessage(asClicked: selectedItem, withDeeplink: selectedItem?.payload?.smtPayload.deeplink)
        
    }
    }



extension AppInboxController: UITableViewDelegate, UITableViewDataSource{
    
    func setupPullToRefresh(){
        
        SmartechAppInbox.sharedInstance().getMessage(SmartechAppInbox.sharedInstance().getPullToRefreshParameter()) { [] error, status in
            
            if (status) {
                
                // Refresh your data
                
                self.fetchDataFromNetcore()
                self.refreshViews()
                
            }else{
                
                DispatchQueue.main.async{
                    
                    self.pullControl.endRefreshing()
                    
                }
                print("status:\(status)")
            }
            
        }
        
    }
    
    func refreshViews(){
        
        DispatchQueue.main.async {
            
            self.pullControl.endRefreshing()
            self.tableView.contentOffset = CGPoint.zero
            
        }
        
    }
    
    
    func messageTypes(){
        
        var messageTypeAll = SmartechAppInbox.sharedInstance().getMessages(SMTAppInboxMessageType.all)
        var messageTypeRead = SmartechAppInbox.sharedInstance().getMessages(SMTAppInboxMessageType.read)
        var messageTypeUNRead = SmartechAppInbox.sharedInstance().getMessages(SMTAppInboxMessageType.unread)

        NSLog("messageALL:: \(messageTypeAll.count) \n \(messageTypeAll) ,,, ")
        
        NSLog("messageREAD:: \(messageTypeRead.count) \n ,,,\(messageTypeRead)")
        
        NSLog("messageUNREAD:: \(messageTypeUNRead.count) \n ,,,\(messageTypeUNRead))")

    }
    
}
