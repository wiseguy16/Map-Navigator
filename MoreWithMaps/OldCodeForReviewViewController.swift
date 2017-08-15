//
//  OldCodeForReviewViewController.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/14/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import UIKit
import AVFoundation

class OldCodeForReviewViewController: UIViewController {
    
    // Daniel
    let daniel = "com.apple.ttsbundle.Daniel-compact"


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vcs = AVSpeechSynthesisVoice.speechVoices()
        // var newVoice = AVSpeechSynthesisVoice().quality.rawValue
        
        let myVoice = AVSpeechSynthesisVoice(identifier: daniel)
        let phrase = "Hello friend! How are you doing today? My name is Daniel. Today we go over how to get turn by turn directions with MapKit, Core Location, and AVFoundation using Swift 4. This is a step by step tutorial that will explain what is happening in each line of code so you can grasp the full concept of how to get the user’s current location and allow them to search for a point of interest and get directions to that location."
        let speechUtterance = AVSpeechUtterance(string: phrase)
        //myVoice!.quality = .enhanced
        speechUtterance.voice = myVoice
        // speechUtterance.rate = 0.5
        speechUtterance.pitchMultiplier = 1.0
        
        
        
    }
    
    /*
     Create question model to get questions and contents of the questions in to an array. Cast your snapshot to Dictionary then get the values;
     
     class QuestionModel: NSObject {
     var CorrectAnswer: String!
     var Question: String!
     var optionA: String!
     var optionB: String!
     var optionC: String!
     
     init(snapshot: FIRDataSnapshot) {
     if let snapshotDict = snapshot.value as? Dictionary<String, Any> {
     CorrectAnswer = snapshotDict["CorrectAnswer"] as? String
     Question = snapshotDict["Question"] as? String
     optionA = snapshotDict["optionA"] as? String
     optionB = snapshotDict["optionB"] as? String
     optionC = snapshotDict["optionC"] as? String
     }
     }
     }
     in your callback;
     
     var questionModels : [QuestionModel] = []
     FIRDatabase.database().reference().child("English").observe(.value, with: {
     snapshot in
     
     for child in snapshot.children {
     let user = QuestionModel.init(snapshot: (child as? FIRDataSnapshot)!)
     self.questionModels.append(user)
     }
     
     
     })
     You must send requests as many as nodes count like FIRDatabase.database().reference().child("English"), FIRDatabase.database().reference().child("AnotherSubject"). And you don't need to var answer = [["Answer","a1","b1","c1"], ["Answer2","a2","b2","c2"],[...]]. The question array you have will do the same thing. You can do questionModels[0].CorrectAnswer or whatever you want
     
     */



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func yourFunctionName(finished: () -> Void) {
        
        print("Doing something!")
        
        finished()
        
    }
    
    func useTheClosure() {
        
        yourFunctionName {
            
            //do something here after running your function
            print("Tada!!!!")
        }
        
    }
    
    func formatted() {
        //First time with False arg
        isSuccessful(val: false, success: { () -> Void in
            print("False Block")
        })
        
        //Second time with True arg
        isSuccessful(val: true, success: { () -> Void in
            print("True Block")
        })
        
        
    }
    
    func success() {
        print("This is the success block")
    }
    
    func hasError() {
        print("This is the hasError block")
    }
    
    
    
    func isSuccessful(val: Bool, success: () -> Void) {
        if val {
            success()
        } else {
            hasError()
        }
    }

    //ref?.child("Orlando").child(dict["title"]).
    //                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("title").setValue(dict["title"])
    //                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("imageName").setValue(dict["imageName"])
    //                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("beaconName").setValue(dict["beaconName"])
    //                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("locatCoordLat").setValue(dict["locatCoordLat"])
    //                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("locatCoordLong").setValue(dict["locatCoordLong"])
    //                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("category").setValue(dict["category"])
    //                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("web").setValue(dict["web"])
    //

    
    
    //                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("title").setValue(dict["title"])
    //                ref?.child("Orlando").childByAutoId().child("imageName").setValue(dict["imageName"])
    //                ref?.child("Orlando").childByAutoId().child("beaconName").setValue(dict["beaconName"])
    //                ref?.child("Orlando").childByAutoId().child("locatCoordLat").setValue(dict["locatCoordLat"])
    //                ref?.child("Orlando").childByAutoId().child("locatCoordLong").setValue(dict["locatCoordLong"])
    //                ref?.child("Orlando").childByAutoId().child("category").setValue(dict["category"])
    //                ref?.child("Orlando").childByAutoId().child("web").setValue(dict["web"])
    
    

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
     -KrXSup9UXNKDCGG7AvDaddclose
     beaconName:
     "sandwich-2.png"
     category:
     "Food"
     imageName:
     "craftVine.jpg"
     locatCoordLat:
     28.627671
     locatCoordLong:
     -81.48541
     title:
     "Craft & Vine"
     web:
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXSupFl5nUFHM5Hfk7
     beaconName:
     "citysquare.png"
     category:
     "Historic"
     imageName:
     "humaniTree.jpg"
     locatCoordLat:
     28.612066
     locatCoordLong:
     -81.441256
     title:
     "Humanitree House"
     web:
     "http://augustalocallygrown.org/wp-content/uploa..."
     -KrXSupGThutX42omOHW
     beaconName:
     "lighthouse-2.png"
     category:
     "Utility"
     imageName:
     "metro.jpg"
     locatCoordLat:
     28.69523
     locatCoordLong:
     -81.406105
     title:
     "Metro Coffee House"
     web:
     "http://scontent-atl3-1.xx.fbcdn.net/v/t1.0-9/10..."
     -KrXSupHPofTp2FiPlWX
     beaconName:
     "treasure_chest.png"
     category:
     "Business"
     imageName:
     "modInk.jpg"
     locatCoordLat:
     28.632891
     locatCoordLong:
     -81.449309
     title:
     "MOD Ink"
     web:
     "http://static1.squarespace.com/static/58a8d93ec..."
     -KrXSupIFJbKLfz8qWpo
     beaconName:
     "sandwich-2.png"
     category:
     "Food"
     imageName:
     "newMoon.jpg"
     locatCoordLat:
     28.5754
     locatCoordLong:
     -81.388
     title:
     "The New Moon Cafe"
     web:
     "http://newmoondowntown.homestead.com/files/Quic..."
     -KrXSupJMOViGxVpUU9F
     beaconName:
     "citysquare.png"
     category:
     "Historic"
     imageName:
     "mellowMushroom.jpg"
     locatCoordLat:
     28.5523
     locatCoordLong:
     -81.3915
     title:
     "Mellow Mushroom Pizza"
     web:
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXSupKre06NDontpha
     beaconName:
     "lighthouse-2.png"
     category:
     "Utility"
     imageName:
     "pizzaJoint.jpg"
     locatCoordLat:
     28.5812
     locatCoordLong:
     -81.3253
     title:
     "The Pizza Joint"
     web:
     "http://www.myherocard.com/wp-content/uploads/20..."
     -KrXSupL4Ma4pafgxVLi
     beaconName:
     "treasure_chest.png"
     category:
     "Business"
     imageName:
     "stillWater.jpg"
     locatCoordLat:
     28.5155
     locatCoordLong:
     -81.3356
     title:
     "Stillwater Tap Room"
     web:
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXTDhwzh3QcVgkNXaF
     beaconName:
     "sandwich-2.png"
     category:
     "Food"
     imageName:
     "craftVine.jpg"
     locatCoordLat:
     28.626671
     locatCoordLong:
     -81.43541
     title:
     "Craft & Vine"
     web:
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXTDhzG6f4UrI02_FW
     beaconName:
     "citysquare.png"
     category:
     "Historic"
     imageName:
     "humaniTree.jpg"
     locatCoordLat:
     28.632066
     locatCoordLong:
     -81.431256
     title:
     "Humanitree House"
     web:
     "http://augustalocallygrown.org/wp-content/uploa..."
     -KrXTDi-R1vdUvXCrfPc
     beaconName:
     "lighthouse-2.png"
     category:
     "Utility"
     imageName:
     "metro.jpg"
     locatCoordLat:
     28.63523
     locatCoordLong:
     -81.436105
     title:
     "Metro Coffee House"
     web:
     "http://scontent-atl3-1.xx.fbcdn.net/v/t1.0-9/10..."
     -KrXTDi04CSAWRqIqjUu
     beaconName:
     "treasure_chest.png"
     category:
     "Business"
     imageName:
     "modInk.jpg"
     locatCoordLat:
     28.638891
     locatCoordLong:
     -81.440309
     title:
     "MOD Ink"
     web:
     "http://static1.squarespace.com/static/58a8d93ec..."
     -KrXTDi23h1iiGXyz95S
     beaconName:
     "sandwich-2.png"
     category:
     "Food"
     imageName:
     "newMoon.jpg"
     locatCoordLat:
     28.5704
     locatCoordLong:
     -81.344
     title:
     "The New Moon Cafe"
     web:
     "http://newmoondowntown.homestead.com/files/Quic..."
     -KrXTDi5tgViSqPiK61c
     beaconName:
     "citysquare.png"
     category:
     "Historic"
     imageName:
     "mellowMushroom.jpg"
     locatCoordLat:
     28.5563
     locatCoordLong:
     -81.3545
     title:
     "Mellow Mushroom Pizza"
     web:
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXTDi7188klCMw1dF-
     beaconName:
     "lighthouse-2.png"
     category:
     "Utility"
     imageName:
     "pizzaJoint.jpg"
     locatCoordLat:
     28.5412
     locatCoordLong:
     -81.3853
     title:
     "The Pizza Joint"
     web:
     "http://www.myherocard.com/wp-content/uploads/20..."
     -KrXTDi8xEdZwXvzSOuB
     beaconName:
     "treasure_chest.png"
     category:
     "Business"
     imageName:
     "stillWater.jpg"
     locatCoordLat:
     28.5455
     locatCoordLong:
     -81.3756
     title:
     "Stillwater Tap Room"
     web:
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXVBCgEUwz4P0df-eI
     beaconName:
     "sandwich-2.png"
     category:
     "Food"
     imageName:
     "craftVine.jpg"
     locatCoordLat:
     28.656671
     locatCoordLong:
     -81.47541
     title:
     "Craft & Vine"
     web:
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXVBCixT1IbFEqD8FV
     beaconName:
     "citysquare.png"
     category:
     "Historic"
     imageName:
     "humaniTree.jpg"
     locatCoordLat:
     28.602066
     locatCoordLong:
     -81.491256
     title:
     "Humanitree House"
     web:
     "http://augustalocallygrown.org/wp-content/uploa..."
     -KrXVBCkIcvzkoyyRAh-
     beaconName:
     "lighthouse-2.png"
     category:
     "Utility"
     imageName:
     "metro.jpg"
     locatCoordLat:
     28.66523
     locatCoordLong:
     -81.496105
     title:
     "Metro Coffee House"
     web:
     "http://scontent-atl3-1.xx.fbcdn.net/v/t1.0-9/10..."
     -KrXVBClGdMdNinsHJ_o
     beaconName:
     "treasure_chest.png"
     category:
     "Business"
     imageName:
     "modInk.jpg"
     locatCoordLat:
     28.633891
     locatCoordLong:
     -81.430309
     title:
     "MOD Ink"
     web:
     "http://static1.squarespace.com/static/58a8d93ec..."
     -KrXVBCmvGfaVG0O1J6y
     beaconName:
     "sandwich-2.png"
     category:
     "Food"
     imageName:
     "newMoon.jpg"
     locatCoordLat:
     28.5794
     locatCoordLong:
     -81.34
     title:
     "The New Moon Cafe"
     web:
     "http://newmoondowntown.homestead.com/files/Quic..."
     -KrXVBCmvGfaVG0O1J6z
     beaconName:
     "citysquare.png"
     category:
     "Historic"
     imageName:
     "mellowMushroom.jpg"
     locatCoordLat:
     28.5063
     locatCoordLong:
     -81.3945
     title:
     "Mellow Mushroom Pizza"
     web:
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXVBCn8UBCN-9lj2rd
     beaconName:
     "lighthouse-2.png"
     category:
     "Utility"
     imageName:
     "pizzaJoint.jpg"
     locatCoordLat:
     28.5012
     locatCoordLong:
     -81.2853
     title:
     "The Pizza Joint"
     web:
     "http://www.myherocard.com/wp-content/uploads/20..."
     -KrXVBCoA9lhz5DrJTJX
     beaconName:
     "treasure_chest.png"
     category:
     "Business"
     imageName:
     "stillWater.jpg"
     locatCoordLat:
     28.5055
     locatCoordLong:
     -81.4756
     title:
     "Stillwater Tap Room"
     web:
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXXZu7FHUQxQvohpNF
     beaconName:
     "citysquare.png"
     category:
     "Historic"
     imageName:
     "humaniTree.jpg"
     locatCoordLat:
     28.543112
     locatCoordLong: 
     -81.378265
     title: 
     "Humanitree House"
     web: 
     "http://augustalocallygrown.org/wp-content/uploa..."
     -KrXXZu8s_1S2xMHV1ML
     beaconName: 
     "lighthouse-2.png"
     category: 
     "Utility"
     imageName: 
     "metro.jpg"
     locatCoordLat: 
     28.54183
     locatCoordLong: 
     -81.378997
     title: 
     "Metro Coffee House"
     web: 
     "http://scontent-atl3-1.xx.fbcdn.net/v/t1.0-9/10..."
     -KrXXZu9oHNWIpW09djb
     beaconName: 
     "treasure_chest.png"
     category: 
     "Business"
     imageName: 
     "modInk.jpg"
     locatCoordLat: 
     28.542544
     locatCoordLong: 
     -81.377481
     title: 
     "MOD Ink"
     web: 
     "http://static1.squarespace.com/static/58a8d93ec..."
     -KrXXZuABynp9QRdrFr9
     beaconName: 
     "sandwich-2.png"
     category: 
     "Food"
     imageName: 
     "newMoon.jpg"
     locatCoordLat: 
     28.542179
     locatCoordLong: 
     -81.377763
     title: 
     "The New Moon Cafe"
     web: 
     "http://newmoondowntown.homestead.com/files/Quic..."
     -KrXXZuBrzC5NtXroZhJ
     beaconName: 
     "citysquare.png"
     category: 
     "Historic"
     imageName: 
     "mellowMushroom.jpg"
     locatCoordLat: 
     28.541736
     locatCoordLong: 
     -81.378042
     title: 
     "Mellow Mushroom Pizza"
     web: 
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."
     -KrXXZuCydnm7r2hsTtT
     beaconName: 
     "lighthouse-2.png"
     category: 
     "Utility"
     imageName: 
     "pizzaJoint.jpg"
     locatCoordLat: 
     28.542608
     locatCoordLong: 
     -81.378983
     title: 
     "The Pizza Joint"
     web: 
     "http://www.myherocard.com/wp-content/uploads/20..."
     -KrXXZuDFFS3GdRHl3Yv
     beaconName: 
     "treasure_chest.png"
     category: 
     "Business"
     imageName: 
     "stillWater.jpg"
     locatCoordLat: 
     28.542613
     locatCoordLong: 
     -81.378337
     title: 
     "Stillwater Tap Room"
     web: 
     "http://2kdda41a533r27gnow20hp6whvn.wpengine.net..."

     
     
     */

}
