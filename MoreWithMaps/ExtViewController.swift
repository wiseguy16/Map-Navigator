//
//  ExtViewController.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/22/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

let pantDarkGreen = UIColor(colorLiteralRed: 80/255.0, green: 97/255.0, blue: 62/255.0, alpha: 1.0)
let pantLightGreen = UIColor(colorLiteralRed: 121/255.0, green: 160/255.0, blue: 62/255.0, alpha: 1.0)
let pantBeige = UIColor(colorLiteralRed: 199/255.0, green: 160/255.0, blue: 131/255.0, alpha: 1.0)
let pantYellow = UIColor(colorLiteralRed: 243/255.0, green: 195/255.0, blue: 70/255.0, alpha: 1.0)
let pantDarkBlue = UIColor(colorLiteralRed: 0/255.0, green: 68/255.0, blue: 125/255.0, alpha: 1.0)
let pantMidBlue = UIColor(colorLiteralRed: 64/255.0, green: 122/255.0, blue: 152/255.0, alpha: 1.0)
let pantOrange = UIColor(colorLiteralRed: 233/255.0, green: 78/255.0, blue: 33/255.0, alpha: 1.0)
let pantPink = UIColor(colorLiteralRed: 203/255.0, green: 48/255.0, blue: 102/255.0, alpha: 1.0)

extension UIViewController {
    func addBlur(onImage bgView: UIImageView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgView.addSubview(blurEffectView)
    }
    
    func applyStyle1(on word: String, color: UIColor, size: CGFloat) -> NSMutableAttributedString {
        let styledWord = NSMutableAttributedString(string: word)
        let paragraphStyle = NSMutableParagraphStyle()
        let helveticaNeue = UIFont(name: "Helvetica Neue", size: size)
        //let lightGrayText = UIColor.lightGray
        let colorText = color


        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0.6 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        // *** Apply attribute to string ***
        styledWord.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range:NSMakeRange(0, styledWord.length))
        styledWord.addAttribute(NSKernAttributeName, value: CGFloat(0.3), range: NSRange(location: 0, length: styledWord.length))
        styledWord.addAttribute(NSFontAttributeName, value: helveticaNeue!, range: NSRange(location: 0, length: styledWord.length))
        styledWord.addAttribute(NSForegroundColorAttributeName, value: colorText, range: NSRange(location: 0, length: styledWord.length))
        // *** Set Attributed String to your label ***
        //fullBodyLabel.attributedText = attributedBody

        return styledWord
    }
    
    func applyStyle2(on word: String, color: UIColor, size: CGFloat) -> NSMutableAttributedString {
        let styledWord = NSMutableAttributedString(string: word)
        let paragraphStyle = NSMutableParagraphStyle()
        let helveticaNeue = UIFont(name: "HelveticaNeue-Bold", size: size)  //18.0
        //let lightGrayText = UIColor.lightGray
        let colorText = color //black
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0.6 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        // *** Apply attribute to string ***
        styledWord.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range:NSMakeRange(0, styledWord.length))
        styledWord.addAttribute(NSKernAttributeName, value: CGFloat(0.3), range: NSRange(location: 0, length: styledWord.length))
        styledWord.addAttribute(NSFontAttributeName, value: helveticaNeue!, range: NSRange(location: 0, length: styledWord.length))
        styledWord.addAttribute(NSForegroundColorAttributeName, value: colorText, range: NSRange(location: 0, length: styledWord.length))
        // *** Set Attributed String to your label ***
        //fullBodyLabel.attributedText = attributedBody
        
        return styledWord
    }
    
    func applyStyle3(on word: String, color: UIColor, size: CGFloat) -> NSMutableAttributedString {
        let styledWord = NSMutableAttributedString(string: word)
        let paragraphStyle = NSMutableParagraphStyle()
        let helveticaNeue = UIFont(name: "HelveticaNeue-Bold", size: size)  //12.0
        //let lightGrayText = UIColor.lightGray
        let colorText = color
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0.6 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        // *** Apply attribute to string ***
        styledWord.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range:NSMakeRange(0, styledWord.length))
        styledWord.addAttribute(NSKernAttributeName, value: CGFloat(0.3), range: NSRange(location: 0, length: styledWord.length))
        styledWord.addAttribute(NSFontAttributeName, value: helveticaNeue!, range: NSRange(location: 0, length: styledWord.length))
        styledWord.addAttribute(NSForegroundColorAttributeName, value: colorText, range: NSRange(location: 0, length: styledWord.length))
        // *** Set Attributed String to your label ***
        //fullBodyLabel.attributedText = attributedBody
        
        return styledWord
    }


    
    func convertTextStyling(_ wordToStyle: String?) -> NSMutableAttributedString
    {
        var attributedBody  = NSMutableAttributedString(string: "")
        if let decodedString = wordToStyle?.stringByDecodingXMLEntities()
        {
            attributedBody  = NSMutableAttributedString(string: decodedString)
        }
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        // *** Apply attribute to string ***
        attributedBody.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedBody.length))
        attributedBody.addAttribute(NSKernAttributeName, value: CGFloat(0.05), range: NSRange(location: 0, length: attributedBody.length))
        // *** Set Attributed String to your label ***
        //fullBodyLabel.attributedText = attributedBody
        
        
        return attributedBody
    }
    
    func makeDevo(_ scrpRef: String?, scrpRead: String?, scrpReflect: String?, dayOf: NSMutableAttributedString) -> NSMutableAttributedString
    {
        let noDayRead = "No Scripture reading for today."
        var dayRead: NSMutableAttributedString
        let lineBreak = NSMutableAttributedString(string: " \n")
        let italicsFont = UIFont(name: "FormaDJRText-Italic", size: 16.0)
        let darkGrayText = UIColor.darkGray
        
        let dayBase = dayOf
        let dayRef = convertTextStyling(scrpRef)
        if scrpRead == nil
        {
            dayRead = convertTextStyling(noDayRead)
        }
        else
        {
            dayRead = convertTextStyling(scrpRead)
        }
        
        
        // var range: NSRange = (self.text! as NSString).rangeOfString(scrpRead)
        dayRead.addAttribute(NSFontAttributeName, value: italicsFont!, range: NSRange(location: 0, length: dayRead.length))
        
        dayRead.addAttribute(NSForegroundColorAttributeName, value: darkGrayText, range: NSRange(location: 0, length: dayRead.length))
        
        let dayReflect = convertTextStyling(scrpReflect)
        dayBase.append(dayRef)
        dayBase.append(lineBreak)
        dayBase.append(dayRead)
        dayBase.append(lineBreak)
        dayBase.append(lineBreak)
        dayBase.append(dayReflect)
        
        return dayBase
        
    }


}






