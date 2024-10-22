//
//  Coordinatable.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import SwiftUI

protocol Coordinatable: ObservableObject {
    associatedtype PageView: View
    
    var navPath: NavigationPath { get set }
    func push(_ page: Screen)
    func pop()
    func popToRoot()
    func build(page: Screen) -> PageView
}
