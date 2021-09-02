//
//  CheckAskQuestionViewController.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit

class CheckAskQuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "课堂问答"
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        // Do any additional setup after loading the view.
        setUI()
    }
    var notice = NoticeInfo()
    var user = UserInfo()
    var titleLabel : UILabel!
    var nameLabel : UILabel!
    var startTime : UILabel!
    var numLabel : UILabel!
    var tableView : UITableView!
    var markImageView : UIImageView!
    var markLabel : UILabel!
    var lastMarkImageView : UIImageView!
    var lastMarkLabel : UILabel!
    var colorList = [UIColor.systemGreen,UIColor.systemOrange,UIColor.systemRed,UIColor.systemGray]
    var markList = ["优秀","良好","不合格","未评价"]
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "【课堂问答】"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(10)
        }
        
        startTime = UILabel.init()
//        startTime.text = "2021-12-12 16:30"
        startTime.text = notice.publishTime
        startTime.textColor = UIColor.gray
        startTime.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        nameLabel = UILabel.init()
//        nameLabel.text = "HK"
        nameLabel.text = notice.publisher
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.right.equalTo(startTime.snp.left).offset(-10)
            make.top.equalTo(startTime.snp.top)
        }
        
        for i in 0...3 {
            if i == 0 {
                markImageView = UIImageView.init(frame: CGRect(x: 15, y: 170 , width: 10, height: 10))
            } else if i == 3 {
                markImageView = UIImageView.init(frame: CGRect(x: 75*i+30, y: 170 , width: 10, height: 10))
            } else {
                markImageView = UIImageView.init(frame: CGRect(x: 75*i+15, y: 170 , width: 10, height: 10))
            }
            markImageView.backgroundColor = colorList[i]
            markImageView.layer.masksToBounds = true
            markImageView.layer.cornerRadius = markImageView.frame.size.width/2
            self.view.addSubview(markImageView)
            
            markLabel = UILabel.init()
            markLabel.text = markList[i]
            self.view.addSubview(markLabel)
            markLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(markImageView.snp.centerY)
                make.left.equalTo(markImageView.snp.right).offset(10)
            }
        }
        
        numLabel = UILabel.init()
        numLabel.text = "共\(notice.drawList.count)人"
        numLabel.textColor = UIColor.gray
        numLabel.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.equalTo(markImageView.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(15)
        }
        
        tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(InvolveCell.self, forCellReuseIdentifier: "InvolveCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(numLabel.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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

extension CheckAskQuestionViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notice.drawList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvolveCell", for: indexPath) as! InvolveCell
        cell.headImageView.image = UIImage(named: "test")
        let name = notice.drawList[indexPath.row].split(separator: ":").first
        cell.nameLabel.text = String(name!)
        let score = notice.scoreList[indexPath.row]
        if score == "2" {
            cell.markImageView.backgroundColor = UIColor.systemGreen
        } else if score == "1"  {
            cell.markImageView.backgroundColor = UIColor.systemOrange
        } else if score == "0"  {
            cell.markImageView.backgroundColor = UIColor.systemRed
        } else {
            cell.markImageView.backgroundColor = UIColor.systemGray
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if user.role == "student" {
//            return nil
//        }
//        let action = UIContextualAction(style: .destructive, title: "缺勤") { (action, view, finished) in
//
//
//            // 回调告知执行成功，否则不会删除此行！！！
//            finished(true)
//        }
//
//        let actions = UISwipeActionsConfiguration(actions: [action])
//        actions.performsFirstActionWithFullSwipe = false
////        return UISwipeActionsConfiguration(actions: [deleteAction, archiveAction])
//        return actions
//    }
}
