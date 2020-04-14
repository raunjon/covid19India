//
//  ViewController.swift
//  Covid19India
//
//  Created by CeX on 03/04/20.
//  Copyright © 2020 CeX. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChartViewDelegate {
    var response : Response?    {
        didSet  {
            DispatchQueue.main.async {
                self.setResponseValues()
                self.setupIndiaTimeSeritsChartView(indiaTimeSeries: self.response?.cases_time_series, status: 0)
            }
        }
    }
    
    @IBOutlet weak var indiaChartView: LineChartView!
    @IBOutlet weak var confirmedDeltaLabel: UILabel!
    @IBOutlet weak var confirmedTotalLabel: UILabel!
    @IBOutlet weak var deceasedDeltaLabel: UILabel!
    @IBOutlet weak var deceasedTotalLabel: UILabel!
    @IBOutlet weak var recoveredDeltaLabel: UILabel!
    @IBOutlet weak var recoveredTotalLabel: UILabel!
    @IBOutlet weak var currentlyActiveLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var statesTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stateConfirmedTotalLabel: UILabel!
    @IBOutlet weak var stateConfirmedDeltaLabel: UILabel!
    @IBOutlet weak var stateDeceasedDeltaLabel: UILabel!
    @IBOutlet weak var stateDeceasedTotalLabel: UILabel!
    @IBOutlet weak var stateRecoveredTotalLabel: UILabel!
    @IBOutlet weak var stateCurrentlyActiveLabel: UILabel!
    @IBOutlet weak var stateRecoveredDeltaLabel: UILabel!
    @IBOutlet weak var stateStatusSegmentedControl: UISegmentedControl!
    
    var stateWiseData : StateWiseData?
    var statesDailyData : [StatesDailyData]    {
        return self.stateWiseData?.states_daily ?? []
    }
    var statesConfirmedData : [StatesDailyData]    {
        return self.stateWiseData?.states_daily_confirmed ?? []
    }
    var statesDeceasedData : [StatesDailyData] {
        return self.stateWiseData?.states_daily_deceased ?? []
    }
    var statesRecoveredData : [StatesDailyData]    {
        return self.stateWiseData?.states_daily_recovered ?? []
    }
    var statesActiveData : [StatesDailyData]    {
        return self.stateWiseData?.getActive(forState: self.selectedStateCode) ?? []
    }
    
    var statesData : [String : [Statewise]] = [:]   {
        didSet  {
            DispatchQueue.main.async {
                self.statesPickerView.reloadAllComponents()
                self.selectedStateCode = self.statesPickerValues.first
                self.setupChartData(withStatus: 0, stateCode: self.statesPickerValues.first)
            }
        }
    }
    
    var selectedStateCode : String? {
        didSet  {
            guard let selectedStateCode = self.selectedStateCode else { return }
            self.statesTextField.text = StateCode.Dictionary[selectedStateCode]
            self.updateStateData()
        }
    }
    
    let statesPickerView : UIPickerView = {
        let pv = UIPickerView(backgroundColor: .white)
        return pv
    }()

    var statesPickerValues : [String]   {
        return Array(self.statesData.keys).sorted(by:<)    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.dataCalls()
    }
    
    func setupViews()  {
        self.setupChartView()
        self.setupIndiaChartView()
        self.setupPickerView()
        self.setupScrollView()
    }
    
    func setupScrollView()  {
        self.scrollView.frame.size = CGSize(width: Constants.width, height: Constants.height)
        self.scrollView.contentSize = CGSize(width: Constants.width, height: Constants.height*2)
    }
    
    @objc func didSelectState()  {
        self.statesTextField.resignFirstResponder()
    }
    
    func updateStateData()  {
        guard let statewise = self.response?.statewise else { return }
        guard let selectedState = statewise.filter({$0.statecode == self.selectedStateCode}).first else { return }
        self.stateConfirmedTotalLabel.text = selectedState.confirmed
        self.stateConfirmedDeltaLabel.text = selectedState.deltaconfirmed
        self.stateDeceasedTotalLabel.text = selectedState.deaths
        self.stateDeceasedDeltaLabel.text = selectedState.deltadeaths
        self.stateRecoveredTotalLabel.text = selectedState.recovered
        self.stateRecoveredDeltaLabel.text = selectedState.deltarecovered
        self.stateCurrentlyActiveLabel.text = selectedState.active
    }
    
    func setupPickerView() {
        self.statesPickerView.dataSource = self
        self.statesPickerView.delegate = self
        self.statesTextField.inputView = self.statesPickerView
        self.selectedStateCode = self.statesPickerValues.first
        let statesToolbar = UIToolbar()
        statesToolbar.barStyle = .default
        statesToolbar.isTranslucent = true
        statesToolbar.sizeToFit()
        let doneBt = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(didSelectState))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let prevSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        statesToolbar.setItems([prevSpaceButton, spaceButton, doneBt], animated: true)
        statesToolbar.isUserInteractionEnabled = true
        self.statesTextField.inputAccessoryView = statesToolbar
    }
    
    func setupChartView()  {
        self.chartView.delegate = self
        self.chartView.chartDescription?.enabled = true
        self.chartView.dragEnabled = true
        self.chartView.setScaleEnabled(true)
        self.chartView.pinchZoomEnabled = true
        self.chartView.highlightPerDragEnabled = true
        self.chartView.backgroundColor = .white
        self.chartView.legend.enabled = true
         
        let xAxis = self.chartView.xAxis
        xAxis.labelPosition = .topInside
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 3600
        xAxis.valueFormatter = DateValueFormatter()
         
        let leftAxis = self.chartView.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 1000
        leftAxis.yOffset = -9
        leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        
        self.chartView.rightAxis.enabled = true
        self.chartView.legend.form = .circle
        self.chartView.animate(xAxisDuration: 2.5)
    }

    func setupIndiaChartView()  {
        self.indiaChartView.delegate = self
        self.indiaChartView.chartDescription?.enabled = true
        self.indiaChartView.dragEnabled = true
        self.indiaChartView.setScaleEnabled(true)
        self.indiaChartView.pinchZoomEnabled = true
        self.indiaChartView.highlightPerDragEnabled = true
        self.indiaChartView.backgroundColor = .white
        self.indiaChartView.legend.enabled = true
         
        let xAxis = self.indiaChartView.xAxis
        xAxis.labelPosition = .topInside
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 3600
        xAxis.valueFormatter = DateValueFormatter()
         
        let leftAxis = self.indiaChartView.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 1000
        leftAxis.yOffset = -9
        leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        
        self.indiaChartView.rightAxis.enabled = true
        self.indiaChartView.legend.form = .circle
        self.indiaChartView.animate(xAxisDuration: 2.5)
    }
    
    
   func setupIndiaTimeSeritsChartView(indiaTimeSeries : [CaseTimeSeries]?, status : Int)  {
        guard let indiaTimeSeries = indiaTimeSeries else { return }
        var activeChartEntries : [ChartDataEntry] = []
        var confirmedChartEntries : [ChartDataEntry] = []
        var deceasedChartEntries : [ChartDataEntry] = []
        var recoveredChartEntries : [ChartDataEntry] = []
        for point in indiaTimeSeries   {
            let dateString = (point.date ?? "") + "2020"
            let date = dateString.toDate(dateFormat: "dd MMM yyyy")
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = Int(point.active ?? "") ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString), y:\(yVal)")
            activeChartEntries.append(chartEntry)
       }
        for point in indiaTimeSeries   {
            let dateString = (point.date ?? "") + "2020"
            let date = dateString.toDate(dateFormat: "dd MMM yyyy")
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = Int(point.totalconfirmed ?? "") ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString), y:\(yVal)")
            confirmedChartEntries.append(chartEntry)
        }
        for point in indiaTimeSeries   {
            let dateString = (point.date ?? "") + "2020"
            let date = dateString.toDate(dateFormat: "dd MMM yyyy")
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = Int(point.totaldeceased ?? "") ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString), y:\(yVal)")
            deceasedChartEntries.append(chartEntry)
        }
        for point in indiaTimeSeries   {
            let dateString = (point.date ?? "") + "2020"
            let date = dateString.toDate(dateFormat: "dd MMM yyyy")
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = Int(point.totalrecovered ?? "") ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString), y:\(yVal)")
            recoveredChartEntries.append(chartEntry)
        }
        let chartEntries = [confirmedChartEntries,activeChartEntries,deceasedChartEntries,recoveredChartEntries]
        let colors : [UIColor] = [.blue,.yellow,.red,.green]
        let dataSets = ["Confirmed", "Active", "Deceased", "Recovered"]
        var lineChartDataSet : [LineChartDataSet] = []
        var i = 0
        for chartEntry in chartEntries  {
            let set1 = LineChartDataSet(entries: chartEntry, label: dataSets[i])
            set1.axisDependency = .left
            set1.setColor(colors[i])
            set1.lineWidth = 1.5
            set1.drawCirclesEnabled = false
            set1.drawValuesEnabled = true
            set1.fillAlpha = 0.26
            set1.fillColor = colors[i]// UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            lineChartDataSet.append(set1)
            i = i + 1
        }
        var finalDataSet = lineChartDataSet
        if status != 0  {
            finalDataSet = [lineChartDataSet[status - 1]]
        }
        let data = LineChartData(dataSets: finalDataSet)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        self.indiaChartView.data = data
        self.indiaChartView.leftAxis.axisMaximum = data.yMax*1.1
   }

    func getData(withStates states : [Statewise])  {
        StateWiseData.GET { (stateWiseData : StateWiseData?, error : Error?) in
            if error != nil {
                print(error?.localizedDescription ?? "ERROR 5")
            }
            else    {
                self.stateWiseData = stateWiseData
                self.statesData = stateWiseData?.getForStates(states) ?? [:]
            }
        }
    }
    func setupChartData(withStatus status : Int? , stateCode : String?)   {
        guard let stateCode = stateCode else { return }
        guard let status = status else { return }
        guard let statesDailyData = self.statesData[stateCode] else {
            return
        }
        if self.segmentedControl.selectedSegmentIndex == 0  {
            self.setupCummilativeChartView(statesDailyData: statesDailyData, status: status)
        }
        else    {
            self.setupDailyChartView(status: status)
        }
    }
    
    func setupCummilativeChartView(statesDailyData : [Statewise], status : Int)  {
        var activeChartEntries : [ChartDataEntry] = []
        var confirmedChartEntries : [ChartDataEntry] = []
        var deceasedChartEntries : [ChartDataEntry] = []
        var recoveredChartEntries : [ChartDataEntry] = []
        for point in statesDailyData   {
            let dateString = point.date ?? ""
            let date = dateString.toDate()
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = Int(point.confirmed ?? "") ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString), y:\(yVal)")
            confirmedChartEntries.append(chartEntry)
        }
        for point in statesDailyData   {
            let dateString = point.date ?? ""
            let date = dateString.toDate()
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = Int(point.active ?? "") ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString), y:\(yVal)")
            activeChartEntries.append(chartEntry)
        }
        for point in statesDailyData   {
            let dateString = point.date ?? ""
            let date = dateString.toDate()
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = Int(point.deaths ?? "") ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString), y:\(yVal)")
            deceasedChartEntries.append(chartEntry)
        }
        for point in statesDailyData   {
            let dateString = point.date ?? ""
            let date = dateString.toDate()
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = Int(point.recovered ?? "") ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString), y:\(yVal)")
            recoveredChartEntries.append(chartEntry)
        }
        let chartEntries = [confirmedChartEntries,activeChartEntries,deceasedChartEntries,recoveredChartEntries]
        let colors : [UIColor] = [.blue,.yellow,.red,.green]
        let dataSets = ["Confirmed", "Active", "Deceased", "Recovered"]
        var lineChartDataSet : [LineChartDataSet] = []
        var i = 0
        for chartEntry in chartEntries  {
            let set1 = LineChartDataSet(entries: chartEntry, label: dataSets[i])
            set1.axisDependency = .left
            set1.setColor(colors[i])
            set1.lineWidth = 1.5
            set1.drawCirclesEnabled = false
            set1.drawValuesEnabled = true
            set1.fillAlpha = 0.26
            set1.fillColor = colors[i]
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            lineChartDataSet.append(set1)
            i = i + 1
        }
        var finalDataSet = lineChartDataSet
        if status != 0  {
            finalDataSet = [lineChartDataSet[status - 1]]
        }
        let data = LineChartData(dataSets: finalDataSet)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
       
        self.chartView.data = data
        self.chartView.leftAxis.axisMaximum = data.yMax*1.1
    }
    
   func setupDailyChartView(status : Int)  {
        let activeChartEntries : [ChartDataEntry] = []
        let confirmedChartEntries : [ChartDataEntry] = []
        let deceasedChartEntries : [ChartDataEntry] = []
        let recoveredChartEntries : [ChartDataEntry] = []
        let stateStatusDataSet = [self.statesConfirmedData, self.statesActiveData, self.statesDeceasedData, self.statesRecoveredData]
        let colors : [UIColor] = [.blue,.systemYellow,.red,.green]
        let dataSets = ["Confirmed", "Active", "Deceased", "Recovered"]
        var lineChartDataSet : [LineChartDataSet] = []
        var i = 0
        let chartEntries = [confirmedChartEntries,activeChartEntries,deceasedChartEntries,recoveredChartEntries]
        var finalChartEntries : [[ChartDataEntry]] = []
        for data in stateStatusDataSet {
            var chartEntrySingle = chartEntries[i]
            for point in data   {
                if let dateString = point.date  {
                    let date = dateString.toDate()
                    let xVal = date?.timeIntervalSince1970 ?? 0
                    let yVal = Int((point.toDict()?[self.selectedStateCode?.lowercased() ?? ""] as? String) ?? "") ?? 0
                    let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
                    print("Data Point : x:\(dateString), y:\(yVal)")
                    chartEntrySingle.append(chartEntry)
            }
        }
            finalChartEntries.append(chartEntrySingle)
            i = i + 1
        }
        var j = 0
        for chartEntry in finalChartEntries  {
            let set1 = LineChartDataSet(entries: chartEntry, label: dataSets[j])
            set1.axisDependency = .left
            set1.setColor(colors[j])
            set1.lineWidth = 1.5
            set1.drawCirclesEnabled = false
            set1.drawValuesEnabled = true
            set1.fillAlpha = 0.26
            set1.fillColor = colors[j]
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            lineChartDataSet.append(set1)
            j = j + 1
        }
        var finalDataSet = lineChartDataSet
        if status != 0  {
            finalDataSet = [lineChartDataSet[status - 1]]
        }
        let chartData = LineChartData(dataSets: finalDataSet)
        chartData.setValueTextColor(.white)
        chartData.setValueFont(.systemFont(ofSize: 9, weight: .light))
        self.chartView.data = chartData
        self.chartView.leftAxis.axisMaximum = chartData.yMax*1.1
   }
    
    func dataCalls()  {
        Response.GET { (response : Response?, error : Error?) in
            if error != nil {
                print(error?.localizedDescription ?? "Response Error")
            }
            else    {
                self.response = response
                
                self.getData(withStates: response?.statewise ?? [])
            }
        }
    }
    
    func getState(_ stateCode : String) -> Statewise? {
        for state in self.response?.statewise ?? []    {
            if state.statecode == stateCode {
                return state
            }
        }
        return nil
    }
    
    @IBAction func countrySegmentControlValueChanged(_ sender: UISegmentedControl) {
        self.setupIndiaTimeSeritsChartView(indiaTimeSeries: self.response?.cases_time_series, status: sender.selectedSegmentIndex)
    }
    
    @IBAction func changedValue(_ sender: UISegmentedControl) {
        self.setupChartData(withStatus: self.stateStatusSegmentedControl.selectedSegmentIndex, stateCode: self.selectedStateCode)
    }

    @IBAction func stateSegmentedControlValueChanged(_ sender: Any) {
        self.setupChartData(withStatus: self.stateStatusSegmentedControl.selectedSegmentIndex, stateCode: self.selectedStateCode)
    }
    
    func setResponseValues()  {
        guard let response = self.response else { return }
        if let state = response.statewise?.first {
            self.confirmedTotalLabel.text = "\(state.confirmed ?? "")"
            self.confirmedDeltaLabel.text = "\(state.deltaconfirmed ?? "")"
            self.deceasedDeltaLabel.text = "\(state.deltadeaths ?? "")"
            self.deceasedTotalLabel.text = "\(state.deaths ?? "")"
            self.recoveredDeltaLabel.text = "\(state.deltarecovered ?? "")"
            self.recoveredTotalLabel.text = "\(state.recovered ?? "")"
            self.currentlyActiveLabel.text = "\(state.active ?? "")"
        }
    }
}

extension String    {
    func toDate(dateFormat : String = "dd-MM-yy") -> Date?  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.statesPickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (StateCode.Dictionary[self.statesPickerValues[row]]) ?? "" == "" {
            print(self.statesPickerValues[row])
        }
        return (StateCode.Dictionary[self.statesPickerValues[row]])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedStateCode = self.statesPickerValues[row]
        self.setupChartData(withStatus: self.stateStatusSegmentedControl.selectedSegmentIndex, stateCode: self.selectedStateCode)
    }
}
