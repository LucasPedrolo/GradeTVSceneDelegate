//
//  GradeDetailsViewController.swift
//  GradeCalculatorTableView
//
//  Created by unicred on 19/01/23.
//

import UIKit

class GradeDetailsViewController: UIViewController {
    var gradeDetailsView: GradeDetailsView = GradeDetailsView()
    var viewModel: GradeDetailsViewModel = GradeDetailsViewModel()
    var grades: [RegisterGrades] = []
    
    override func loadView() {
        view = gradeDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradeData()
        
        gradeDetailsView.calcButton.addTarget(self, action: #selector(calcData), for: .touchUpInside)
    }
    
    init(registerGrade: RegisterGrades) {
        gradeDetailsView.grade = registerGrade
        super.init(nibName: "GradeDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func calcData() {
        gradeData()
    }
    
    func gradeData() {
        if Int(gradeDetailsView.grade1TxtField.text ?? defString) != nil && Int(gradeDetailsView.grade2TxtField.text ?? defString) != nil && Int(gradeDetailsView.grade3TxtField.text ?? defString) != nil && Int(gradeDetailsView.grade4TxtField.text ?? defString) != nil {
            let result = viewModel.calcGradeData(grade1: Int(gradeDetailsView.grade1TxtField.text ?? defString) ?? defInt, grade2: Int(gradeDetailsView.grade2TxtField.text ?? defString) ?? defInt, grade3: Int(gradeDetailsView.grade3TxtField.text ?? defString) ?? defInt, grade4: Int(gradeDetailsView.grade4TxtField.text ?? defString) ?? defInt)
            
            gradeDetailsView.calcGradeLabel.text = "Média: \(result)"
        } else {
            gradeDetailsView.calcGradeLabel.text = "Média: Error"
        }
    }
}
