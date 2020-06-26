//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Peter Cimring on 16/06/2020.
//  Copyright © 2020 com.pcimring. All rights reserved.
//

import UIKit
import TaboolaSDK

extension UIColor {
    static func randomCreation() -> UIColor {
        func randomColorComponent() -> CGFloat {
            return CGFloat.random(in: 0...255) / 255
        }
        return UIColor(red: randomColorComponent(), green: randomColorComponent(), blue: randomColorComponent(), alpha: 1.0)
    }
    
    static func nextColor(index: Int) -> UIColor {
        let colors = [UIColor.red, UIColor.gray, UIColor.lightGray, UIColor.purple, UIColor.blue, UIColor.green, UIColor.yellow]
        return colors[index % colors.count]
    }
}

class ItemsViewController: UITableViewController {
    
    var itemStore = ItemStore() // TODO - replace this with something simpler :)
    let taboolaWidgetRow = 3
    let taboolaFeedRow = 9
    
    var taboolaWidget: TaboolaView!
    var taboolaFeed: TaboolaView!
    var taboolaWidgetHeight: CGFloat = 0.0
    var didLoadFeed = false
    
    lazy var viewId: String = {
        let timestamp = Int(Date().timeIntervalSince1970)
        return "\(timestamp)"
    }()
    
    fileprivate struct TaboolaSection {
        let placement: String
        let mode: String
        let index: Int
        let scrollIntercept: Bool
        
        static let widget = TaboolaSection(placement: "Below Article", mode: "alternating-widget-without-video-1x4", index: 3, scrollIntercept: false)
        static let feed = TaboolaSection(placement: "Feed without video", mode: "thumbs-feed-01", index: 9, scrollIntercept: true)
    }
    
    override func viewDidLoad() {
        
        // Shift the Table View down a wee bit?...
        // TODO - We need an extra container to make that work...
        // See: https://stackoverflow.com/questions/18900428/ios-7-uitableview-shows-under-status-bar

        
        // Create a Widget instance
        taboolaWidget = taboolaView(mode: TaboolaSection.widget.mode,
                                    placement: TaboolaSection.widget.placement,
                                    scrollIntercept: TaboolaSection.widget.scrollIntercept)
        
        // Create a Feed instance
        taboolaFeed = taboolaView(mode: TaboolaSection.feed.mode,
                                  placement: TaboolaSection.feed.placement,
                                  scrollIntercept: TaboolaSection.feed.scrollIntercept)
        
        // Fetch Widget content (as early as possible)
        print("Fetching WIDGET content (on view load)...")
        taboolaWidget.fetchContent()
        print("TaboolaView.widgetHeight()... \(TaboolaView.widgetHeight())")
    }
    
    
    func taboolaView(mode: String, placement: String, scrollIntercept: Bool) -> TaboolaView {
        let taboolaView = TaboolaView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        taboolaView.delegate = self
        taboolaView.mode = mode
        taboolaView.publisher = "sdk-tester-demo"
        taboolaView.pageType = "article"
        taboolaView.pageUrl = "http://www.example.com"
        taboolaView.placement = placement
        taboolaView.targetType = "mix"
        taboolaView.logLevel = .debug
        taboolaView.setExtraProperties(["useOnlineTemplate": true])
        
        taboolaView.setInterceptScroll(scrollIntercept)
        taboolaView.setProgressBarEnabled(true) // enable the scrollbar :)
        //        //Forcing Dark-Mode
        //        taboolaView.setExtraProperties(["darkMode": true])
        return taboolaView
    }
    
    deinit {
        taboolaWidget.reset()
        taboolaFeed.reset()
    }
    
    // Get the row count for the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    // (Populate the nth row of the table)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemStore.allItems[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        // TODO... - create different prototype cells for different row types...
        
        switch indexPath.row {
            
        case TaboolaSection.widget.index:
            
            print("Adding Taboola WIDGET Webview at row: \(indexPath.row)")
            cell.contentView.addSubview(taboolaWidget)
            
        case TaboolaSection.feed.index:
            
            print("Adding Taboola FEED Webview at row: \(indexPath.row)")
            cell.contentView.addSubview(taboolaFeed)
            
        default:
            
            print("Applying 'news item' at row: \(indexPath.row)")
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "Insert some cool content here..."
            cell.backgroundColor = UIColor.nextColor(index: indexPath.row)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            
        case TaboolaSection.widget.index:
            var rowHeight: CGFloat = 0.0
            
            if taboolaWidgetHeight > 0 {
                rowHeight = taboolaWidgetHeight
            }
            
            print("Setting a row height of \(rowHeight) for WIDGET Webview in row: \(indexPath.row)")
            return rowHeight
            
        case TaboolaSection.feed.index:
            print("Setting a row height of \(TaboolaView.widgetHeight()) for FEED Webview in row: \(indexPath.row)")
            return TaboolaView.widgetHeight()
        default:
            print("Setting a row height of 200 for a 'news item' in row: \(indexPath.row)")
            return 200
        }
        
    }
    
}


extension ItemsViewController: TaboolaViewDelegate {
    func taboolaView(_ taboolaView: UIView!, didLoadPlacementNamed placementName: String!, withHeight height: CGFloat) {
        // The Widget and Feed fire the 'didLoadPlacementNamed' callback after loading. We are interested in this event for the Widget only...
        
        
        if placementName == TaboolaSection.widget.placement {
            
            print("WIDGET with placement '\(String(describing: placementName))' loaded successfully. Height of WIDGET Webview = \(height)")
            
            taboolaWidgetHeight = height // Update our global var - so we can refresh the table (below) and change the row height
            
            if !didLoadFeed { // Just in case the Widget fires this event twice - we check a global flag
                didLoadFeed = true
                taboolaFeed.viewID = viewId
                print("Fetching FEED content (after Widget has fully loaded)...")
                taboolaFeed.fetchContent()
                
            }
            print("Reloading the whole table....")
            tableView.beginUpdates() // Refresh the whole table, to force the relevant row to take on the same height as the Widget (see above)
            tableView.endUpdates()
        }
        
        if placementName == TaboolaSection.feed.placement {
            print("FEED Placement '\(String(describing: placementName))' loaded successfully. Height of Feed Webview = \(height)")
        }
        
    }
    
    func taboolaView(_ taboolaView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        print("Placement \(String(describing: placementName)) failed to load because: %@ \(String(describing: error))")
    }
}






