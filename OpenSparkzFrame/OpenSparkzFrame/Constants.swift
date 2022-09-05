//
//  Constants.swift
//  OpenSparkz
//
//  Created by apple on 14/02/22.
//

import Foundation


let APPNAME                = "AppName"
let error                  = "Error!"
let success                = "Success!"
let blank                  = ""


//======================Api Constants=======================


struct API_CONSTANTS {
    static let client_token            = ""
    static let kGetCardToken           = "https://playground.app.opensparkz.net/api/card/getcardaddtoken"
    static let kRegisterCard           = "https://playground.externalcard.opensparkz.net/api/registercard/registercard"
}



//======================ConstantMessages=======================
public struct MESSAGE {
    static let kOk                      = "OK"
    static let kCardNumber              = "Card Number"
    static let kEnterCardDetails        = "Enter card details"
    static let kCardExpiry              = "Expiry"
    static let kCardNumberPlaceholder   = "0000 0000 0000 0000"
    static let kCardExpiryPlaceholder   = "mm/yy"
    static let kCardNumberErrorMessage  = "Card Number does not pass Luhn check!"
    static let kCardExpiryErrorMessage  = "Card expiry is invalid"
    static let kRegisterButtonTitle     = "Register Card"
    static let kNoInternet              = "Please check your internet connection"
    
    
    
    
}
