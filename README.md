# Building an NFC Tag-Reader App

Read NFC tags in your app.
![IMG_8990](https://github.com/akshayPhulareNitor/NFCTagReader/assets/127845792/a16ca8d1-6203-46ee-aa0d-4ebd1c2e38ee)
![IMG_8991](https://github.com/akshayPhulareNitor/NFCTagReader/assets/127845792/ac8a3b29-1cda-454d-b50e-ab608cdf5abf)


## Overview

This sample code project shows how to use Core NFC in an app to read Near Field Communication (NFC) tags. To use this sample, download the project and build it using Xcode. Run the sample app on your iPhone. Tap the Scan button to start scanning for tags, then hold the phone near an NFC tag.

To read a tag, the sample app creates an NFC reader session and provides a delegate. The running reader session polls for NFC tags and calls the delegate when it finds tags passing the tag value to the delegate. The delegate then display the tag value so the user can view it.

## Configure the App to Detect NFC Tags

Begin building your tag reader by configuring your app to detect NFC tags. Turn on Near Field Communication Tag Reading under the Capabilities tab for the project's target (see [Add a capability to a target](https://help.apple.com/xcode/mac/current/#/dev88ff319e7)). This step:

- Adds the NFC tag-reading feature to the App ID.
- Adds the [NFC entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_nfc_readersession_formats) to the entitlements file.

Next, add the [`NFCReaderUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nfcreaderusagedescription) key as a string item to the `Info.plist` file. For the value, enter a string that describes the reason the app needs access to the device's NFC reader. If the app attempts to read a tag without providing this key and string, the app exits.

## Start a Reader Session

Create an [`NFCTagReaderSession`](https://developer.apple.com/documentation/corenfc/nfctagreadersession) object by calling the [`init?(pollingOption: NFCTagReaderSession.PollingOption, delegate: NFCTagReaderSessionDelegate, queue: DispatchQueue?)`] initializer method and passing in:

- The polling option that determine the type of tags that a reader session should detect during a polling sequence..
- The reader session delegate object.
- The dispatch queue to use when calling methods on the delegate.

After creating the reader session, give instructions to the user by setting the [`alertMessage`](https://developer.apple.com/documentation/corenfc/nfcreadersessionprotocol/2919987-alertmessage) property. For example, you might tell users, "Hold your iPhone near the item to learn more about it." The system displays this message to the user while the phone is scanning for NFC tags.
Finally, call [`begin()`](https://developer.apple.com/documentation/corenfc/nfcreadersessionprotocol/2874112-begin) to start the reader session. This enables radio-frequency polling on the phone, and the phone begins scanning for tags.

The sample app starts a reader session when the user taps the Scan button. The app configures the reader session to invalidate the session after reading the first tag. To read additional tags, the user taps the Scan button again.


## Adopt the Reader Session Delegate Protocol

The reader session requires a delegate object that conforms to the [`NFCTagReaderSessionDelegate`](https://developer.apple.com/documentation/corenfc/nfctagreadersessiondelegate) protocol. Adopting this protocol allows the delegate to receive notifications from the reader session when it:

- Reads an tag
- Becomes invalid due to ending the session or encountering an error

``` swift
class ViewController: UITableViewController, NFCTagReaderSessionDelegate {
```


## Read a Tag

Each time the reader session retrieves a tag number, the session sends the message to the delegate by calling the [`tagReaderSession(_ session: , didDetect tags:)`](https://developer.apple.com/documentation/corenfc/nfctagreadersessiondelegate/3282000-tagreadersession) method. This is the app's opportunity to do something useful with the data. For instance, the sample app stores the message so the user can view it later.

``` swift
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {

    }
```

## Handle an Invalid Reader Session

When a reader session ends, it calls the delegate method [`tagReaderSession(_ session: , didInvalidateWithErrotagReaderSession(_:didInvalidateWithError:)`](https://developer.apple.com/documentation/corenfc/nfctagreadersessiondelegate/3282001-tagreadersession) and passes in an error object that gives the reason for ending the session. 

In the sample app, the delegate prints an error when the reader session ends for any reason, or the user canceling the session. Also, you cannot reuse an invalidated reader session, so the sample app sets `self.session` to `nil`.

``` swift
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("\(error)")
    }
```

