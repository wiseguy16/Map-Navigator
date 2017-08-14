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

}
