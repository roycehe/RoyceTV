//
//  SocketTool.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/6/6.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit


// MARK: - *** 消息回调 ***
protocol SocketDelegate : class {
    //进入房间
    func socket(_ socket : SocketTool, joinRoom user : UserInfo)
    //离开房间
    func socket(_ socket : SocketTool, leaveRoom user : UserInfo)
    //平台消息
    func socket(_ socket : SocketTool, chatMsg : ChatMessage)
    //礼物消息
    func socket(_ socket : SocketTool, giftMsg : GiftMessage)
}


class SocketTool{
    weak var delegate : SocketDelegate?
    //联系客户端
    fileprivate var tcp : TCPClient
    //用户model
    fileprivate var userInfo : UserInfo.Builder = {
    
        let userInfo = UserInfo.Builder()
        userInfo.name = "大神🍅\(arc4random_uniform(10))"
        userInfo.level = 20
        userInfo.iconUrl = "icon\(arc4random_uniform(5))"
        return userInfo
    
    }()
    init(addr : String, port : Int) {
        tcp = TCPClient(addr: addr, port: port)
    }
    func connectServer() -> Bool {
        return tcp.connect(timeout: 5).0
    }
    
    //开始读取消息
    
    func startReadMsg(){
        DispatchQueue.global().async {
            
            while true {
                //检查是否有数据
                guard let MsgLenght = self.tcp.read(4) else { continue }
                
            //获取headerdata长度
                
                let headData = Data(bytes: MsgLenght, count: 4)
                var length : Int = 0
                 (headData as NSData).getBytes(&length, length: 4)
                //读取类型

                guard let typeMsg = self.tcp.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type : Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
                
                // 2.根据长度, 读取真实消息
                guard let msg = self.tcp.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)
                
                // 3.处理消息
                DispatchQueue.main.async {
                    self.handleMsg(type: type, data: data)
                }
            
            }
            
            
        }
    
    }
    
    fileprivate func handleMsg(type : Int, data : Data) {
        switch type {
        case 0, 1:
            let user = try! UserInfo.parseFrom(data: data)
            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
        case 2:
            let chatMsg = try! ChatMessage.parseFrom(data: data)
            delegate?.socket(self, chatMsg: chatMsg)
        case 3:
            let giftMsg = try! GiftMessage.parseFrom(data: data)
            delegate?.socket(self, giftMsg: giftMsg)
        default:
            print("未知类型")
        }
    }


}

extension SocketTool {

  
    
    func sendJoinRoom() {
        // 1.获取消息的长度
        let msgData = (try! userInfo.build()).data()
        
        // 2.发送消息
        sendMsg(data: msgData, type: 0)
    }
    
    func sendLeaveRoom() {
        // 1.获取消息的长度
        let msgData = (try! userInfo.build()).data()
        
        // 2.发送消息
        sendMsg(data: msgData, type: 1)
    }
    
    func sendTextMsg(message : String) {
        // 1.创建TextMessage类型
        let chatMsg = ChatMessage.Builder()
        chatMsg.user = try! userInfo.build()
        chatMsg.text = message
        
        // 2.获取对应的data
        let chatData = (try! chatMsg.build()).data()
        
        // 3.发送消息到服务器
        sendMsg(data: chatData, type: 2)
    }
    
    func sendGiftMsg(giftName : String, giftURL : String, giftCount : Int) {
        // 1.创建GiftMessage
        let giftMsg = GiftMessage.Builder()
        giftMsg.user = try! userInfo.build()
        giftMsg.giftname = giftName
        giftMsg.giftUrl = giftURL
        giftMsg.giftcount = Int32(giftCount)
        
        // 2.获取对应的data
        let giftData = (try! giftMsg.build()).data()
        
        // 3.发送礼物消息
        sendMsg(data: giftData, type: 3)
    }
    
    func sendHeartBeat() {
        // 1.获取心跳包中的数据
        let heartString = "I am is heart beat;"
        let heartData = heartString.data(using: .utf8)!
        
        // 2.发送数据
        sendMsg(data: heartData, type: 100)
    }
    
    func sendMsg(data : Data, type : Int) {
        // 1.将消息长度, 写入到data
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        
        // 2.消息类型
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 3.发送消息
        let totalData = headerData + typeData + data
        tcp.send(data: totalData)
    }




}
