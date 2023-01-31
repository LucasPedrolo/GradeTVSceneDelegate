//
//  SubjectsListTableViewController.swift
//  GradeCalculatorTableView
//
//  Created by unicred on 19/01/23.
//

import UIKit

class SubjectListTableViewController: UIViewController {
    
    var gradesDefault: [RegisterGrades] = []
    let customView: SubjectListTableView = SubjectListTableView()
    var grades: [RegisterGrades] = []
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegate()
        setUserDefault()
        
        customView.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customView.tableView.reloadData()
    }
    
    @objc func refresh(send: UIRefreshControl) {
        DispatchQueue.main.async {
            self.customView.tableView.reloadData()
            self.customView.refreshControl.endRefreshing()
        }
    }
    
    func setUserDefault() {
        if let data = UserDefaults.standard.object(forKey: "validation") as? Data,
           let validation = try? JSONDecoder().decode(Array<RegisterGrades>.self, from: data) {
            self.gradesDefault = validation
            for i in validation {
                self.grades.append(i)
            }
        }
    }
    
    func setTableViewDelegate() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
    }
}

extension SubjectListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return grades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customView.cellID, for: indexPath) as! SubjectListTableViewCell
        cell.grade = grades[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gradeDetailViewController = GradeDetailsViewController(registerGrade: grades[indexPath.row])
        self.navigationController?.pushViewController(gradeDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            grades.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteItemsOfUserDefaults(grades: grades)
        }
    }
    
    func deleteItemsOfUserDefaults(grades: [RegisterGrades]) {
        if let encode = try? JSONEncoder().encode(grades) {
            UserDefaults.standard.set(encode, forKey: "validation")
        }
        if let data = UserDefaults.standard.object(forKey: "validation") as? Data,
           let json = try? JSONDecoder().decode(Array<RegisterGrades>.self, from: data) {
            self.grades = json
        }
        customView.tableView.reloadData()
    }
}
