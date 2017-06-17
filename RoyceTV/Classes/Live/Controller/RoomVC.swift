//
//  RoomVC.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/5/12.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit
import IJKMediaFramework
import Kingfisher

import NVActivityIndicatorView
private let kChatToolsViewHeight : CGFloat = 44
private let kGiftlistViewHeight : CGFloat = kScreenH * 0.5
private let kChatContentViewHeight : CGFloat = 200
class RoomVC: UIViewController,Emitterable {

    @IBOutlet weak var bgImageView: UIImageView!
    var anchor : AnchorModel?
  
    fileprivate lazy var chatToolsView : ChatInputView = ChatInputView.loadFromNib()
    fileprivate lazy var giftListView : GiftListView = GiftListView.loadFromNib()
    fileprivate lazy var chatContentView : ChatContentView = ChatContentView.loadFromNib()
    //占位图
    fileprivate lazy var placeHolderImage : UIImageView = {
    
     let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "profile_user_414x414")
        imageView.layoutIfNeeded()
        return imageView
    }()
    fileprivate var ijkPlayer : IJKFFMoviePlayerController?
    fileprivate lazy var socket : SocketTool = SocketTool(addr: "127.0.0.1", port: 8787)
    fileprivate var heartBeatTimer : Timer?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        //键盘监听
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        startContectSever()
        loadAnchorLiveAddress()
    
    }
    
    func startContectSever() -> () {
        DispatchQueue.global().async {
            if self.socket.connectServer() {
                //开始读取消息
               self.socket.startReadMsg()
                //发送心跳包
                self.addHeartBeatTimer()
                // 进入房间消息
                self.socket.sendJoinRoom()
                
                self.socket.delegate = self
                
                
            }
        }
        //链接成功
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputView?.resignFirstResponder()
        chatToolsView.endEditing(true)
        UIView.animate(withDuration: 0.25, animations: {
            self.giftListView.frame.origin.y = kScreenH
        })
    }
    



}
// MARK: - *** UI ***

extension RoomVC{
    
    fileprivate func createUI(){
        
         createBlur()
        
         setupBottomView()
         loadPlaceholdImage()
//         view.addSubview(placeHolderImage)
        
    
    }
    
    fileprivate func createBlur(){
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
        

    }
    fileprivate func setupBottomView() {
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - 44 - kChatContentViewHeight, width: view.bounds.width, height: kChatContentViewHeight)
        chatContentView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.addSubview(chatContentView)
        
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(giftListView)
        giftListView.delegate = self
    }


}
// MARK:- 接受聊天服务器返回的消息
extension RoomVC : SocketDelegate{
    func socket(_ socket: SocketTool, joinRoom user: UserInfo) {
         chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, true))
    }
    
    func socket(_ socket: SocketTool, leaveRoom user: UserInfo) {
         chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, false))
    }
    
    func socket(_ socket: SocketTool, chatMsg: ChatMessage) {
        // 1.通过富文本生成器, 生产需要的富文本
        let chatMsgMAttr = AttrStringGenerator.generateTextMessage(chatMsg.user.name, chatMsg.text)
        
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(chatMsgMAttr)
        print(chatMsgMAttr)
    }
    
    func socket(_ socket: SocketTool, giftMsg: GiftMessage) {
        // 1.通过富文本生成器, 生产需要的富文本
        let giftMsgAttr = AttrStringGenerator.generateGiftMessage(giftMsg.giftname, giftMsg.giftUrl, giftMsg.user.name)
        
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(giftMsgAttr)
    }
    
    
    
    
    
}

// MARK: - *** 视频播放 ***
extension RoomVC {

    fileprivate func loadPlaceholdImage(){
        KingfisherManager.shared.downloader.downloadImage(with: URL(string: (anchor?.pic74)!)!, options: nil, progressBlock: { (p : Int64, p1 : Int64) in
            
        }, completionHandler: { (image : UIImage?, error : NSError?, url : URL?, data : Data?)in
            
            DispatchQueue.main.async {
                  self.bgImageView.image = image;
            }
          
//            self.placeHolderImage.image = UIImage.blurImage(image!, blur: 0.8)
            
        })
        
    
    
    }

    fileprivate func loadAnchorLiveAddress(){
        let activityData = ActivityData(size:nil, message: "加载中", messageFont: UIFont.systemFont(ofSize: 10), type: nil, color: nil, padding: 1, displayTimeThreshold: 2, minimumDisplayTime: 2, backgroundColor: nil, textColor: UIColor.white)
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
         let URLString = "http://qf.56.com/play/v2/preLoading.ios"
        
        let params : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056", "signature" : "f69f4d7d2feb3840f9294179cbcb913f", "roomId" : anchor!.roomid, "userId" : anchor!.uid]
        
        NetworkTools.requestData(.get, URLString: URLString, parameters: params) { (response) in
            
            print(response)
            
            //将response转字典
            let responseDict = response as? [String : Any]
            
            let infoDict = responseDict?["message"] as? [String : Any]
            
            guard let requestUrl = infoDict?["rUrl"] as? String else{ return }
            
            NetworkTools.requestData(.get, URLString: requestUrl, finishedCallback: { (reponse) in
                
                let resultDict = reponse as? [String : Any]
                
                let liveUrl = resultDict?["url"] as? String
                
                self.displayLiveView(liveUrl)
            
            })
            
            
            
   
        }

    
    }
    fileprivate func displayLiveView(_ liveURLString : String?) {
        // 1.获取直播的地址
        guard let liveURLString = liveURLString else {
            return
        }
        
        // 2.使用IJKPlayer播放视频
        let options = IJKFFOptions.byDefault()
        options?.setOptionIntValue(1, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)
        ijkPlayer = IJKFFMoviePlayerController(contentURLString: liveURLString, with: options)
        
        // 3.设置frame以及添加到其他View中
        if anchor?.push == 1 {
            ijkPlayer?.view.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: bgImageView.bounds.width, height: bgImageView.bounds.width * 3 / 4))
            ijkPlayer?.view.center = bgImageView.center
        } else {
            ijkPlayer?.view.frame = bgImageView.bounds
        }
        
        print("bounds:", bgImageView.bounds)
        
        bgImageView.addSubview(ijkPlayer!.view)
        ijkPlayer?.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        // 4.开始播放
        ijkPlayer?.prepareToPlay()
        ijkPlayer?.play()
        
    }



}

// MARK: - *** 心跳包 ***
extension RoomVC {
    
    fileprivate func addHeartBeatTimer() {
        heartBeatTimer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        RunLoop.main.add(heartBeatTimer!, forMode: .commonModes)
    }
    
    @objc fileprivate func sendHeartBeat() {
        socket.sendHeartBeat()
    }
}
// MARK: - *** 事件 ***


extension RoomVC {

    //返回
    @IBAction func backToHome(){
        self.ijkPlayer?.stop()
        self.navigationController?.popViewController(animated: true)

    }
    
    //底部按钮
    @IBAction func starBtn(_ sender: UIButton) {
       
        
        switch sender.tag {
        case 0:
            chatToolsView.textInput.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            UIView.animate(withDuration: 0.25, animations: {
                self.giftListView.frame.origin.y = kScreenH - kGiftlistViewHeight
            })
        case 3:
            print("点击了更多")
        case 4:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmittering(point) : stopEmittering()
        default:
            fatalError("未处理按钮")
        }

        
    }

}
extension RoomVC : ChatInputDelegate,GiftListViewDelegate{
    func chatInput(inputView: ChatInputView, message: String) {
       socket.sendTextMsg(message: message)
    }
    func giftListView(giftView: GiftListView, giftModel: GiftModel) {
       socket.sendGiftMsg(giftName: giftModel.subject, giftURL: giftModel.img2, giftCount: 1)
    }
    
}
// MARK:- 监听键盘的弹出
extension RoomVC {
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification) {
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
        })
    }
}
