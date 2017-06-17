//
//  ChatInputView.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/6/5.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit
protocol ChatInputDelegate : class {
    func chatInput(inputView : ChatInputView, message : String)

}
class ChatInputView: UIView, LoadFormNibAle {
    
    weak var delegate : ChatInputDelegate?
    
    fileprivate lazy var emoticonBtn : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    fileprivate lazy var emoticonView : EmoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 250))
    
    @IBOutlet weak var textInput: UITextField!

    @IBOutlet weak var msgSend: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    
    
    
    
    
    @IBAction func textFieldDidEdit(_ sender: UITextField) {
        msgSend.isEnabled = sender.text!.characters.count != 0
    }
    
    @IBAction func sendBtnClick(_ sender: UIButton) {
        // 1.获取内容
        let message = textInput.text!
        
        // 2.清空内容
        textInput.text = ""
        sender.isEnabled = false
        
        // 3.将内容回调出去
        delegate?.chatInput(inputView: self, message: message)
        
    }
    
}
extension ChatInputView {
    fileprivate func setupUI() {
        
        // 0.测试: 让textFiled显示`富文本`
        /*
         let attrString = NSAttributedString(string: "I am fine", attributes: [NSForegroundColorAttributeName : UIColor.green])
         let attachment = NSTextAttachment()
         attachment.image = UIImage(named: "[大哭]")
         let attrStr = NSAttributedString(attachment: attachment)
         inputTextField.attributedText = attrStr
         */
        
        
        // 1.初始化inputView中rightView
        emoticonBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emoticonBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emoticonBtn.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        
        textInput.rightView = emoticonBtn
        textInput.rightViewMode = .always
        textInput.allowsEditingTextAttributes = true
        
        // 2.设置emotionView的闭包(weak当对象销毁值, 会自动将指针指向nil)
        // weak var weakSelf = self
        emoticonView.emoticonClickCallback = {[weak self] emoticon in
            // 1.判断是否是删除按钮
            if emoticon.emoticonName == "delete-n" {
                self?.textInput.deleteBackward()
                return
            }
            
            // 2.获取光标位置
            guard let range = self?.textInput.selectedTextRange else { return }
            self?.textInput.replace(range, withText: emoticon.emoticonName)
        }
    }
}

extension ChatInputView {
    @objc fileprivate func emoticonBtnClick(_ btn : UIButton) {
        btn.isSelected = !btn.isSelected
        
        // 切换键盘
        let range = textInput.selectedTextRange
        textInput.resignFirstResponder()
        textInput.inputView = textInput.inputView == nil ? emoticonView : nil
        textInput.becomeFirstResponder()
        textInput.selectedTextRange = range
    }
}
