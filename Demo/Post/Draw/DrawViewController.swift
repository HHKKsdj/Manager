//
//  DrawViewController.swift
//  Demo
//
//  Created by HK on 2021/7/22.
//

import UIKit

class DrawViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "活动抽签"
        // Do any additional setup after loading the view.
        setUI()
    }
    var classList = [ClassInfo]()
    var classTag = [Int]()
    var count = 0
    
    var nameList = [String]()
    var target = [String]()
    var scrollView : UIScrollView!
    var contentView : UIView!
    var targetView : UIView!
    var titleLabel : UILabel!
    var targetLabel : UILabel!
    var targetButton : UIButton!
    var startButton : UIButton!
    var name : UILabel!
    var lastName : UILabel!
    var pickerLabel : UILabel!
    var pickerView : UIPickerView!
    var num = 0
    
    
    func setUI() {
        scrollView = UIScrollView.init()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(90)
            make.left.equalToSuperview().offset(1)
            make.right.equalToSuperview().offset(-1)
            make.bottom.equalToSuperview()
        }
        
        contentView = UIView.init()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(scrollView)
        }
        
        targetView = UIView.init()
        targetView.backgroundColor = UIColor.white
        targetView.layer.masksToBounds = true
        targetView.layer.borderWidth = 0.35
        targetView.layer.borderColor = UIColor.gray.cgColor
        
        targetView.isUserInteractionEnabled = true
        let target = UITapGestureRecognizer(target: self, action: #selector(targetList))
        targetView.addGestureRecognizer(target)
        
        contentView.addSubview(targetView)
        targetView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
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
        
        pickerLabel = UILabel.init()
        pickerLabel.text = "请选择抽取人数"
        contentView.addSubview(pickerLabel)
        pickerLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(targetView.snp.bottom).offset(15)
        }
        
        pickerView = UIPickerView.init()
        pickerView.delegate = self
        pickerView.dataSource = self
        contentView.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(pickerLabel.snp.centerY)
            make.left.equalTo(pickerLabel.snp.right).offset(25)
            make.height.equalTo(50)
            make.width.equalTo(75)
        }
        
        let underline = UIView.init()
        underline.backgroundColor = UIColor.gray
        contentView.addSubview(underline)
        underline.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(pickerLabel.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.height.equalTo(0.35)
        }
        
        startButton = UIButton.init(frame: CGRect(x: self.view.frame.width/4, y: 125 , width: 200, height: 200))
        startButton.setTitle("开始", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        startButton.backgroundColor = UIColor.systemTeal
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = startButton.frame.size.width/2
        startButton.isUserInteractionEnabled = true
        startButton.addTarget(self, action: #selector(start(sender:)), for: .touchUpInside)
        contentView.addSubview(startButton)
        
        lastName = UILabel.init()
        contentView.addSubview(lastName)
        lastName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(50)
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

extension DrawViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return num
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 17.5)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = "\(row + 1)"
        pickerLabel?.textColor = UIColor.systemBlue
        return pickerLabel!
    }
}

extension DrawViewController : selectDelegate {
    func select(classList: [ClassInfo], classTag: [Int], nameList: [[String]], nameTag: [[Int]]) {
        self.classList = classList
        self.classTag = classTag
        for i in 0..<classTag.count {
            if classTag[i] == 1 {
                num = nameList[i].count
                targetLabel.text = classList[i].name
                pickerView.reloadAllComponents()
                break
            }
        }
    }
}

extension DrawViewController {
    func publish() {
        let count = pickerView.selectedRow(inComponent: 0)
        if target.count == 1 {
            ClassNetwork.shared.PublishDrawRequest(classID: target[0], num: Int(count) + 1){ (error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    self.nameList = content.drawList
                    self.done()
                } else {
                    let alter = UIAlertController(title: "发送失败", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alter.addAction(action)
                    self.present(alter, animated: true, completion: nil)
                }
            }
        } else if target.count == 0 {
            let alter = UIAlertController(title: "请选择一个班级", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alter.addAction(action)
            self.present(alter, animated: true, completion: nil)
        } else {
            let alter = UIAlertController(title: "只能选择一个班级", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alter.addAction(action)
            self.present(alter, animated: true, completion: nil)
        }
    }
    func done() {
        for n in nameList {
//            if n == nameList.first {
//                name = UILabel.init()
//                name.text = n
//                name.font = UIFont.systemFont(ofSize: 25)
//                contentView.addSubview(name)
//                name.snp.makeConstraints { (make) in
//                    make.centerX.equalToSuperview()
//                    make.top.equalTo(startButton.snp.bottom).offset(50)
//                }
//                lastName = name
//            } else {
                name = UILabel.init()
                name.text = n
                name.font = UIFont.systemFont(ofSize: 25)
                contentView.addSubview(name)
                name.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(lastName.snp.bottom).offset(25)
                    make.bottom.lessThanOrEqualTo(contentView).offset(-15)
                }
                lastName = name
//            }
        }
    }
}
