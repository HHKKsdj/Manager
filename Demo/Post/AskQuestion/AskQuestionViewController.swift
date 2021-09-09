//
//  AskQuestionViewController.swift
//  Demo
//
//  Created by HK on 2021/7/26.
//

import UIKit

class AskQuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "课堂回答"
        // Do any additional setup after loading the view.
        setUI()
    }
    var classList = [ClassInfo]()
    var classTag = [Int]()
    
    var targetView : UIView!
    var titleLabel : UILabel!
    var targetLabel : UILabel!
    var targetButton : UIButton!
    var name : UILabel!
    var startButton : UIButton!
    var goodButton : UIButton!
    var sosoButton : UIButton!
    var badButton : UIButton!
    var absentButton : UIButton!
    
    var target = [String]()
    var userName = ""
    
    func setUI() {
        targetView = UIView.init()
        targetView.backgroundColor = UIColor.white
        
        targetView.layer.masksToBounds = true
//        targetView.layer.cornerRadius = 12.0
        targetView.layer.borderWidth = 0.35
        targetView.layer.borderColor = UIColor.gray.cgColor
        
        targetView.isUserInteractionEnabled = true
        let target = UITapGestureRecognizer(target: self, action: #selector(targetList))
        targetView.addGestureRecognizer(target)
        
        self.view.addSubview(targetView)
        targetView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(90)
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        titleLabel = UILabel.init()
        titleLabel.text = "发送给"
        targetView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        targetButton = UIButton.init()
        targetButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        targetButton.addTarget(self, action: #selector(targetList(sender:)), for: .touchUpInside)
        targetView.addSubview(targetButton)
        targetButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        targetLabel = UILabel.init()
        targetLabel.text = "请选择发送对象"
        targetLabel.textColor = UIColor.gray
        targetView.addSubview(targetLabel)
        targetLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(targetButton.snp.left).offset(-10)
        }
        
        name = UILabel.init()
//        name.text = "123456789"
        name.font = UIFont.systemFont(ofSize: 25)
        self.view.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(targetView.snp.bottom).offset(30)
        }
        
        startButton = UIButton.init(frame: CGRect(x: self.view.frame.width/4, y: self.view.frame.height/4 + 20, width: 200, height: 200))
        startButton.setTitle("开始", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        startButton.backgroundColor = UIColor.systemTeal
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = startButton.frame.size.width/2
        startButton.addTarget(self, action: #selector(start(sender:)), for: .touchUpInside)
        self.view.addSubview(startButton)

        goodButton = UIButton.init()
        goodButton.setTitle("优秀", for: .normal)
        goodButton.backgroundColor = UIColor.systemGreen
        goodButton.layer.masksToBounds = true
        goodButton.layer.cornerRadius = 12.0
        goodButton.addTarget(self, action: #selector(good(sender:)), for: .touchUpInside)
        self.view.addSubview(goodButton)
        goodButton.snp.makeConstraints { (make) in
            make.top.equalTo(startButton.snp.bottom).offset(55)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
        
        sosoButton = UIButton.init()
        sosoButton.setTitle("良好", for: .normal)
        sosoButton.backgroundColor = UIColor.systemOrange
        sosoButton.layer.masksToBounds = true
        sosoButton.layer.cornerRadius = 12.0
        sosoButton.addTarget(self, action: #selector(soso(sender:)), for: .touchUpInside)
        self.view.addSubview(sosoButton)
        sosoButton.snp.makeConstraints { (make) in
            make.top.equalTo(goodButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
        
        badButton = UIButton.init()
        badButton.setTitle("不合格", for: .normal)
        badButton.backgroundColor = UIColor.systemRed
        badButton.layer.masksToBounds = true
        badButton.layer.cornerRadius = 12.0
        badButton.addTarget(self, action: #selector(bad(sender:)), for: .touchUpInside)
        self.view.addSubview(badButton)
        badButton.snp.makeConstraints { (make) in
            make.top.equalTo(sosoButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
        
        absentButton = UIButton.init()
        absentButton.setTitle("缺勤", for: .normal)
        absentButton.backgroundColor = UIColor.systemGray
        absentButton.layer.masksToBounds = true
        absentButton.layer.cornerRadius = 12.0
        absentButton.addTarget(self, action: #selector(absent(sender:)), for: .touchUpInside)
        self.view.addSubview(absentButton)
        absentButton.snp.makeConstraints { (make) in
            make.top.equalTo(badButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
    }
    
    @objc func targetList () {
        let classListVC = ClassListViewController()
        classListVC.delegate = self
        classListVC.onlyOne = true
        self.navigationController?.pushViewController(classListVC, animated: true)
    }
    
    @objc func start (sender:UIButton) {
        target.removeAll()
        for i in 0..<classTag.count {
            if classTag[i] == 1 {
                target.append(classList[i].classId)
            }
        }
        publish()
    }
    @objc func good (sender: UIButton) {
        addPoint(point: 2)
    }
    @objc func soso (sender: UIButton) {
        addPoint(point: 1)
    }
    @objc func bad (sender: UIButton) {
        addPoint(point: 0)
    }
    @objc func absent (sender: UIButton) {
        absent()
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

extension AskQuestionViewController : selectDelegate {
    func select(classList: [ClassInfo], classTag: [Int], nameList: [[String]], nameTag: [[Int]]) {
        self.classList = classList
        self.classTag = classTag
        for i in 0..<classTag.count {
            if classTag[i] == 1 {
                targetLabel.text = classList[i].name
                break
            }
        }
    }
}

extension AskQuestionViewController {
    func publish() {
        if target.count == 1 {
            ClassNetwork.shared.PublishQuestionRequest(classID: target[0]){ (error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    let data = content.data.split(separator: ":").first
                    self.userName = String(data!)
                    self.name.text = self.userName
                } else {
                    let alter = UIAlertController(title: "发送失败", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alter.addAction(action)
                    self.present(alter, animated: true, completion: nil)
                }
            }
        } else if target.count > 1 {
            let alter = UIAlertController(title: "只能选择一个班级", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alter.addAction(action)
            self.present(alter, animated: true, completion: nil)
        } else if target.count == 0 {
            let alter = UIAlertController(title: "请选择一个班级", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alter.addAction(action)
            self.present(alter, animated: true, completion: nil)
        }
    }
    
    func addPoint(point:Int) {
        if name.text != nil {
            ClassNetwork.shared.AddQuestionPointRequest(classID: target[0], student: userName, points: point){ (error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    let alter = UIAlertController(title: "评价成功", message: "", preferredStyle: .alert)
                    self.present(alter, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        alter.dismiss(animated: true, completion: nil)
                    }
//                    self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
                } else {
                    let alter = UIAlertController(title: "评价失败", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alter.addAction(action)
                    self.present(alter, animated: true, completion: nil)
                }                
            }
        }
    }
    
    func absent() {
        if name.text != nil {
            ClassNetwork.shared.AbsentRequest(classID: target[0], students: userName){ (error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    let alter = UIAlertController(title: "评价成功", message: "", preferredStyle: .alert)
                    self.present(alter, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        alter.dismiss(animated: true, completion: nil)
                    }
//                    self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
                } else {
                    let alter = UIAlertController(title: "评价失败", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alter.addAction(action)
                    self.present(alter, animated: true, completion: nil)
                }
            }
        }
    }
}
