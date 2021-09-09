//
//  NoticeViewController.swift
//  Demo
//
//  Created by HK on 2021/7/22.
//

import UIKit
import BTNavigationDropdownMenu
import ESPullToRefresh

class NoticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "全部通知"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        classList.removeAll()
        noticeList.removeAll()
//        let list = ["公告","投票","课堂问答","活动抽签","定时签到","手势签到"]
//        for i in 0..<6 {
//            let notice = NoticeInfo()
//            notice.type = list[i]
//            notice.title = "testtesttesttest"
//            notice.publisher = "张三"
//            notice.deadline = "2021-12-13 19:00"
//            sentList.append(notice)
//        }
        getClassList()
        setUI()

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        receivedList.removeAll()
//        getClassList()
//        getSentList()
//    }
    
    var user = UserInfo()
    
    var menuView : BTNavigationDropdownMenu!
    var menuList = ["全部通知","公告","投票","课堂问答","活动抽签","定时签到","手势签到","未处理"]
    
    var receivedList = [NoticeInfo]()
    var sentList = [NoticeInfo]()
    var noticeList = [NoticeInfo]()
    var classList = [ClassInfo]()
    
    var announcementList1 = [NoticeInfo]()
    var announcementList2 = [NoticeInfo]()
    var voteList = [NoticeInfo]()
    var questionList = [NoticeInfo]()
    var drawList = [NoticeInfo]()
    var byTimeList = [NoticeInfo]()
    var byGestureList = [NoticeInfo]()
    
    var unconfirmedVote = [Int]()
    var unconfirmedSignin = [Int]()
    var unconfirmedAnnouncement = [Int]()
    var confirmedList = [NoticeInfo]()
    var unconfirmedList = [NoticeInfo]()
    
    var tag = 0
    var segment : UISegmentedControl!
    var receivedView : UIView!
    var sentView : UIView!
    var tableView : UITableView!
    
    func setUI() {
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "全部通知", items: menuList)
        menuView.arrowImage = UIImage(systemName: "arrowtriangle.down")
        menuView.arrowTintColor = UIColor.black
        menuView.cellBackgroundColor = UIColor.white
        menuView.cellSelectionColor = UIColor.systemTeal
        menuView.shouldKeepSelectedCellColor = true
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
//            print("当前点击项的索引: \(indexPath)")
            switch indexPath {
            case 0:
                self.noticeList = self.receivedList
            case 1:
                self.noticeList = self.announcementList1 + self.announcementList2
            case 2:
                self.noticeList = self.voteList
            case 3:
                self.noticeList = self.questionList
            case 4:
                self.noticeList = self.drawList
            case 5:
                self.noticeList = self.byTimeList
            case 6:
                self.noticeList = self.byGestureList
            case 7:
                var list = [NoticeInfo]()
                for notice in self.receivedList {
                    if self.unconfirmedVote.contains(notice.vid) || self.unconfirmedAnnouncement.contains(notice.nid) || self.unconfirmedSignin.contains(notice.signID) {
                        list.append(notice)
                    }
                }
                self.noticeList = list
            default:
//                print("error")
                self.noticeList = self.receivedList
            }
            self.tableView.reloadData()
        }
        self.navigationItem.titleView = menuView
        
        if user.role == "student" {
            segment = UISegmentedControl.init(items: ["我收到的"])
        } else {
            segment = UISegmentedControl.init(items: ["我收到的","我发起的"])
        }
        
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentDidChange(sender:)), for: UIControl.Event.valueChanged)
        self.view.addSubview(segment)
        segment.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(95)
        }
        
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
            make.top.equalTo(segment.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
//        receivedView = ReceivedView()
//        receivedView.isHidden = false
//        self.view.addSubview(receivedView)
//        receivedView.snp.makeConstraints { (make) in
//            make.width.equalToSuperview()
//            make.top.equalTo(segment.snp.bottom).offset(5)
//            make.bottom.equalToSuperview()
//        }
//
//        sentView = SentView()
//        sentView.isHidden = true
//        self.view.addSubview(sentView)
//        sentView.snp.makeConstraints { (make) in
//            make.width.equalToSuperview()
//            make.top.equalTo(segment.snp.bottom).offset(5)
//            make.bottom.equalToSuperview()
//        }
        self.tableView.es.addPullToRefresh {
            [unowned self] in
//            if segment.selectedSegmentIndex == 0 {
                receivedList.removeAll()
            unconfirmedSignin.removeAll()
            unconfirmedAnnouncement.removeAll()
            unconfirmedVote.removeAll()
                getClassList()
//                noticeList = receivedList
//            }
            menuView.setSelected(index: 0)
            self.tableView.es.stopPullToRefresh()
        }

    }

    func sortAll() {
        var list1 = [NoticeInfo]()
        var list2 = [NoticeInfo]()
        for notice in receivedList {
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
        receivedList = unconfirmedList + confirmedList
        sentList = sentList.sorted { (s1, s2) -> Bool in
            return s1.publishTime > s2.publishTime
        }
        tableView.reloadData()
    }
    
    func sort(list:[NoticeInfo]) -> [NoticeInfo] {
        var list1 = [NoticeInfo]()
        var list2 = [NoticeInfo]()
        for notice in list {
            if unconfirmedSignin.contains(notice.signID) || unconfirmedVote.contains(notice.vid) || unconfirmedAnnouncement.contains(notice.nid) {
                list1.append(notice)
            } else {
                list2.append(notice)
            }
        }
        list1 = list1.sorted { (s1, s2) -> Bool in
            return s1.deadline < s2.deadline
        }
        list2 = list2.sorted { (s1, s2) -> Bool in
            return s1.publishTime > s2.publishTime
        }
        return list1 + list2
    }
    
    @objc func segmentDidChange(sender:UISegmentedControl) {
//        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            noticeList = receivedList
            tag = 0
//            receivedView.isHidden = false
//            sentView.isHidden = true
        } else {
            noticeList = sentList
            tag = 1
//            receivedView.isHidden = true
//            sentView.isHidden = false
        }
        tableView.reloadData()
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
//MARK: TableViewdelegate
extension NoticeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell
        let notice = noticeList[indexPath.row]
        cell.titleLabel.text = "【\(notice.type)】" + notice.title
        cell.nameLabel.text = notice.publisher
        if notice.type == "课堂问答" || notice.type == "活动抽签" {
            cell.endTime.text = notice.publishTime
        } else {
            cell.endTime.text = "截止时间:" + notice.deadline
        }
        cell.tag = tag
//        if user.role != "student" {
//            cell.markImageView.isHidden = true
//        }
        if unconfirmedSignin.contains(notice.signID) || unconfirmedVote.contains(notice.vid) || unconfirmedAnnouncement.contains(notice.nid) {
            cell.markImageView.isHidden = false
        } else {
            cell.markImageView.isHidden = true
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
                    self.deleteAnnouncement(classID: notice.classID, id: notice.nid, indexPath: indexPath)
                } else if notice.type == "投票" {
                    self.deleteVote(classID: notice.classID, id: notice.vid, indexPath: indexPath)
                } else if notice.type == "定时签到" || notice.type == "手势签到" {
                    self.deleteSignin(classID: notice.classID, id: notice.signID, indexPath: indexPath)
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

extension NoticeViewController {
    func getClassList() {
        if self.user.role == "student" {
            ClassNetwork.shared.MyClassRequest {(error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    self.classList = content.classList
                    for id in self.classList {
                        self.GetUnconfirmed(classID: id.classId)
                        self.getAnnouncement(classID: id.classId)
                        self.getAnnouncement2(classID: id.classId)
                        self.getVote(classID: id.classId)
                        self.getSignin(classID: id.classId)
                        self.getDraw(classID: id.classId)
                        self.getQuestion(classID: id.classId)
                    }
                    self.tableView.reloadData()
                }
            }
        } else if self.user.role == "teacher" {
            ClassNetwork.shared.MyCreatedClassRequest{(error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    self.classList = content.classList
                    for id in self.classList {
                        self.GetUnconfirmed(classID: id.classId)
                        self.getAnnouncement(classID: id.classId)
                        self.getAnnouncement2(classID: id.classId)
                        self.getVote(classID: id.classId)
                        self.getSignin(classID: id.classId)
                        self.getDraw(classID: id.classId)
                        self.getQuestion(classID: id.classId)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func getAnnouncement(classID:String) {
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
                if self.user.role != "student" {
                    for notice in content.noticeList {
                        if notice.publisher == self.user.username {
                            self.sentList.append(notice)
                        } else {
                            self.receivedList.append(notice)
                        }
                    }
                } else {
                    self.receivedList += content.noticeList
                }
                
                self.announcementList1 = self.sort(list: content.noticeList)
                self.sortAll()
                self.tableView.reloadData()
            }
        }
    }
    func getAnnouncement2(classID:String) {
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
                if self.user.role != "student" {
                    for notice in content.noticeList {
                        if notice.publisher == self.user.username {
                            self.sentList.append(notice)
                        } else {
                            self.receivedList.append(notice)
                        }
                    }
                } else {
                    self.receivedList += content.noticeList
                }
                self.announcementList2 = self.sort(list: content.noticeList)
                self.sortAll()
                self.tableView.reloadData()
            }
        }
    }
    func getVote(classID:String) {
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
                if self.user.role != "student" {
                    for notice in content.noticeList {
                        if notice.publisher == self.user.username {
                            self.sentList.append(notice)
                        } else {
                            self.receivedList.append(notice)
                        }
                    }
                } else {
                    self.receivedList += content.noticeList
                }
                self.voteList = self.sort(list: content.noticeList)
                self.sortAll()
                self.tableView.reloadData()
            }
        }
    }
    func getSignin(classID:String) {
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
                if self.user.role != "student" {
                    for notice in content.noticeList {
                        if notice.publisher == self.user.username {
                            self.sentList.append(notice)
                        } else {
                            self.receivedList.append(notice)
                        }
                    }
                } else {
                    self.receivedList += content.noticeList
                }
                var byTime = [NoticeInfo]()
                var byGesture = [NoticeInfo]()
                for notice in content.noticeList {
                    if notice.type == "手势签到" {
                        byGesture.append(notice)
                    } else {
                        byTime.append(notice)
                    }
                }
                self.byTimeList = self.sort(list: byTime)
                self.byGestureList = self.sort(list: byGesture)
                self.sortAll()
                self.tableView.reloadData()
            }
        }
    }
    func getDraw(classID:String) {
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
                if self.user.role != "student" {
                    for notice in content.noticeList {
                        if notice.publisher == self.user.username {
                            self.sentList.append(notice)
                        } else {
                            self.receivedList.append(notice)
                        }
                    }
                } else {
                    self.receivedList += content.noticeList
                }
                self.drawList = self.sort(list: content.noticeList)
                self.sortAll()
                self.tableView.reloadData()
            }
        }
    }
    func getQuestion(classID:String) {
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
                if self.user.role != "student" {
                    for notice in content.noticeList {
                        if notice.publisher == self.user.username {
                            self.sentList.append(notice)
                        } else {
                            self.receivedList.append(notice)
                        }
                    }
                } else {
                    self.receivedList += content.noticeList
                }
                self.questionList = self.sort(list: content.noticeList)
                self.sortAll()
                self.tableView.reloadData()
            }
        }
    }

    func GetUnconfirmed(classID:String) {
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
                self.unconfirmedSignin += content.unconfirmedSignin
                self.unconfirmedVote += content.unconfirmedVote
                self.unconfirmedAnnouncement += content.unconfirmedAnnouncement
//                self.sort()
                self.tableView.reloadData()
            }
        }
    }
    
    func deleteAnnouncement(classID:String,id:Int,indexPath:IndexPath) {
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
                for i in 0..<self.announcementList1.count {
                    if self.announcementList1[i] == self.noticeList[indexPath.row] {
                        self.announcementList1.remove(at: i)
                        break
                    }
                }
                for i in 0..<self.announcementList2.count {
                    if self.announcementList2[i] == self.noticeList[indexPath.row] {
                        self.announcementList2.remove(at: i)
                        break
                    }
                }
                self.noticeList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
    func deleteVote(classID:String,id:Int,indexPath:IndexPath) {
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
                for i in 0..<self.voteList.count {
                    if self.voteList[i] == self.noticeList[indexPath.row] {
                        self.voteList.remove(at: i)
                        break
                    }
                }
                self.noticeList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
    func deleteSignin(classID:String,id:Int,indexPath:IndexPath) {
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
                for i in 0..<self.byTimeList.count {
                    if self.byTimeList[i] == self.noticeList[indexPath.row] {
                        self.byTimeList.remove(at: i)
                        break
                    }
                }
                for i in 0..<self.byGestureList.count {
                    if self.byGestureList[i] == self.noticeList[indexPath.row] {
                        self.byGestureList.remove(at: i)
                        break
                    }
                }
                self.noticeList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
//    func getSentList() {
//        UserNetwork.shared.AllOperationRequest{(error,info) in
//            if let error = error {
//                print(error)
//                return
//            }
//            guard let content = info else {
//                print("nil")
//                return
//            }
//
//        }
//    }
    
}



extension NoticeViewController {
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
            involveVC.classID = notice.classID
            involveVC.signID = notice.signID
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
