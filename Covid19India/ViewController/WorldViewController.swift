//
//  WorldViewController.swift
//  Covid19India
//
//  Created by CeX on 15/04/20.
//  Copyright © 2020 CeX. All rights reserved.
//

import UIKit

class WorldViewController: UIViewController {
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    let countryPickerView : UIPickerView = {
        let pv = UIPickerView(backgroundColor: .white)
        return pv
    }()
    
    var countries : [String] = []   {
        didSet  {
            self.selectedCountry = self.countries.first
        }
    }
    var selectedCountry : String?   {
        didSet  {
            self.countryTextField.text = self.selectedCountry
            self.chartTypeValueChanged(self.segmentedControl)
        }
    }
    
    var worldTimeSeries : WorldTimeSeries?  {
        didSet  {
            DispatchQueue.main.async {
                guard let worldTimeSeries = self.worldTimeSeries else { return }
                guard let worldDict = worldTimeSeries.toDict() else { return }
                self.countries = Array(worldDict.keys).sorted(by: {$0 < $1})
            }
        }
    }
    
    var worldDict : [String : [[String : AnyObject]]]   {
        guard let worldTimeSeries = self.worldTimeSeries else { return [:] }
        guard let worldDict = worldTimeSeries.toDict() as? [String : [[String : AnyObject]]] else { return [:]}
        return worldDict
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.dataCalls()
    }
    
    func setupViews()  {
        self.setupPickerView()
        self.setupChartView()
    }
    
    func setupPickerView() {
        self.countryPickerView.dataSource = self
        self.countryPickerView.delegate = self
        self.countryTextField.inputView = self.countryPickerView
        let statesToolbar = UIToolbar()
        statesToolbar.barStyle = .default
        statesToolbar.isTranslucent = true
        statesToolbar.sizeToFit()
        let doneBt = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(didSelectContry))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let prevSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        statesToolbar.setItems([prevSpaceButton, spaceButton, doneBt], animated: true)
        statesToolbar.isUserInteractionEnabled = true
        self.countryTextField.inputAccessoryView = statesToolbar
    }
    
    @objc func didSelectContry()  {
        self.countryTextField.resignFirstResponder()
    }
    
    func dataCalls()  {
        WorldTimeSeries.GET { (worldTimeSeries : WorldTimeSeries?, error : Error?) in
            if error != nil {
                print(error!)
            }
            else    {
                guard let worldTimeSeries = worldTimeSeries else { return }
                self.worldTimeSeries = worldTimeSeries
            }
        }
    }

    @IBAction func chartTypeValueChanged(_ sender: UISegmentedControl) {
        self.updateChartView(status: sender.selectedSegmentIndex)
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
    
    func updateChartView(status : Int)  {
        guard let selectedCountry = self.selectedCountry else { return }
        guard let selectedCountryDict = self.worldDict[selectedCountry] else { return }
         var activeChartEntries : [ChartDataEntry] = []
         var confirmedChartEntries : [ChartDataEntry] = []
         var deceasedChartEntries : [ChartDataEntry] = []
         var recoveredChartEntries : [ChartDataEntry] = []
         for point in selectedCountryDict   {
            let dateString = (point[Timeseries.CodingKeys.date.stringValue] as? String)
            let date = dateString?.toDate(dateFormat: "yyyy-MM-dd")
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = (point[Timeseries.CodingKeys.confirmed.stringValue] as? Int) ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString ?? ""), y:\(yVal)")
            confirmedChartEntries.append(chartEntry)
          }
        for point in selectedCountryDict   {
            let dateString = (point[Timeseries.CodingKeys.date.stringValue] as? String)
            let date = dateString?.toDate(dateFormat: "yyyy-MM-dd")
            let xVal = date?.timeIntervalSince1970 ?? 0
            let confirmed = (point[Timeseries.CodingKeys.confirmed.stringValue] as? Int) ?? 0
            let deceased = (point[Timeseries.CodingKeys.deaths.stringValue] as? Int) ?? 0
            let recovered = (point[Timeseries.CodingKeys.recovered.stringValue] as? Int) ?? 0
            let active = (confirmed - (deceased + recovered))
            let yVal = active
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString ?? ""), y:\(yVal)")
            activeChartEntries.append(chartEntry)
        }
        for point in selectedCountryDict   {
            let dateString = (point[Timeseries.CodingKeys.date.stringValue] as? String)
            let date = dateString?.toDate(dateFormat: "yyyy-MM-dd")
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = (point[Timeseries.CodingKeys.deaths.stringValue] as? Int) ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString ?? ""), y:\(yVal)")
            deceasedChartEntries.append(chartEntry)
        }
        for point in selectedCountryDict   {
            let dateString = (point[Timeseries.CodingKeys.date.stringValue] as? String)
            let date = dateString?.toDate(dateFormat: "yyyy-MM-dd")
            let xVal = date?.timeIntervalSince1970 ?? 0
            let yVal = (point[Timeseries.CodingKeys.recovered.stringValue] as? Int) ?? 0
            let chartEntry = ChartDataEntry(x: Double(xVal), y: Double(yVal))
            print("Data Point : x:\(dateString ?? ""), y:\(yVal)")
            recoveredChartEntries.append(chartEntry)
        }
        let chartEntries = [confirmedChartEntries,activeChartEntries,deceasedChartEntries,recoveredChartEntries]
        let colors : [UIColor] = [.blue,.systemYellow,.red,.green]
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
}

extension WorldViewController: UIPickerViewDataSource, UIPickerViewDelegate, ChartViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = self.countries[row]
    }
}
