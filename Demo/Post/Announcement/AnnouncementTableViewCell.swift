//
//  AnnouncementTableViewCell.swift
//  Demo
//
//  Created by HK on 2021/7/23.
//

import UIKit

protocol DataDelegate : NSObjectProtocol{
//    func getTarget(target:[String])
    func getTitle(title:String)
    func getType(type:String)
    func getContent(content:String)
    func getDate(date: String ,tag: Int)
}

//MARK: TargetCell

class TargetCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    var dataDelegate : DataDelegate?
    var titleLabel : UILabel!
    var listButton : UIButton!
    var listLabel : UILabel!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "发送给"
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        listButton = UIButton.init()
        listButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        listButton.addTarget(self, action: #selector(list(sender:)), for: .touchUpInside)
        self.contentView.addSubview(listButton)
        listButton.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        listLabel = UILabel.init()
        listLabel.text = "请选择发送对象"
        listLabel.textColor = UIColor.gray
        self.contentView.addSubview(listLabel)
        listLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(listButton.snp.left).offset(-10)
        }
    }
    
//    @objc func list (sender:UIButton) {
//        print("list")
//
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: TitleCell

class TitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var dataDelegate : DataDelegate?
    
    var titleLabel : UILabel!
    var titleText : UITextField!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "标题"
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        titleText = UITextField.init()
        titleText.placeholder = "请输入标题"
        titleText.textAlignment = .right
        titleText.returnKeyType = .done
        titleText.delegate = self
        titleText.addTarget(self, action: #selector(sendText(sender:)), for: .editingDidEnd)
        self.contentView.addSubview(titleText)
        titleText.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(300)
            make.height.equalToSuperview()
        }
    }
    
    @objc func sendText (sender:UITextField) {
        dataDelegate?.getTitle(title: titleText.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension TitleCell : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        titleText.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
        titleText.resignFirstResponder()
    }
}

//MARK: TypeCell

class TypeCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var dataDelegate : DataDelegate?
    var titleLabel : UILabel!
    var typeA : UIButton!
    var typeB : UIButton!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "类型"
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        typeB = UIButton.init()
        typeB.setTitle("B", for: .normal)
        typeB.setTitleColor(.black, for: .normal)
        typeB.setImage(UIImage(systemName: "circle"), for: .normal)
        typeB.addTarget(self, action: #selector(typeB(sender:)), for: .touchUpInside)
        typeB.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
//        self.accessoryView = readAndCheck
        self.contentView.addSubview(typeB)
        typeB.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        typeA = UIButton.init()
        typeA.setTitle("A", for: .normal)
        typeA.setTitleColor(.black, for: .normal)
        typeA.setImage(UIImage(systemName: "circle"), for: .normal)
        typeA.addTarget(self, action: #selector(typeA(sender:)), for: .touchUpInside)
        typeA.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
//        self.accessoryView = readOnly
        self.contentView.addSubview(typeA)
        typeA.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(typeB.snp.left).offset(-20)
        }
    }
    
    @objc func typeA (sender:UIButton) {
        dataDelegate?.getType(type:(typeA.titleLabel?.text!)!)
        typeA.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        typeB.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @objc func typeB (sender:UIButton) {
        dataDelegate?.getType(type:(typeB.titleLabel?.text!)!)
        typeB.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        typeA.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: DateCell

class DateCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataDelegate : DataDelegate?
    var titleLabel : UILabel!
    var datePicker : UIDatePicker!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "截止时间"
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        datePicker = UIDatePicker.init()
        datePicker.locale = Locale.init(identifier: "zh_CN")
        datePicker.addTarget(self, action: #selector(sendDate(sender:)), for: .valueChanged)
        self.contentView.addSubview(datePicker)
        datePicker.snp.makeConstraints{ (make) in
            make.height.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    @objc func sendDate (sender:UIDatePicker) {
        let date = datePicker.date
        let dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dataDelegate?.getDate(date:dateFormater.string(from: date),tag: self.tag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: ContentCell

protocol PhotoDelegate: NSObjectProtocol {
    func PhotoVC()
}

protocol DocumentDelegate: NSObjectProtocol {
    func documentVC()
}

class ContentCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataDelegate : DataDelegate?
    var documentDelegate : DocumentDelegate?
    var photoDelegate : PhotoDelegate?
    
    var titleLabel : UILabel!
    var contentText : UITextView!
    var photoButton : UIButton!
    var fileButton : UIButton!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "内容"
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
        }
        
        contentText = UITextView.init()
        contentText.isEditable = true
        contentText.text = "请输入内容"
        contentText.font = UIFont.systemFont(ofSize: 17.5)
        contentText.textColor = UIColor.placeholderText
        contentText.delegate = self
        contentText.layer.masksToBounds = true
        contentText.layer.cornerRadius = 12.0
        contentText.layer.borderWidth = 0.5
        contentText.layer.borderColor = UIColor.gray.cgColor
        self.contentView.addSubview(contentText)
        contentText.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(225)
            make.width.equalToSuperview().offset(-20)
        }
        
        photoButton = UIButton.init()
        photoButton.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        photoButton.addTarget(self, action: #selector(getPhoto(sender:)), for: .touchUpInside)
        self.contentView.addSubview(photoButton)
        photoButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentText.snp.left)
            make.top.equalTo(contentText.snp.bottom).offset(7.5)
        }
        
        fileButton = UIButton.init()
        fileButton.setImage(UIImage(systemName: "folder"), for: .normal)
        fileButton.addTarget(self, action: #selector(getfile(sender:)), for: .touchUpInside)
        self.contentView.addSubview(fileButton)
        fileButton.snp.makeConstraints { (make) in
            make.left.equalTo(photoButton.snp.right).offset(15)
            make.top.equalTo(photoButton.snp.top)
        }
    }
    
    @objc func getPhoto (sender:UIButton) {
        photoDelegate?.PhotoVC()
    }
    
    @objc func getfile (sender:UIButton) {
        documentDelegate?.documentVC()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ContentCell: UITextViewDelegate {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
        contentText.resignFirstResponder()
        self.endEditing(false)
        dataDelegate?.getContent(content: contentText.text)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "请输入内容"
            textView.textColor = UIColor.placeholderText
        }
    }
}

//MARK: ImageCell
protocol imageDelegate : NSObjectProtocol {
    func imageNum(imageNum:Int)
}
class ImageCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageList = [UIImage]()
    var collectionView : UICollectionView!
    var imageDelegate : imageDelegate?
    var row = 1

    func setUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.isUserInteractionEnabled = true
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
            make.height.equalToSuperview()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ImageCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.imageDelegate = self
        cell.image = imageList[indexPath.row]
        cell.num = indexPath.row
        cell.setUI()
        cell.isUserInteractionEnabled = true
        return cell
    }

}
extension ImageCell : imageDelegate {
    func imageNum(imageNum: Int) {
        imageList.remove(at: imageNum)
        collectionView.reloadData()
        imageDelegate?.imageNum(imageNum: imageNum)
        print("tableCell")
    }
}


//MARK: ImageCollectionCell

class ImageCollectionCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    var image : UIImage!
    var underView : UIView!
    var view : UIImageView!
    var oldView : UIImageView!
    var button : UIButton!
    var num = 0
    var imageDelegate : imageDelegate?
    
    func setUI() {
        view = UIImageView.init()
        view.image = image
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        underView = UIView.init()
        underView.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        view.addSubview(underView)
        underView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        button = UIButton.init()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
        underView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    
    @objc func deleteImage (sender:UIButton) {
        print("collectionCell")
        imageDelegate?.imageNum(imageNum: num)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: FileCell

protocol DeleteDelegate : NSObjectProtocol {
    func delete(row:Int)
}
class FileCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var fileName : String!
    var image : UIImageView!
    var titleLabel : UILabel!
    var button : UIButton!
    var deleteDelegate : DeleteDelegate!
    var row = 0
    
    func setUI() {
        image = UIImageView.init()
        let type = fileName.split(separator: ".").last
        image.image = UIImage(named: "\(type!)")
        self.contentView.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        titleLabel = UILabel.init()
        titleLabel.text = fileName
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(image.snp.right).offset(25)
        }
        
        button = UIButton.init()
//        button.tag = num
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
    }
    
    @objc func delete (sender:UIButton) {
        deleteDelegate.delete(row: row)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
