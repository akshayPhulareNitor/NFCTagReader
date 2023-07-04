//
//  ViewController.swift
//  NFCReader
//
//  Created by Akshay Phulare on 04/04/23.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {

    @IBOutlet weak var lblTag: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func onScanClick(_ sender: Any) {
        
        // 1
        let session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)

        // 2
        session!.alertMessage = "Hold your device near a tag to scan it."

        // 3
        session!.begin()
    }
}



extension ViewController: NFCTagReaderSessionDelegate {

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("tagReaderSessionDidBecomeActive")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("Detected tags with \(tags.count) messages")

        print(tags[0])
        
        DispatchQueue.main.async {
            self.lblTag.text = "\(tags[0])"
        }
        session.alertMessage = "\(tags[0])"
        session.invalidate()

    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("\(error)")
    }
}
