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
    
    var label: UILabel?
    var appInboxArray: [SMTAppInboxMessage]?
    var appInboxCategoryArray: [SMTAppInboxCategoryModel]?
    var pullControl = UIRefreshControl()
    //    var firstViewed = false
    
    static let tableViewCellIdentifier = "appinboxCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        //                SmartechAppInbox.sharedInstance().getViewController()
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
       
        var all = SmartechAppInbox.sharedInstance().getMessages(SMTAppInboxMessageType.all)
        var allCount = SmartechAppInbox.sharedInstance().getMessages(SMTAppInboxMessageType.all)
        
        print("SMT ALL:: \(all.description.utf8)")
        
        print("SMT ALL COUNT:: \(allCount.count)")
        
        
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
            print("APPINBOX ARRAY:", self.appInboxArray!)
            print(self.appInboxCategoryArray! as Any)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the table view
        
        return self.appInboxArray?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        appInboxArray = []
        appInboxCategoryArray = SmartechAppInbox.sharedInstance().getCategoryList()
        appInboxArray = SmartechAppInbox.sharedInstance().getMessageWithCategory(appInboxCategoryArray as? NSMutableArray)
        
        let inboxEvent = appInboxArray?[indexPath.row] as? SMTAppInboxMessage
        
        let notificationPayload = inboxEvent?.payload
        let notificationCategory = notificationPayload?.aps.category
        var cell = tableView.dequeueReusableCell(withIdentifier: AppInboxCellTableViewCell.identifier)
        
        
        // HTML string
//        let htmlTitle = notificationPayload?.smtPayload.htTitle
//        
//       
        // Convert HTML string to NSAttributedString
//        if let attributedString = htmlTitle!.htmlToAttributedString {
//            
//            label?.attributedText = attributedString as? NSAttributedString
//            
//        } else {
//            cell?.textLabel?.text = "Failed to load HTML string"
//            
//        }
        
    
    if cell == nil {
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: AppInboxCellTableViewCell.identifier)
    }
        
    let status = appInboxArray?[indexPath.row].status
    let item = appInboxArray?[indexPath.row]
    
    if status != "viewed"{
        SmartechAppInbox.sharedInstance().markMessage(asViewed: item)
    }
    

        cell?.textLabel?.text = notificationPayload?.aps.alert.title
        cell?.detailTextLabel?.text = notificationPayload?.aps.alert.body
    
    
    return cell!
    
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    appInboxArray = SmartechAppInbox.sharedInstance().getMessageWithCategory(appInboxCategoryArray as? NSMutableArray)
    
    let selectedItem = appInboxArray?[indexPath.row] as? SMTAppInboxMessage
    let status = appInboxArray?[indexPath.row].status
    
    if status != "clicked"{
        SmartechAppInbox.sharedInstance().markMessage(asClicked: selectedItem, withDeeplink: selectedItem?.payload?.smtPayload.deeplink)
    }
    
    
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
                NSLog("status:\(status)")
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
        
        let messageTypeAll = SmartechAppInbox.sharedInstance().getMessages(SMTAppInboxMessageType.all)
        let messageTypeRead = SmartechAppInbox.sharedInstance().getMessages(SMTAppInboxMessageType.read)
        let messageTypeUNRead = SmartechAppInbox.sharedInstance().getMessages(SMTAppInboxMessageType.unread)
        
        NSLog("messageALL:: \(messageTypeAll.count) \n \(messageTypeAll)")
        
        NSLog("messageREAD:: \(messageTypeRead.count) \n \(messageTypeRead)")
        
        NSLog("messageUNREAD:: \(messageTypeUNRead.count) \n \(messageTypeUNRead))")
        
    }
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("Error converting HTML to NSAttributedString: \(error.localizedDescription)")
            return nil
        }
    }
}
