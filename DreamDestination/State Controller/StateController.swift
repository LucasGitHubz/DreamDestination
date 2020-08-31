//
//  ContentStateViewController.swift
//  DreamDestination
//
//  Created by kuroro on 06/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class StateController: UIViewController {
    // MARK: Properties
    private var state: State?
    private var shownViewController: UIViewController?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if state == nil {
            transition(to: .loading)
        }
    }

    // MARK: Method
    func transition(to newState: State) {
        shownViewController?.remove()
        let vc = viewController(for: newState)
        add(vc)
        shownViewController = vc
        state = newState
    }
}

extension StateController {
    enum State {
        case loading
        case render(UIViewController)
    }
}

private extension StateController {
    func viewController(for state: State) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()
        case .render(let viewController):
            return viewController
        }
    }
}
