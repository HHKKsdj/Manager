//
//  ClassNetwork.swift
//  Demo
//
//  Created by HK on 2021/8/9.
//

import Alamofire
import SwiftyJSON

class ClassNetwork {
    static let shared = ClassNetwork()
//MARK: MyClass
    func MyClassRequest( _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let url = "http://goback.jessieback.top/classes/getMyClass"
        AF.request(url,method: .get,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    if json["code"].intValue == 200 {
                        info.code = json["code"].intValue
                        let data = json["data"]
                        
                        for (_,item):(String,JSON) in data {
                            let clas = ClassInfo()
                            clas.score = item["score"].intValue
                            clas.stuName = item["stuName"].stringValue
                            clas.classId = item["classID"].stringValue
                            clas.name = item["name"].stringValue
                            info.classList.append(clas)
                        }
                    }
                    
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: MyCreatedClass
    func MyCreatedClassRequest( _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let url = "http://goback.jessieback.top/classes/getMyCreatedClass"
        AF.request(url,method: .get,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    if json["code"].intValue == 200 {
                        info.code = json["code"].intValue
                        let data = json["data"]
                        
                        for (_,item):(String,JSON) in data {
                            let clas = ClassInfo()
                            clas.schedule = item["schedule"].stringValue
                            clas.name = item["name"].stringValue
                            clas.classId = item["id"].stringValue
                            clas.college = item["college"].stringValue
                            clas.teacher = item["teacher"].stringValue
                            info.classList.append(clas)
                        }
                    }
                    
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: CreatClass
    func CreatClassRequest(name:String, schedule:String, college:String,_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["name":name,"schedule":schedule,"college":college]
        
        let url = "http://goback.jessieback.top/classes/createClass"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    info.code = json["code"].intValue
                    info.data = json["data"].stringValue
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: JoinClass
    func JoinClassRequest(classID:String,_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]
        
        let url = "http://goback.jessieback.top/classes/\(classID)/join"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    info.code = json["code"].intValue
                    info.msg = json["msg"].stringValue
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: AutoAccept
    func AutoAcceptRequest(classID:String,enable:Bool , _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"enable":enable]
        
        let url = "http://goback.jessieback.top/classes/\(classID)/autoAccept"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    info.code = json["code"].intValue
                    
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: IfAutoAccept
    func IfAutoAcceptRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]
        
        let url = "http://goback.jessieback.top/classes/\(classID)/autoAccept"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    info.code = json["code"].intValue
                    info.msg = json["msg"].stringValue
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: GetStudent
    func GetStudentRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]
        
        let url = "http://goback.jessieback.top/classes/\(classID)/getStuList"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    
                    if json.count != 0 {
                        for (_,item):(String,JSON) in json {
                            let name = UserInfo()
                            name.username = item["username"].stringValue
                            name.realName = item["realName"].stringValue
                            name.point = item["points"].intValue
                            info.nameList.append(name)
                        }
                    }
                    
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: GetMember
    func GetMemberRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]
            
        let url = "http://goback.jessieback.top/classes/\(classID)/ClassMembers"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    print(json)
                        
                    if json.count != 0 {
                        let teacher = json["teacher"]
                        let assistant = json["assistant"]
                        let student = json["student"]
                        let monitor = json["monitor"]
                        
                        for (_,item):(String,JSON) in teacher {
                            let name = UserInfo()
                            name.username = item["username"].stringValue
                            name.realName = item["realName"].stringValue
                            name.point = item["points"].intValue
                            name.role = "teacher"
                            info.teacherList.append(name)
                        }
                        for (_,item):(String,JSON) in assistant {
                            let name = UserInfo()
                            name.username = item["username"].stringValue
                            name.realName = item["realName"].stringValue
                            name.point = item["points"].intValue
                            name.role = "assistant"
                            info.assistantList.append(name)
                        }
                        for (_,item):(String,JSON) in student {
                            let name = UserInfo()
                            name.username = item["username"].stringValue
                            name.realName = item["realName"].stringValue
                            name.point = item["points"].intValue
                            name.role = "student"
                            info.studentList.append(name)
                        }
                        for (_,item):(String,JSON) in monitor {
                            let name = UserInfo()
                            name.username = item["username"].stringValue
                            name.realName = item["realName"].stringValue
                            name.point = item["points"].intValue
                            name.role = "monitor"
                            info.monitorList.append(name)
                        }
                    }
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }

//MARK: PublishNotice
    func PublishNoticeRequest(classID:String,title:String,body:String,deadLine:String,isPublic:Bool,students:[String], _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
//        let parameters : [String:Any] = ["classID":classID,"title":title,"body":body,"confirm":false]
        let parameters : [String:Any] = ["classID":classID,"title":title,"body":body,"confirm":true,"deadLine":deadLine,"isPublic":isPublic,"students":students,"public":true]
        let url = "http://goback.jessieback.top/classes/\(classID)/publishNotice"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    info.code = json["code"].intValue
                    info.msg = json["msg"].stringValue
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: PublishVote
    func PublishVoteRequest(classID:String,title:String,selections:[String],limitation:Int,anonymous:Bool,deadLine:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let test = selections.joined(separator: ",")
        
        let parameters : [String:Any] = ["classID":classID,"title":title,"selections":test,"limitation":limitation,"anonymous":anonymous,"deadLine":deadLine]
//        let parameters : [String:Any] = ["classID":classID,"title":title,"selections":selections,"limitation":limitation,"anonymous":anonymous,"deadLine":deadLine]
        let url = "http://goback.jessieback.top/classes/\(classID)/createVote"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    info.code = json["code"].intValue
                    
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: PublishSignin
    func PublishSigninRequest(classID:String,key:String,title:String,startTime:String,deadLine:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"title":title,"key":key,"deadLine":deadLine]
    //       let parameters : [String:Any] = ["classID":classID,"title":title,"key":key,"startTim":startTime,"deadLine":deadLine]
        let url = "http://goback.jessieback.top/classes/\(classID)/publishSignIn"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
                    info.code = json["code"].intValue
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: PublishDraw
    func PublishDrawRequest(classID:String,num:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"num":num]

        let url = "http://goback.jessieback.top/classes/\(classID)/RandomStu"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
                    info.code = json["code"].intValue
                    if info.code == 200 {
                        let data = json["data"]
                        for (_,item):(String,JSON) in data {
                            let name = item.string
                            info.drawList.append(name!)
                        }
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: PublishQuestion
    func PublishQuestionRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]

        let url = "http://goback.jessieback.top/classes/\(classID)/CourseRandomStu"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
                    info.code = json["code"].intValue
                    if info.code == 200 {
                        info.data = json["data"].stringValue
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: AddQuestionPoint
    func AddQuestionPointRequest(classID:String,student:String,points:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"student":student,"points":points]

        let url = "http://goback.jessieback.top/classes/\(classID)/addCourseRandomStu"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
                    info.code = json["code"].intValue
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: AddPoint
    func AddPointRequest(classID:String,students:String,points:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"students":students,"points":points]

        let url = "http://goback.jessieback.top/classes/\(classID)/addStuPoints"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
                    info.code = json["code"].intValue
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }

//MARK: GetDraw
    func GetDrawRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]

        let url = "http://goback.jessieback.top/classes/\(classID)/RandomStu"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
                    info.code = json["code"].intValue
                    if info.code == 200 {
                        let data = json["data"]
                        let notice = NoticeInfo()

                        notice.publisher = data["publisher"].stringValue
                        notice.publishTime = data["publishedTime"].stringValue
                        let students = data["students"]
                        for (_,student):(String,JSON) in students {
                            notice.drawList.append(student.stringValue)
                        }
                        
                        notice.type = "活动抽签"
                        info.noticeList.append(notice)
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: GetQuestion
    func GetQuestionRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]

        let url = "http://goback.jessieback.top/classes/\(classID)/CourseRandomStu"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
                    info.code = json["code"].intValue
                    if info.code == 200 {
                        let data = json["data"]
                        let notice = NoticeInfo()
                        let students = data["students"]
                        for (name,item):(String,JSON) in students {
                            notice.drawList.append(name)
                            notice.scoreList.append(item.stringValue)
                        }
                        notice.publisher = data["publisher"].stringValue
                        notice.publishTime = data["publishedTime"].stringValue
                        notice.type = "课堂问答"
                        info.noticeList.append(notice)
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: GetAnnouncement
    func GetAnnouncementRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]
            
        let url = "http://goback.jessieback.top/classes/\(classID)/notice"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    
                    print(json)
                    info.code = json["code"].intValue
                    if info.code == 200 {
                        let data = json["data"]
                        for (_,item):(String,JSON) in data {
                            let notice = NoticeInfo()
                            notice.type = "公告"
                            notice.nid = item["nid"].intValue
                            notice.classID = item["classID"].stringValue
                            notice.title = item["title"].stringValue
                            notice.body = item["body"].stringValue
                            notice.publisher = item["publisher"].stringValue
                            notice.publishTime = item["publishedTime"].stringValue
                            notice.deadline = item["deadLine"].stringValue
                            notice.confirm = item["confirm"].boolValue
                            info.noticeList.append(notice)
                        }
                    }
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    //MARK: GetAnnouncement2
        func GetAnnouncement2Request(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
            let token = UserDefaults.standard.string(forKey: "token")! as String
            let headers : HTTPHeaders = ["token":token]
            let parameters : [String:Any] = ["classID":classID]
                
            let url = "http://goback.jessieback.top/classes/\(classID)/unPublicNotice"
            AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

                switch responds.result {
                    case .success(let value):
                        let json = JSON(value)
                        let info = RespondInfo()
                        
                        print(json)
                        info.code = json["code"].intValue
                        if info.code == 200 {
                            let data = json["data"]
                            for (_,item):(String,JSON) in data {
                                let notice = NoticeInfo()
                                notice.type = "公告"
                                notice.nid = item["nid"].intValue
                                notice.classID = item["classID"].stringValue
                                notice.title = item["title"].stringValue
                                notice.body = item["body"].stringValue
                                notice.publisher = item["publisher"].stringValue
                                notice.publishTime = item["publishedTime"].stringValue
                                notice.deadline = item["deadLine"].stringValue
                                notice.confirm = item["confirm"].boolValue
                                info.noticeList.append(notice)
                            }
                        }
                            
                        completion(nil, info)
                    case .failure(let error):
                        completion(error, nil)
                }
            }
        }
//MARK: GetVote
    func GetVoteRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]

        let url = "http://goback.jessieback.top/classes/\(classID)/getVotes"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
//                    info.code = json["code"].intValue
//                    if info.code == 200 {
//                        let data = json["data"]
//                        for (_,item):(String,JSON) in data {
                    if json.count != 0 {
                        let list = json
                        for (_,item):(String,JSON) in list {
                            
                            let notice = NoticeInfo()
                            notice.type = "投票"
                            notice.vid = item["vid"].intValue
                            notice.classID = item["classID"].stringValue
                            notice.title = item["title"].stringValue
                            notice.publisher = item["publisher"].stringValue
                            notice.deadline = item["deadLine"].stringValue
                            notice.publishTime = item["publishedTime"].stringValue
                            notice.anonymous = item["anonymous"].boolValue
                            notice.limitation = item["limitation"].intValue
                            let selections = item["selections"]
                            for (_,selection):(String,JSON) in selections {
                                notice.selections.append(selection.stringValue)
                            }
                            info.noticeList.append(notice)
                        }
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: GetSignin
    func GetSigninRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]

        let url = "http://goback.jessieback.top/classes/\(classID)/signIn"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
//                    info.code = json["code"].intValue
                    if json.count != 0 {
                        for (_,item):(String,JSON) in json {
                            let notice = NoticeInfo()
                            notice.signType = item["signType"].stringValue
                            notice.signID = item["signID"].intValue
                            notice.classID = item["classID"].stringValue
                            notice.title = item["title"].stringValue
                            notice.deadline = item["deadLine"].stringValue
                            notice.publisher = item["publisher"].stringValue
                            notice.publishTime = item["publishedTime"].stringValue
                            if notice.signType == "key" {
                                notice.type = "手势签到"
                            } else {
                                notice.type = "定时签到"
                            }
                            info.noticeList.append(notice)
                        }
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: VoteDetail
    func VoteDetailRequest(classID:String,vid:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"vid":vid]

        let url = "http://goback.jessieback.top/classes/\(classID)/voteSelections"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
                    info.code = json["code"].intValue
                    if info.code == 200 {
                        let data = json["data"]
                        let notice = NoticeInfo()
                        for (_,item):(String,JSON) in data {
                            notice.selections.append(item["value"].stringValue)
                            notice.selectedNum.append(item["score"].intValue)
                        }
                        info.noticeList.append(notice)
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
    
//MARK: Signin
    func SigninRequest(classID:String,signID:Int,key:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"signID":signID,"key":key]

        let url = "http://goback.jessieback.top/classes/\(classID)/signIn"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                        
                    print(json)
                    info.code = json["code"].intValue

                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: Vote
    func VoteRequest(classID:String,vid:Int,selections:[String], _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"vid":vid,"selections":selections.joined(separator: ",")]

        let url = "http://goback.jessieback.top/classes/\(classID)/vote"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    info.code = json["code"].intValue

                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: Announcement
    func AnnouncementRequest(classID:String,nid:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"nid":nid]

        let url = "http://goback.jessieback.top/classes/\(classID)/notice/confirm"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    info.code = json["code"].intValue

                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: FastUpload
    func FastUploadRequest(classID:String,hash:String,fileName:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"hash":hash,"fileName":fileName]

        let url = "http://goback.jessieback.top/classes/\(classID)/fastUpload"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    info.code = json["code"].intValue

                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: Upload
    func UploadRequest(classID:String,hash:String,fileName:String,fileURL:String,data:Data, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        
        let url = "http://goback.jessieback.top/classes/\(classID)/upload"
        AF.upload(multipartFormData: { uploads in
            uploads.append(data, withName: "upload", fileName: fileName, mimeType: "application/octet-stream")
        },to: url,method: .post, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    info.code = json["code"].intValue
                    info.msg = json["msg"].stringValue
                    info.data = "\(json["data"].intValue)"
                    print(json)
                    completion(nil, info)
                case .failure(let error):
                    print("nil")
                    completion(error, nil)
                }
            }
            .uploadProgress { progress in
                print("当前进度: \(progress.fractionCompleted)")
            }
    }
    

//MARK: UploadImage
    func UploadImageRequest(classID:String,data:Data,fileName:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        
        let url = "http://goback.jessieback.top/classes/\(classID)/upload"
        
        AF.upload(multipartFormData: { uploads in
            uploads.append(data, withName: "upload", fileName: fileName, mimeType: "image/jpeg")
        },to: url,method: .post, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    info.code = json["code"].intValue
                    info.msg = json["msg"].stringValue
                    info.data = "\(json["data"].intValue)"
                    print(json)
                    completion(nil, info)
                case .failure(let error):
                    print("nil")
                    completion(error, nil)
                }
            }
            .uploadProgress { progress in
                print("当前进度: \(progress.fractionCompleted)")
            }
       
    }
    
    
//MARK: DeleteFile
    func DeleteFileRequest(classID:String,fid:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"fid":fid]

        let url = "http://goback.jessieback.top/classes/\(classID)/deleteFile"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    info.code = json["code"].intValue
                    
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: noticeConfirmedStu
    func ConfirmAccouncementRequest(classID:String,nid:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"nid":nid]

        let url = "http://goback.jessieback.top/classes/\(classID)/notice/noticeConfirmedStu"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    info.code = json["code"].intValue
                    if info.code == 200 {
                        let data = json["data"]
                        for (_,item):(String,JSON) in data {
                            info.confirmList.append(item.stringValue)
                        }
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: VoterSelections
    func VoterSelectionsRequest(classID:String,vid:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"vid":vid]

        let url = "http://goback.jessieback.top/classes/\(classID)/voterSelections"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    if json.count != 0 {
                        let notice = NoticeInfo()
                        for (selection,item):(String,JSON) in json {
                            notice.selections.append(selection)
                            var nameList = [String]()
                            for (_,name):(String,JSON) in item{
                                nameList.append(name.stringValue)
                            }
                            notice.selectorList.append(nameList)
                            notice.selectedNum.append(nameList.count)
                        }
                        info.noticeList.append(notice)
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: SigninDetail
    func SigninDetailRequest(classID:String,signID:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"signID":signID]

        let url = "http://goback.jessieback.top/classes/\(classID)/getSignInDetail"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    print(json)
                    info.code = json["code"].intValue
                    if info.code == 200 {
                        for (_,name) in json["data"] {
                            info.notConfirmList.append(name.stringValue)
                        }
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: Export
    func ExportRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]

        let url = "http://goback.jessieback.top/classes/\(classID)/dumpStuPoints"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    info.code = json["code"].intValue
                    info.msg = json["msg"].stringValue
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: GetFile
    func GetFileRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]

        let url = "http://goback.jessieback.top/classes/\(classID)/files"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    if json.count != 0 {
                        for (_,item):(String,JSON) in json {
                            let file = FileInfo()
                            file.classID = item["classID"].stringValue
                            file.fid = item["fid"].intValue
                            file.name = item["name"].stringValue
                            file.path = item["path"].stringValue
                            file.fileHash = item["hash"].stringValue
                            file.type = item["type"].stringValue
                            file.uploadTime = item["uploadTime"].stringValue
                            file.username = item["username"].stringValue
                            info.fileList.append(file)
                        }
                    }
                    
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: Download
    func DownloadRequest(classID:String,fid:Int,fileName:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"fid":fid]

        let url = "http://goback.jessieback.top/classes/\(classID)/download"
        
//        let destination = Alamofire.DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        let destination: DownloadRequest.Destination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(url,parameters: parameters,headers: headers, to: destination)
        .downloadProgress { progress in
            print("当前进度: \(progress.fractionCompleted)")
        }
        .responseData { response in
//               print(response)
            switch response.result {
            case .success(_):
                    let info = RespondInfo()
                    info.msg = "success"
                    print("success")
                    completion(nil, info)
                case .failure(let error):
                    print("error")
                    completion(error, nil)
            }
        }
    }
    
//MARK: GetAFile
    func GetAFileRequest(classID:String,fid:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"fid":fid]

        let url = "http://goback.jessieback.top/classes/\(classID)/file"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    if json["name"] != "" {
                        let file = FileInfo()
                        file.classID = json["classID"].stringValue
                        file.fid = json["fid"].intValue
                        file.name = json["name"].stringValue
                        file.path = json["path"].stringValue
                        file.fileHash = json["hash"].stringValue
                        file.type = json["type"].stringValue
                        file.uploadTime = json["uploadTime"].stringValue
                        file.username = json["username"].stringValue
                        info.file = file
                    }
                    
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: GetUnconfirmed
    func GetUnconfirmedRequest(classID:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID]

        let url = "http://goback.jessieback.top/classes/\(classID)/unconfirmed"
        AF.request(url,method: .get,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                            
                    print(json)
                    info.code = json["code"].intValue
                    if info.code == 200 {
                        let data = json["data"]
                        for (_,item):(String,JSON) in data["vote"] {
                            info.unconfirmedVote.append(item.intValue)
                        }
                        for (_,item):(String,JSON) in data["signIn"] {
                            info.unconfirmedSignin.append(item.intValue)
                        }
                        for (_,item):(String,JSON) in data["notice"] {
                            info.unconfirmedAnnouncement.append(item.intValue)
                        }
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: SetAssistant
    func SetAssistantRequest(classID:String,assistants:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"assistants":assistants]

        let url = "http://goback.jessieback.top/classes/\(classID)/setAssistant"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                                
                    print(json)
                    info.code = json["code"].intValue
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
    //MARK: SetAssistant
        func CancelAssistantRequest(classID:String,assistants:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
            let token = UserDefaults.standard.string(forKey: "token")! as String
            let headers : HTTPHeaders = ["token":token]
            let parameters : [String:Any] = ["classID":classID,"assistants":assistants]

            let url = "http://goback.jessieback.top/classes/\(classID)/cancelAssistant"
            AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
                switch responds.result {
                    case .success(let value):
                        let json = JSON(value)
                        let info = RespondInfo()
                                    
                        print(json)
                        info.code = json["code"].intValue
                            
                        completion(nil, info)
                    case .failure(let error):
                        completion(error, nil)
                }
            }
        }
    
//MARK: RemoveStu
    func RemoveStuRequest(classID:String,username:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"username":username]

        let url = "http://goback.jessieback.top/classes/\(classID)/removeStu"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                                
                    print(json)
                    info.code = json["code"].intValue
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
//MARK: DeleteAnnouncement
    func DeleteAnnouncementRequest(classID:String,nid:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"nid":nid]

        let url = "http://goback.jessieback.top/classes/\(classID)/deleteNotice"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                                
                    print(json)
                    info.code = json["code"].intValue
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    //MARK: DeleteVote
        func DeleteVoteRequest(classID:String,vid:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
            let token = UserDefaults.standard.string(forKey: "token")! as String
            let headers : HTTPHeaders = ["token":token]
            let parameters : [String:Any] = ["classID":classID,"nid":vid]

            let url = "http://goback.jessieback.top/classes/\(classID)/deleteVote"
            AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
                switch responds.result {
                    case .success(let value):
                        let json = JSON(value)
                        let info = RespondInfo()
                                    
                        print(json)
                        info.code = json["code"].intValue
                            
                        completion(nil, info)
                    case .failure(let error):
                        completion(error, nil)
                }
            }
        }
    //MARK: DeleteSignin
        func DeleteSigninRequest(classID:String,signID:Int, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
            let token = UserDefaults.standard.string(forKey: "token")! as String
            let headers : HTTPHeaders = ["token":token]
            let parameters : [String:Any] = ["classID":classID,"nid":signID]

            let url = "http://goback.jessieback.top/classes/\(classID)/deleteSign"
            AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
                switch responds.result {
                    case .success(let value):
                        let json = JSON(value)
                        let info = RespondInfo()
                                    
                        print(json)
                        info.code = json["code"].intValue
                            
                        completion(nil, info)
                    case .failure(let error):
                        completion(error, nil)
                }
            }
        }
    //MARK: DeleteClass
        func DeleteClassRequest(classID:String,password:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
            let token = UserDefaults.standard.string(forKey: "token")! as String
            let headers : HTTPHeaders = ["token":token]
            let parameters : [String:Any] = ["classID":classID,"password":password]

            let url = "http://goback.jessieback.top/classes/\(classID)/deleteClass"
            AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
                switch responds.result {
                    case .success(let value):
                        let json = JSON(value)
                        let info = RespondInfo()
                                    
                        print(json)
                        info.code = json["code"].intValue
                            
                        completion(nil, info)
                    case .failure(let error):
                        completion(error, nil)
                }
            }
        }
//MARK: QuitClass
    func QuitClassRequest(classID:String,username:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"username":username]

        let url = "http://goback.jessieback.top/classes/\(classID)/quit"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                                
                    print(json)
                    info.code = json["code"].intValue
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: Absent
    func AbsentRequest(classID:String,students:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"students":students,"reason":"缺勤"]

        let url = "http://goback.jessieback.top/classes/\(classID)/absent"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                                
                    print(json)
                    info.code = json["code"].intValue
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: SupplySignin
    func SupplySigninRequest(classID:String,signID:Int,student:String, _ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["classID":classID,"student":student,"signID":signID]

        let url = "http://goback.jessieback.top/classes/\(classID)/supplySign"
        AF.request(url,method: .post,parameters: parameters,headers: headers).responseJSON { responds in
            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                                
                    print(json)
                    info.code = json["code"].intValue
                        
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
}
