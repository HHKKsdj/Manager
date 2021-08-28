//
//  NoticeInfo.swift
//  Demo
//
//  Created by HK on 2021/8/11.
//

import UIKit

class NoticeInfo: NSObject {
    var type : String = ""
    
    var classID : String = ""
    var publisher : String = ""
    var publishTime : String = ""
    var deadline : String = ""
    var title : String = ""
    
//Announcement
    var nid : Int = 0
    var body : String = ""
    var confirm : Bool = false
//Vote
    var vid : Int = 0
    var selections : [String] = []
    var limitation : Int = 0
    var anonymous : Bool = false
    var selectedNum : [Int] = []
    var selectorList : [[String]] = []
//Draw
    var drawList : [String] = []
//AskQuestion
    var scoreList : [String] = []
//Signin
    var signType : String = ""
    var signID : Int = 0
    var totalNum : Int = 0
    var signedNum : Int = 0
}
