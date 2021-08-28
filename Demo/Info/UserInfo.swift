//
//  UserInfo.swift
//  Demo
//
//  Created by HK on 2021/8/8.
//

import UIKit

class UserInfo: NSObject, NSCoding {
    
    var realName : String = ""
    var img_path : String = ""
    var uid : Int = 0
    var username : String = ""
    var mailAddr : String = ""
    var role : String = ""
    var evalution : Int = 0
    var mobileNum : String = ""
    var status : Int = 0
    var point : Int = 0
    
    func encode(with coder: NSCoder) {
        coder.encode(realName , forKey: "realName")
        coder.encode(img_path, forKey: "img_path")
        coder.encode(uid, forKey: "uid")
        coder.encode(username, forKey: "username")
        coder.encode(mailAddr, forKey: "mailAddr")
        coder.encode(role, forKey: "role")
        coder.encode(evalution, forKey: "evalution")
        coder.encode(mobileNum, forKey: "mobileNum")
        coder.encode(status, forKey: "status")
    }
    
    required init?(coder: NSCoder) {
        self.realName = coder.decodeObject(forKey: "realName") as! String
        self.img_path = coder.decodeObject(forKey: "img_path") as! String
        self.username = coder.decodeObject(forKey: "username") as! String
        self.mailAddr = coder.decodeObject(forKey: "mailAddr") as! String
        self.role = coder.decodeObject(forKey: "role") as! String
        self.mobileNum = coder.decodeObject(forKey: "mobileNum") as! String
        self.uid = coder.decodeInteger(forKey: "uid")
        self.evalution = coder.decodeInteger(forKey: "evalution")
        self.status = coder.decodeInteger(forKey: "status")
    }
    
    override init() {

    }
}
