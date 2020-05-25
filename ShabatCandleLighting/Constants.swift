//
//  Constants.swift
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 25/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import Foundation


@objc(Constants)
public class Constants: NSObject {

    // Notification center
    @objc public let NOTIF_CITY_NAME_WAS_CHOOSEN = "cityNameWasChoosen"
    @objc public let NOTIF_CHOSEN_CITY_KEY = "cityNameFromSlideMenu"

    // UserDefaults
    @objc public let USER_DEF_GROUP_KEY = "group.ShabbatCandles"
    
}


