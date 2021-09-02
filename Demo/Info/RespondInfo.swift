//
//  Respond.swift
//  Demo
//
//  Created by HK on 2021/8/7.
//

import UIKit

class RespondInfo : NSObject ,NSCoding {
    var code : Int  = 0
    var status : Bool = false
    var msg : String = ""
    var data : String = ""
    var user  = UserInfo()
    var classList = [ClassInfo]()
    var nameList = [UserInfo]()
    var noticeList = [NoticeInfo]()
    var fileList = [FileInfo]()
    var file = FileInfo()
    var drawList = [String]()
    var confirmList = [String]()
    var notConfirmList = [String]()
    var teacherList = [UserInfo]()
    var studentList = [UserInfo]()
    var assistantList = [UserInfo]()
    var monitorList = [UserInfo]()
    
    var unconfirmedVote = [Int]()
    var unconfirmedSignin = [Int]()
    var unconfirmedAnnouncement = [Int]()
    
    func encode(with coder: NSCoder) {
        coder.encode(user , forKey: "user")
    }
    
    required init?(coder: NSCoder) {
        self.user = coder.decodeObject(forKey: "realName") as! UserInfo
    }
    
    override init() {

    }
}
