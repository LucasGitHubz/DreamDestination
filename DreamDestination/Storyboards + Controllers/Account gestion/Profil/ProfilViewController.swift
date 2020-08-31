//
//  ProfilScreenController.swift
//  DreamDestination
//
//  Created by kuroro on 06/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

struct TableViewSections {
    let section: [String]
}

class ProfilViewController: UIViewController, StoryboardBased {
    // MARK: Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    // MARK: Properties
    private var profilSections = [TableViewSections]()
    var fullName = String()
    var email = String()
    var headerView = HeaderView.loadFromNib()
    var delegate: ProfilDelegateProtocol?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 0, green: 0.9014340753, blue: 0.6931453339, alpha: 1))
        setSections()
        headerView.fullNameLabel.text = fullName
        headerView.emailLabel.text = email
    }

    // MARK: Methods
    @objc func actionGiver(sender: UIButton) {
        switch sender.tag {
        case 0:
            delegate?.showList()
        case 1:
            delegate?.showCovidIncator()
        case 2:
            delegate?.resetPassword()
        case 3:
            delegate?.signOut()
        default:
            break
        }
    }
}

// MARK: TableView gestion
extension ProfilViewController: UITableViewDataSource, UITableViewDelegate {
    private func setSections() {
        profilSections.append(TableViewSections.init(section: ["Ma liste de voyage à faire  📝",
        "Destinations à risque (Covid-19) ❗️"]))
        
        profilSections.append(TableViewSections.init(section: ["Réinitialiser mon mot de passe",
                                                               "Se déconnecter"]))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profilSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profilSections[section].section.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = headerView
            
            view.roundedImage()

            return view
        }

        let view = UIView()

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        }
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(cellType: ProfilCell.self)
        let cell: ProfilCell = tableView.dequeueReusableCell(for: indexPath)

        let section = profilSections[indexPath.section].section[indexPath.row]
        
        cell.rawLabel.text = section
        if indexPath.section == 0 {
            cell.button.tag = indexPath.row
        } else {
            cell.button.tag = indexPath.row + 2
        }
        
        cell.button.addTarget(self, action: #selector(self.actionGiver), for: .touchUpInside)

        return cell
    }
}
