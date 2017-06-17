//
//  ChatContentView.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/6/6.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit
private let kChatCell = "chatCell"
class ChatContentView: UIView {
    fileprivate lazy var messages : [NSAttributedString] = [NSAttributedString]()
    fileprivate lazy var tableView : UITableView = {
    
    //数据源
  
    
        let table = UITableView(frame: CGRect(x: 0, y: 568, width: 350, height: 200), style: .plain)
//        table.backgroundColor = UIColor.clear
        table.separatorStyle = .none
        
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 40
        table.rowHeight = UITableViewAutomaticDimension
        table.register(UINib(nibName: "ChaContentCell", bundle: nil), forCellReuseIdentifier: kChatCell)
        return table
    
    }()
    
    override init(frame: CGRect) {

        super.init(frame: frame)
//        self.backgroundColor = UIColor.red
       
        tableView.backgroundColor = UIColor.red
        addSubview(tableView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //插入消息
    func insertMsg(_ message : NSAttributedString) -> () {
        messages.append(message)
        print(message)
        tableView.reloadData()
        //滚动table
        let indexPath =  IndexPath(row:messages.count - 1, section: 0)
        
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
    }
    
    

}

extension ChatContentView : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatCell, for: indexPath) as! ChaContentCell
        cell.contentLabel.attributedText = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }


}
