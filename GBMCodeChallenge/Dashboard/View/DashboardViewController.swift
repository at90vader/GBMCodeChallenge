//
//  DashboardViewController.swift
//  GBMCodeChallenge
//
//  Created by Armand on 08/12/21.
//

import UIKit

class DashboardViewController: UIViewController {
    
    var presenter: ViewToPresenterDashboardProtocol?
    
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var graphFooterView: UIView!
    @IBOutlet weak var tableTitlesView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var records: [IPCRecordViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "recordCell")
        tableTitlesView.isHidden = true
        graphFooterView.isHidden = true
        logoutButton.isHidden = true
        presenter?.startFetchingRecords()
    }

    @IBAction func onLogoutTap(_ sender: Any) {
        presenter?.presentLogin()
    }
    
}

extension DashboardViewController: PresenterToViewDashboardProtocol {
    func onRecordsResponseSuccess(viewModel: DashboardViewModel) {
        
        tableTitlesView.isHidden = false
        logoutButton.isHidden = false
        graphFooterView.isHidden = false
        dateLabel.text = viewModel.date
        activityIndicator.stopAnimating()
        
        records = viewModel.records
        graphView.updateGraph(with: viewModel.recordsForGraph)
        tableView.reloadData()
    }
    
    func onRecordsResponseFailed(error: HTTPError) {
        presentAlert(with: "\(error.localizedDescription). Try Again") {
            self.presenter?.startFetchingRecords()
        }
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as? RecordTableViewCell else { return UITableViewCell() }
        cell.setupCell(with: records[indexPath.row])
        return cell
    }
}

extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        graphView.addTimeSelector(position: indexPath.row)
    }
}
