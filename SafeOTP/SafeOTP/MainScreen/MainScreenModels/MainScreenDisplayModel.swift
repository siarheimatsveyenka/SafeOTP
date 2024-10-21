//
//  MainScreenDisplayModel.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import SwiftUI

struct MainScreenDisplayModel: Identifiable {
    let id = UUID()
    var accountName: String
    var key: String
    var logo: Image
    var groupValue: String?
}
