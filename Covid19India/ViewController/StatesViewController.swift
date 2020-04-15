//
//  StatesViewController.swift
//  Covid19India
//
//  Created by CeX on 03/04/20.
//  Copyright © 2020 CeX. All rights reserved.
//

import UIKit

class StatesViewController: UITableViewController  {
    var states : [Statewise] = []   {
        didSet  {
            DispatchQueue.main.async {
                self.setRowSection()
                self.tableView.reloadData()
            }
        }
    }
    
    var rowSectionsCount : [Int : Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataCalls()
        self.tableView.tableHeaderView = StateTableHeaderView()
    }
    
    func dataCalls()  {
        Statewise.GET { (states : [Statewise]?, error : Error?) in
            if error != nil {
                print(error?.localizedDescription ?? "STATE ERROR")
            }
            else    {
                self.states = (states ?? []).sorted(by: {($0.totalConfrimedDelta) > ($1.totalConfrimedDelta) })
            }
        }
    }
    
    func setRowSection()  {
        for i in 0..<self.states.count    {
            self.rowSectionsCount[i] = 0
        }
    }
    
    func reload(forSection section : Int)  {
        self.rowSectionsCount[section] = self.rowSectionsCount[section] == 0 ? self.states[section].districtData?.count ?? 0 : 0
        self.tableView.reloadSections([section], with: .automatic)
    }
    
    @objc func handleHeaderTap(_ tap : UITapGestureRecognizer)  {
        guard let view = tap.view else { return }
        let tag = view.tag
        self.reload(forSection: tag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.states.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowSectionsCount[section] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let state = self.states[section]
        var stateHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: StateHeaderView.viewId) as? StateHeaderView
        if stateHeaderView == nil   {
            stateHeaderView = StateHeaderView()
        }
        stateHeaderView?.setState(state)
        stateHeaderView?.tag = section
        stateHeaderView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:))))
        return stateHeaderView!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let district = self.states[indexPath.section].districtData?[indexPath.row]
        var stateDistrictCell = tableView.dequeueReusableCell(withIdentifier: StateDistritCell.cellId) as? StateDistritCell
        if stateDistrictCell == nil  {
            stateDistrictCell = StateDistritCell()
        }
        stateDistrictCell?.setDistrict(district)
        return stateDistrictCell!
    }
}

class StateHeaderView: UITableViewHeaderFooterView {
    static let viewId = StateHeaderView.description()
    
    let stateView : StateView = {
        let view = StateView()
        return view
    }()
    
    convenience init()  {
        self.init(reuseIdentifier : StateHeaderView.viewId)
        self.addSubview(stateView)
        self.stateView.fillSuperview()
    }
    
    func setState(_ state : Statewise?)  {
        guard let state = state else { return }
        self.stateView.setState(state)
    }
}

class StateView: UIView {
    static let fontSize : CGFloat = 26
    let titleLabel : UILabel = {
        let label = UILabel(text: nil, font: UIFont.boldSystemFont(ofSize: fontSize), textColor: .black, textAlignment: .left, numberOfLines: 0)
        return label
    }()
    
    let deltaLabel : UILabel = {
        let label = UILabel(text: nil, font: UIFont.boldSystemFont(ofSize: fontSize), textColor: .red, textAlignment: .center, numberOfLines: 0)
        label.withWidth(70)
        return label
    }()
    
    let confirmedLabel : UILabel = {
        let label = UILabel(text: nil, font: UIFont.boldSystemFont(ofSize: fontSize), textColor: .gray, textAlignment: .right, numberOfLines: 0)
        label.withWidth(70)
        return label
    }()
    
    convenience init()  {
        self.init(frame : .zero)
        self.addSubviews(self.titleLabel,self.deltaLabel, self.confirmedLabel)
        self.titleLabel.padStartAndCenterY(withPadding: 10)
        self.deltaLabel.padLeftAndCenterY(withPadding: 0, leadingAnchor: self.titleLabel.trailingAnchor)
        self.confirmedLabel.padLeftAndCenterY(withPadding: 0, leadingAnchor: self.deltaLabel.trailingAnchor)
        self.confirmedLabel.padEndAndCenterY(withPadding: 10)
        self.deltaLabel.padRightAndCenterY(withPadding: 10, trailingAnchor: self.confirmedLabel.leadingAnchor)
    }
    
    func setState(_ state : Statewise?)  {
        guard let state = state else { return }
        self.titleLabel.text = state.state
        self.deltaLabel.text = String(state.totalConfrimedDelta)
        self.confirmedLabel.text = String(state.totalConfrimedCalculated)
    }
}

class StateDistritCell: UITableViewCell {
    static let cellId = StateDistritCell.description()

    let districtView : StateDistrictView = {
        let view = StateDistrictView()
        return view
    }()
    
    convenience init()  {
        self.init(style : .default, reuseIdentifier : StateDistritCell.cellId)
        self.setupViews()
    }
    
    func setupViews()  {
        self.selectionStyle = .none
        self.addSubview(districtView)
        self.districtView.fillSuperview()
    }
    
    func setDistrict(_ district : DistrictData?)  {
        guard let district = district else { return }
        self.districtView.setDistrict(district)
    }
}
 
class StateDistrictView: UIView {
    static let fontSize : CGFloat = 18
    
    let titleLabel : UILabel = {
       let label = UILabel(text: nil, font: UIFont.boldSystemFont(ofSize: fontSize), textColor: .black, textAlignment: .left, numberOfLines: 0)
       return label
    }()
    
    let deltaLabel : UILabel = {
        let label = UILabel(text: nil, font: UIFont.boldSystemFont(ofSize: fontSize), textColor: .red, textAlignment: .center, numberOfLines: 0)
        label.withWidth(70)
        return label
    }()
    
    let confirmedLabel : UILabel = {
        let label = UILabel(text: nil, font: UIFont.boldSystemFont(ofSize: fontSize), textColor: .gray, textAlignment: .right, numberOfLines: 0)
        label.withWidth(70)
        return label
    }()
    
    convenience init()  {
        self.init(frame : .zero)
        self.addSubviews(self.titleLabel,self.deltaLabel, self.confirmedLabel)
        self.titleLabel.padStartAndCenterY(withPadding: 10)
        self.confirmedLabel.padLeftAndCenterY(withPadding: 0, leadingAnchor: self.deltaLabel.trailingAnchor)
        self.confirmedLabel.padEndAndCenterY(withPadding: 10)
        self.deltaLabel.padRightAndCenterY(withPadding: 10, trailingAnchor: self.confirmedLabel.leadingAnchor)
    }
    
    func setDistrict(_ district : DistrictData?)  {
        guard let district = district else { return }
        self.titleLabel.text = district.district
        self.confirmedLabel.text = String(district.confirmed ?? 0)
        self.deltaLabel.text = String(district.delta?.confirmed ?? 0)
    }
}

class StateTableHeaderView: UIView {
    static let fontSize : CGFloat = 18
    
    let titleLabel : UILabel = {
       let label = UILabel(text: "State", font: UIFont.boldSystemFont(ofSize: fontSize), textColor: .black, textAlignment: .left, numberOfLines: 0)
       return label
    }()
    
    let deltaLabel : UILabel = {
        let label = UILabel(text: "Today", font: UIFont.boldSystemFont(ofSize: fontSize), textColor: .red, textAlignment: .center, numberOfLines: 0)
        label.withWidth(70)
        return label
    }()
    
    let confirmedLabel : UILabel = {
        let label = UILabel(text: "Total", font: UIFont.boldSystemFont(ofSize: fontSize), textColor: .gray, textAlignment: .right, numberOfLines: 0)
        label.withWidth(70)
        return label
    }()
    
    convenience init()  {
        self.init(frame : CGRect(x: 0, y: 0, width: Constants.width, height: 30))
        self.addSubviews(self.titleLabel,self.deltaLabel, self.confirmedLabel)
        self.titleLabel.padStartAndCenterY(withPadding: 10)
        self.confirmedLabel.padLeftAndCenterY(withPadding: 0, leadingAnchor: self.deltaLabel.trailingAnchor)
        self.confirmedLabel.padEndAndCenterY(withPadding: 10)
        self.deltaLabel.padRightAndCenterY(withPadding: 10, trailingAnchor: self.confirmedLabel.leadingAnchor)
    }
}

struct Constants {
    static let height = UIScreen.main.bounds.size.height
    static let width = UIScreen.main.bounds.size.width
}
