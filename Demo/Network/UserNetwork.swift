//
//  LoginNetwork.swift
//  Demo
//
//  Created by HK on 2021/8/7.
//

import Alamofire
import SwiftyJSON

class UserNetwork {
    static let shared = UserNetwork()
//MARK: Login
    func LoginRequest(username:String, password:String,_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let parameters : [String:Any] = ["username":"\(username)","password":"\(password)"]
        let url = "http://goback.jessieback.top/user/login"
        AF.request(url,method: .post,parameters: parameters).responseJSON { responds in

                switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    print(json)
                    if let msg = json["msg"].string {
                        info.msg = msg
                    }
                    if let status = json["status"].bool {
                        info.status = status
                    }
                    if let code = json["code"].int {
                        info.code = code
//                        if let token = json["data"]["token"].dictionary {
//                            UserDefaults.standard.set(token, forKey: "token")
//                        }
                        
                        let token = json["data"]["jwtToken"].string
                        UserDefaults.standard.set(token, forKey: "token")
                        if let _ = json["data"]["user"].dictionary {
                            let user = json["data"]["user"]
                            info.user.realName = user["realName"].stringValue
                            info.user.uid = user["uid"].intValue
                            info.user.img_path = user["img_path"].stringValue
                            info.user.role = user["role"].stringValue
                            info.user.evalution = user["evaluation"].intValue
                            info.user.mailAddr = user["mailAddr"].stringValue
                            info.user.username = user["username"].stringValue
                            info.user.mobileNum = user["mobileNumber"].stringValue
                            info.user.status = user["status"].intValue
//                            UserDefaults.standard.set(info.user, forKey: "user")
                            let safedata = try? NSKeyedArchiver.archivedData(withRootObject: info.user, requiringSecureCoding: false)
                            UserDefaults.standard.set(safedata, forKey: "user")
                            UserDefaults.standard.synchronize()
                        }
                    }
                    
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: Register
    func RegisterRequest(username:String, password:String,realName:String,_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let parameters : [String:Any] = ["username":username,"password":password,"realName":realName,"role":"student"]
        let url = "http://goback.jessieback.top/user/register"
        AF.request(url,method: .post,parameters: parameters).responseJSON { responds in

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
//MARK: FinishRegister
    func FinishRegisterRequest(username:String, mailCode:String,_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let parameters : [String:Any] = ["username":username,"mailCode":mailCode]
        let url = "http://goback.jessieback.top/user/finishRegister"
        AF.request(url,method: .post,parameters: parameters).responseJSON { responds in

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
//MARK: SendMail
    func SendMailRequest(username:String ,_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let parameters : [String:Any] = ["username":"\(username)"]
        let url = "http://goback.jessieback.top/user/sendMail"
        AF.request(url,method: .post,parameters: parameters).responseJSON { responds in

                switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    let info = RespondInfo()
                    print(json)
                    if let msg = json["msg"].string {
                        info.msg = msg
                    }
                    completion(nil, info)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: CompareCode
    func CompareCodeRequest(username:String ,mailCode:String ,_ completion: @escaping (Error?, Bool?) -> ()) {
        let parameters : [String:Any] = ["username":"\(username)","mailCode":"\(mailCode)"]
        let url = "http://goback.jessieback.top/user/compareCode"
        AF.request(url,method: .post,parameters: parameters).responseJSON { responds in

                switch responds.result {
                case .success(let value):
                    let json = JSON(value).boolValue
                    print(json)
                    
                    completion(nil, json)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
//MARK: ResetByMail
    func ResetByMailRequest(username:String ,password:String ,mailCode:String ,_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let parameters : [String:Any] = ["username":"\(username)","newPassword":"\(password)","mailCode":"\(mailCode)"]
        let url = "http://goback.jessieback.top/user/ResetPwByMail"
        AF.request(url,method: .post,parameters: parameters).responseJSON { responds in

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
//MARK: ResetPassword
    func ResetPasswordRequest(oldPassword:String ,newPassword:String ,_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]
        let parameters : [String:Any] = ["oldPassword":"\(oldPassword)","newPassword":"\(newPassword)"]
        let url = "http://goback.jessieback.top/user/ResetPw"
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
    
//MARK: Logout
    func LogoutRequest(_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]

        let url = "http://goback.jessieback.top/user/logout"
        AF.request(url,method: .post,headers: headers).responseJSON { responds in
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
//MARK: isLogin
    func IsLoginRequest(_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        var token = ""
        if UserDefaults.standard.string(forKey: "token") != nil {
            token = UserDefaults.standard.string(forKey: "token")!
        } else {
            token = "nil"
        }

        let headers : HTTPHeaders = ["token":token]

        let url = "http://goback.jessieback.top/user/loginSuccess"
        AF.request(url,method: .get,headers: headers).responseJSON { responds in
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
//MARK: AllOperation
    func AllOperationRequest(_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]

        let url = "http://goback.jessieback.top/user/getAdminHistory"
        AF.request(url,method: .post,headers: headers).responseJSON { responds in
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
    
//MARK: WeChat
    func WeChatRequest(_ completion: @escaping (Error?, RespondInfo?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "token")! as String
        let headers : HTTPHeaders = ["token":token]

        let url = "http://goback.jessieback.top/wechat/bind"
        AF.request(url,method: .post,headers: headers).responseJSON { responds in
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
}
