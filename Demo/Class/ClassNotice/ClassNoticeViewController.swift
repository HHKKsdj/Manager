//
//  ClassNoticeViewController.swift
//  Demo
//
//  Created by HK on 2021/8/3.
//

import UIKit

class ClassNoticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: UIBarButtonItem.Style.done, target: self, action: #selector(management(sender:)))
        self.navigationItem.title = className
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        
        noticeList.removeAll()
        GetUnconfirmed()
        getAnnouncement()
        getAnnouncement2()
        getVote()
        getSignin()
        getDraw()
        getQuestion()
        setUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        noticeList.removeAll()
//        getAnnouncement()
//        getAnnouncement2()
//        getVote()
//        getSignin()
//        getDraw()
//        getQuestion()
//    }
    var user = UserInfo()
    var classID = ""
    var className = ""
    var tableView : UITableView!
//    var noticeList = ["公告","投票","课堂问答","活动抽签","定时签到","手势签到"]
    var noticeList = [NoticeInfo]()

    var unconfirmedVote = [Int]()
    var unconfirmedSignin = [Int]()
    var unconfirmedAnnouncement = [Int]()
    var confirmedList = [NoticeInfo]()
    var unconfirmedList = [NoticeInfo]()
    
    func setUI() {
        tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.systemGray6
        tableView.tableFooterView = footerView
        
        tableView.register(NoticeCell.self, forCellReuseIdentifier: "NoticeCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(90)
            make.bottom.equalToSuperview()
        }
        
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            noticeList.removeAll()
            unconfirmedSignin.removeAll()
            unconfirmedAnnouncement.removeAll()
            unconfirmedVote.removeAll()
            GetUnconfirmed()
            getAnnouncement()
            getAnnouncement2()
            getVote()
            getSignin()
            getDraw()
            getQuestion()
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    func sort() {
        var list1 = [NoticeInfo]()
        var list2 = [NoticeInfo]()
        for notice in noticeList {
            if unconfirmedSignin.contains(notice.signID) || unconfirmedVote.contains(notice.vid) || unconfirmedAnnouncement.contains(notice.nid) {
                list1.append(notice)
            } else {
                list2.append(notice)
            }
        }
        unconfirmedList = list1.sorted { (s1, s2) -> Bool in
            return s1.deadline < s2.deadline
        }
        confirmedList = list2.sorted { (s1, s2) -> Bool in
            return s1.publishTime > s2.publishTime
        }
        noticeList = unconfirmedList + confirmedList
        tableView.reloadData()
    }
    
    @objc func management (sender:UIBarButtonItem) {
        let managementVC = ManagementViewController()
        managementVC.classID = classID
        self.navigationController?.pushViewController(managementVC, animated: true)
    }
    @objc func back (sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClassNoticeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell
        if noticeList.count != 0 {
            let notice = noticeList[indexPath.row]
            cell.titleLabel.text = "【\(notice.type)】" + notice.title
            cell.nameLabel.text = notice.publisher
            if notice.type == "课堂问答" || notice.type == "活动抽签" {
                cell.endTime.text = notice.publishTime
            } else {
                cell.endTime.text = "截止时间:" + notice.deadline
            }
            if user.role == "teacher" && noticeList[indexPath.row].publisher == user.username {
                cell.markImageView.isHidden = true
            } else if unconfirmedSignin.contains(notice.signID) || unconfirmedVote.contains(notice.vid) || unconfirmedAnnouncement.contains(notice.nid) {
                cell.markImageView.isHidden = false
            } else {
                cell.markImageView.isHidden = true
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = noticeList[indexPath.row].type
        switch type {
        case "公告":
            let VC = CheckAnnouncementViewController()
            VC.notice = noticeList[indexPath.row]
            if !unconfirmedAnnouncement.contains(noticeList[indexPath.row].nid) {
                VC.confirmed = true
            }
            presentVC(VC: VC)
        case "投票":
            let VC = CheckVoteViewController()
            VC.notice = noticeList[indexPath.row]
            if !unconfirmedVote.contains(noticeList[indexPath.row].vid) {
                VC.confirmed = true
            }
            presentVC(VC: VC)
        case "课堂问答":
            let VC = CheckAskQuestionViewController()
            VC.notice = noticeList[indexPath.row]
            presentVC(VC: VC)
        case "活动抽签":
            let VC = CheckDrawViewController()
            VC.notice = noticeList[indexPath.row]
            presentVC(VC: VC)
        case "定时签到":
            if noticeList[indexPath.row].publisher == user.username {
                getName(notice: noticeList[indexPath.row])
            } else {
                let VC = CheckByTimeViewController()
                VC.notice = noticeList[indexPath.row]
                if !unconfirmedSignin.contains(noticeList[indexPath.row].signID) {
                    VC.confirmed = true
                }
                presentVC(VC: VC)
            }
            
        case "手势签到":
            if noticeList[indexPath.row].publisher == user.username {
                getName(notice: noticeList[indexPath.row])
            } else {
                let VC = CheckByGestureViewController()
                VC.notice = noticeList[indexPath.row]
                if !unconfirmedSignin.contains(noticeList[indexPath.row].signID) {
                    VC.confirmed = true
                }
                presentVC(VC: VC)
            }
        default:
            print("error")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func presentVC(VC:UIViewController) {
        let naviVC = UINavigationController(rootViewController: VC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let notice = noticeList[indexPath.row]
        if user.role != "student" && notice.type != "活动抽签" && notice.type != "课堂问答" {
            let deleteAction = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in
                if notice.type == "公告" {
                    self.deleteAnnouncement(id: notice.nid, indexPath: indexPath)
                } else if notice.type == "投票" {
                    self.deleteVote(id: notice.vid, indexPath: indexPath)
                } else if notice.type == "定时签到" || notice.type == "手势签到" {
                    self.deleteSignin(id: notice.signID, indexPath: indexPath)
                }
                finished(true)
            }

            let actions = UISwipeActionsConfiguration(actions: [deleteAction])
            actions.performsFirstActionWithFullSwipe = false
            return actions
        } else {
            return nil
        }
    }
}
//MARK: Network
extension ClassNoticeViewController {
    func getAnnouncement() {
        ClassNetwork.shared.GetAnnouncementRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.noticeList += content.noticeList
                self.sort()
            }
        }
    }
    func getAnnouncement2() {
        ClassNetwork.shared.GetAnnouncement2Request(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.noticeList += content.noticeList
                self.sort()
            }
        }
    }
    func getVote() {
        ClassNetwork.shared.GetVoteRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
//            if content.code == 200 {
            if content.noticeList.count != 0 {
                self.noticeList += content.noticeList
                self.sort()
            }
        }
    }
    func getSignin() {
        ClassNetwork.shared.GetSigninRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.noticeList.count != 0 {
                self.noticeList += content.noticeList
                self.sort()
            }
        }
    }
    func getDraw() {
        ClassNetwork.shared.GetDrawRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.noticeList += content.noticeList
                self.sort()
            }
        }
    }
    func getQuestion() {
        ClassNetwork.shared.GetQuestionRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.noticeList += content.noticeList
                self.sort()
            }
        }
    }
    func GetUnconfirmed() {
        ClassNetwork.shared.GetUnconfirmedRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.unconfirmedSignin = content.unconfirmedSignin
                self.unconfirmedVote = content.unconfirmedVote
                self.unconfirmedAnnouncement = content.unconfirmedAnnouncement
//                self.sort()
            }
        }
    }
    
    func deleteAnnouncement(id:Int,indexPath:IndexPath) {
        ClassNetwork.shared.DeleteAnnouncementRequest(classID: classID, nid: id) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.noticeList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
    func deleteVote(id:Int,indexPath:IndexPath) {
        ClassNetwork.shared.DeleteVoteRequest(classID: classID, vid: id) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.noticeList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
    func deleteSignin(id:Int,indexPath:IndexPath) {
        ClassNetwork.shared.DeleteSigninRequest(classID: classID, signID: id) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.noticeList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
}




extension ClassNoticeViewController {
    func signinDetail(notice:NoticeInfo,nameList:[UserInfo]) {
        ClassNetwork.shared.SigninDetailRequest(classID: notice.classID, signID: notice.signID){(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            let notSigninList = content.notConfirmList
            if content.notConfirmList.count != 0 {
                var okList = [String]()
                for name in nameList {
                    if !notSigninList.contains(name.username) {
                        okList.append(name.username)
                    }
                }
            }
            var confirmList = [String]()
            for name in nameList {
                if !notSigninList.contains(name.username) {
                    confirmList.append(name.username)
                }
            }
            let involveVC = InvolveViewController()
            involveVC.nameList = nameList
            involveVC.okList = confirmList
            self.navigationController?.pushViewController(involveVC, animated: true)
        }
    }
    func getName(notice:NoticeInfo) {
        ClassNetwork.shared.GetStudentRequest(classID: notice.classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.nameList.count != 0 {
                let nameList = content.nameList
                self.signinDetail(notice: notice, nameList: nameList)
//                self.tableView.reloadData()
            }
        }
    }
}
