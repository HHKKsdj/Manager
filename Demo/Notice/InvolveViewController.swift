//
//  InvolveViewController.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit
import Charts

class InvolveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "参与情况"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        if user.username == notice.publisher {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        }
        list = okList
        for name in nameList {
            if !okList.contains(name.username) {
                list.append(name.username)
            }
        }
        
        setUI()
    }
    var user = UserInfo()
    var chartView : PieChartView!
    var markImageView : UIImageView!
    var markLabel : UILabel!
    var numLabel : UILabel!
    var tableView : UITableView!
    
    var nameList = [UserInfo]()
    var okList = [String]()
    var list = [String]()
    var notice = NoticeInfo()
    var classID = ""
    var signID = 0
    
    func setUI() {
        chartView = PieChartView()
        chartView.drawHoleEnabled = true
        chartView.holeColor = UIColor.white
        chartView.holeRadiusPercent = 0.65
        chartView.usePercentValuesEnabled = true
        chartView.drawCenterTextEnabled = true
//        chartView.centerText = "81%\n已参与"
        var percent : Float = 0
        if nameList.count != 0 && okList.count != 0 {
            percent = Float(okList.count)/Float(nameList.count)
        }
        chartView.centerText = "\(100*percent)%\n已参与"
        chartView.legend.enabled = false
        chartView.rotationEnabled = false
        
        self.view.addSubview(chartView)
        chartView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        setData()
        
        for i in 0...1 {
            markLabel = UILabel.init()
            if i == 0 {
                markImageView = UIImageView.init(frame: CGRect(x: 200, y: 135 , width: 10, height: 10))
                markImageView.backgroundColor = UIColor.systemBlue
//                markLabel.text = "已参与  " + "124人"
                markLabel.text = "已参与  " + "\(okList.count)人"
            } else {
                markImageView = UIImageView.init(frame: CGRect(x: 200, y: 165 , width: 10, height: 10))
                markImageView.backgroundColor = UIColor.systemGreen
//                markLabel.text = "未参与  " + "29人"
                markLabel.text = "未参与  " + "\(nameList.count - okList.count)人"
            }
            markImageView.layer.masksToBounds = true
            markImageView.layer.cornerRadius = markImageView.frame.size.width/2
            self.view.addSubview(markImageView)
            
            self.view.addSubview(markLabel)
            markLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(markImageView)
                make.left.equalTo(markImageView.snp.right).offset(15)
            }
        }
        
        numLabel = UILabel.init()
//        numLabel.text = "共250人"
        numLabel.text = "共\(nameList.count)人"
        numLabel.textColor = UIColor.gray
        self.view.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.equalTo(chartView.snp.bottom).offset(35)
            make.left.equalToSuperview().offset(15)
        }
        
        tableView = UITableView.init()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(InvolveCell.self, forCellReuseIdentifier: "InvolveCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(numLabel.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setData() {
//        let datas = [124,29]
        let datas = [okList.count,nameList.count-okList.count]
        var values = [PieChartDataEntry]()
            
        for data in datas {
            let entry = PieChartDataEntry.init(value: Double(data))
            values.append(entry)
        }
            
        let dataSet = PieChartDataSet(entries: values)
        dataSet.colors = [UIColor.systemBlue,UIColor.systemGreen]
        dataSet.sliceSpace = 1
        dataSet.selectionShift = 0
        dataSet.drawValuesEnabled = false
        let data = PieChartData(dataSets: [dataSet])
        chartView.data = data
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

extension InvolveViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvolveCell", for: indexPath) as! InvolveCell
        cell.headImageView.image = UIImage(named: "test")
        for name in nameList {
            if name.username == list[indexPath.row] {
                cell.nameLabel.text = name.username + name.realName
                break
            }
        }
        if indexPath.row < okList.count {
            cell.markImageView.backgroundColor = UIColor.systemBlue
        } else {
            cell.markImageView.backgroundColor = UIColor.systemGreen
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if user.role == "student" || !notice.type.contains("签到") {
            return nil
        }
        
        let action1 = UIContextualAction(style: .destructive, title: "缺勤") { (action, view, finished) in
            self.absent(userName: self.list[indexPath.row])
            for i in 0..<self.okList.count {
                if self.okList[i] == self.list[indexPath.row] {
                    self.okList.remove(at: i)
                    break
                }
            }
            var percent : Float = 0
            if self.nameList.count != 0 && self.okList.count != 0 {
                percent = Float(self.okList.count)/Float(self.nameList.count)
            }
            self.chartView.centerText = "\(100*percent)%\n已参与"
            self.setData()
            self.tableView.reloadData()
            finished(true)
        }

        let action2 = UIContextualAction(style: .normal, title: "请假") { (action, view, finished) in
            self.supplySignin(userName: self.list[indexPath.row])
            self.okList.append(self.list[indexPath.row])
            var percent : Float = 0
            if self.nameList.count != 0 && self.okList.count != 0 {
                percent = Float(self.okList.count)/Float(self.nameList.count)
            }
            self.chartView.centerText = "\(100*percent)%\n已参与"
            self.setData()
            self.tableView.reloadData()
            finished(true)
        }
        action2.backgroundColor = UIColor.systemGreen
        
        let action3 = UIContextualAction(style: .normal, title: "签到") { (action, view, finished) in
            self.supplySignin(userName: self.list[indexPath.row])
            self.okList.append(self.list[indexPath.row])
            var percent : Float = 0
            if self.nameList.count != 0 && self.okList.count != 0 {
                percent = Float(self.okList.count)/Float(self.nameList.count)
            }
            self.chartView.centerText = "\(100*percent)%\n已参与"
            self.setData()
            self.tableView.reloadData()
            finished(true)
        }
        action3.backgroundColor = UIColor.systemTeal
        
        let actions = UISwipeActionsConfiguration(actions: [action1, action2, action3])
        actions.performsFirstActionWithFullSwipe = false
//        return UISwipeActionsConfiguration(actions: [deleteAction, archiveAction])
        return actions
    }

}

//MARK: Network

extension InvolveViewController {
    func absent(userName:String) {
        ClassNetwork.shared.AbsentRequest(classID: classID, students: userName){ (error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                let alter = UIAlertController(title: "操作成功", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
        }
    }
    func supplySignin(userName:String) {
        ClassNetwork.shared.SupplySigninRequest(classID: classID, signID:signID, student: userName){ (error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                let alter = UIAlertController(title: "操作成功", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
        }
    }
}
