//
//  InfoViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit

class InfoViewController: UIViewController {
    
    var coordinator: InfoCoordinator?
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 24.0, y: 64.0, width: UIScreen.main.bounds.width - 48.0, height: 24.0))
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var responseLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 24.0, y: 104.0, width: UIScreen.main.bounds.width - 48.0, height: 48.0))
        label.text = "ЗДЕСЬ БУДЕТ ОТВЕТ"
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 24, y: 176, width: UIScreen.main.bounds.width - 48.0, height: 48))
        button.setTitle("ОТПРАВИТЬ ЗАПРОС", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(actionSelector), for: .touchUpInside)
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    private lazy var taskSelectorField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 24, y: 240, width: UIScreen.main.bounds.width - 48.0, height: 48))
        textField.placeholder = "Введите номер задачи"
        textField.text = "Выполнить задачу номер: 1"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.layer.cornerRadius = 8.0
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(actionButton)
        view.addSubview(responseLabel)
        view.addSubview(taskSelectorField)
        view.addSubview(infoLabel)
    }
    
    @objc func actionSelector() {
        var text = taskSelectorField.text ?? " "
        let taskNumber = text.last
        text.removeLast()
        switch taskNumber {
        case "1":
            text.append("2")
            taskSelectorField.text = text
            tapActionButtonTaskOne()
        case "2":
            text.append("1")
            taskSelectorField.text = text
            tapActionButtonTaskTwo()
        default:
            taskSelectorField.text = "Выполнить задачу номер: 1"
            tapActionButtonDefault()
        }
    }
    
    func tapActionButtonDefault() {
        coordinator?.showAlert()
    }
    
    func tapActionButtonTaskOne() {
        Task {
            await NetworkService.getToDoTask(withId: (1...200).randomElement() ?? 34) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let task):
                    self.infoLabel.text = "Поставлена цель:"
                    self.responseLabel.text = task.title
                case .failure(let error):
                    switch error {
                    case .networkUnavailable(let code):
                        self.responseLabel.text = "Ошибка сети. Код: \(code)"
                    case .dataNotFound:
                        self.responseLabel.text = "Задача не найдена"
                    default:
                        self.responseLabel.text = "Что-то пошло не так"
                    }
                }
            }
        }
    }
    
    func tapActionButtonTaskTwo() {
        Task {
            await NetworkService.getTatooinePlanetInfo(completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let planet):
                    if planet.name == "Tatooine" {
                        self.infoLabel.text = "Период обращения планеты Татуин:"
                        self.responseLabel.text = planet.orbitalPeriod
                    } else {
                        self.responseLabel.text = "Мы попали не на ту планету"
                    }
                case .failure(let error):
                    switch error {
                    case .networkUnavailable(let code):
                        self.responseLabel.text = "Ошибка сети. Код: \(code)"
                    case .dataNotFound:
                        self.responseLabel.text = "Задача не найдена"
                    default:
                        self.responseLabel.text = "Что-то пошло не так"
                    }
                }
            })
        }
    }
}
