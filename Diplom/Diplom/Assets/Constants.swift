//
//  Constants.swift
//  Diplom
//
//  Created by Nor1 on 12.07.2022.
//

import Foundation
import UIKit


enum Constants {
    
    enum Colors {
        static var mainGrey : UIColor? {
            UIColor(named: "mainGrey")
        }
        static var mainPink : UIColor? {
            UIColor(named: "mainPink")
        }
        static var mainWhite: UIColor? {
            UIColor(named: "mainWhite")
        }
        static var mainBlack: UIColor? {
            UIColor(named: "mainBlack")
        }
        static var mainBlue: UIColor? {
            UIColor(named: "mainBlue")
        }
    }
    enum Images {
        static var compliteImage : UIImage {
            UIImage(named: Bundle.main.localizedString(forKey: "CompliteImage", value: "", table: "Localizable")) ?? UIImage()
        }
    }
    enum Fonts {
        static var headerFont26 : UIFont? {
            UIFont(name: "Graphik-Semibold", size: 26)
        }
        static var headerFont17 : UIFont? {
            UIFont(name: "Graphik-Medium", size: 17)
        }
        static var mainBody15 : UIFont? {
            UIFont(name: "Graphik-Regular", size: 15)
        }
        static var smallBody13 : UIFont? {
            UIFont(name: "Graphik-Regular", size: 13)
        }
        static var button16 : UIFont? {
            UIFont(name: "Graphik-Regular", size: 16)
        }
    }
    
    enum Text {
        enum Profile {
            static let title = Bundle.main.localizedString(forKey: "Profile.title", value: "", table: "Localizable")
            static let totalSize = Bundle.main.localizedString(forKey: "Profile.totalSize", value: "", table: "Localizable")
            static let usedSize = Bundle.main.localizedString(forKey: "Profile.usedSize", value: "", table: "Localizable")
            static let freeSize = Bundle.main.localizedString(forKey: "Profile.freeSize", value: "", table: "Localizable")
            static let published = Bundle.main.localizedString(forKey: "Profile.published", value: "", table: "Localizable")
        }
        enum Recently {
            static let title = Bundle.main.localizedString(forKey: "Recently.title", value: "", table: "Localizable")
            static let empty = Bundle.main.localizedString(forKey: "Recently.empty", value: "", table: "Localizable")
        }
        enum Files {
            static let title = Bundle.main.localizedString(forKey: "Files.title", value: "", table: "Localizable")
            static let empty = Bundle.main.localizedString(forKey: "Files.empty", value: "", table: "Localizable")
            static let refresh = Bundle.main.localizedString(forKey: "Files.refresh", value: "", table: "Localizable")
        }
        enum Published {
            static let title = Bundle.main.localizedString(forKey: "Published.title", value: "", table: "Localizable")
            static let empty = Bundle.main.localizedString(forKey: "Published.empty", value: "", table: "Localizable")
            static let refresh = Bundle.main.localizedString(forKey: "Published.refresh", value: "", table: "Localizable")
            static let error = Bundle.main.localizedString(forKey: "Published.error", value: "", table: "Localizable")
            static let errorMessage = Bundle.main.localizedString(forKey: "Published.errorMessage", value: "", table: "Localizable")
            static let deletePublishing = Bundle.main.localizedString(forKey: "Published.deletePublishing", value: "", table: "Localizable")
        }
        enum Connection {
            static let title = Bundle.main.localizedString(forKey: "Connection.title", value: "", table: "Localizable")
            static let check = Bundle.main.localizedString(forKey: "Connection.check", value: "", table: "Localizable")
        }
        enum Login {
            static let buttonLogin = Bundle.main.localizedString(forKey: "Login.button", value: "", table: "Localizable")
        }
        enum Onboarding {
            static let buttonNext = Bundle.main.localizedString(forKey: "Onboarding.button", value: "", table: "Localizable")
            static let description_1 = Bundle.main.localizedString(forKey: "Onboarding.descriprion_1", value: "", table: "Localizable")
            static let description_2 = Bundle.main.localizedString(forKey: "Onboarding.descriprion_2", value: "", table: "Localizable")
            static let description_3 = Bundle.main.localizedString(forKey: "Onboarding.descriprion_3", value: "", table: "Localizable")
        }
        enum Sheet {
            static let deleteImageWarning = Bundle.main.localizedString(forKey: "Sheet.deleteImageWarning", value: "", table: "Localizable")
            static let deleteImage = Bundle.main.localizedString(forKey: "Sheet.deleteImage", value: "", table: "Localizable")
            static let deleteDoc = Bundle.main.localizedString(forKey: "Sheet.deleteDoc", value: "", table: "Localizable")
            static let deleteDocWarning = Bundle.main.localizedString(forKey: "Sheet.deleteDocWarning", value: "", table: "Localizable")
            static let cancel = Bundle.main.localizedString(forKey: "Sheet.cancel", value: "", table: "Localizable")
            static let share = Bundle.main.localizedString(forKey: "Sheet.share", value: "", table: "Localizable")
            static let viaFile = Bundle.main.localizedString(forKey: "Sheet.viaFile", value: "", table: "Localizable")
            static let viaLink = Bundle.main.localizedString(forKey: "Sheet.viaLink", value: "", table: "Localizable")
            static let refresh = Bundle.main.localizedString(forKey: "Sheet.refresh", value: "", table: "Localizable")
            static let ok = Bundle.main.localizedString(forKey: "Sheet.ok", value: "", table: "Localizable")
            static let doExit = Bundle.main.localizedString(forKey: "Sheet.doExit", value: "", table: "Localizable")
            static let exit = Bundle.main.localizedString(forKey: "Sheet.exit", value: "", table: "Localizable")
            static let agree = Bundle.main.localizedString(forKey: "Sheet.agree", value: "", table: "Localizable")
            static let yes = Bundle.main.localizedString(forKey: "Sheet.yes", value: "", table: "Localizable")
            static let no = Bundle.main.localizedString(forKey: "Sheet.no", value: "", table: "Localizable")
        }
        enum Edit {
            static let delete = Bundle.main.localizedString(forKey: "Edit.delete", value: "", table: "Localizable")
            static let share = Bundle.main.localizedString(forKey: "Edit.share", value: "", table: "Localizable")
            static let changeName = Bundle.main.localizedString(forKey: "Edit.changeName", value: "", table: "Localizable")
        }
    }
}
