//
//  IntentHandler.swift
//  AddFoodIntent
//
//  Created by Vishwas on 16/11/18.
//  Copyright © 2018 apollo INC. All rights reserved.
//

import Intents
import Foundation

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"


class IntentHandler: INExtension,AddFoodIntentHandling{
    func handle(intent: AddFoodIntent, completion: @escaping (AddFoodIntentResponse) -> Void) {
        
    }
    
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        guard intent is AddFoodIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        return AddFoodIntentHandler()
    }
    
    // MARK: - INSendMessageIntentHandling
    
  
    
    // Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
    
    // MARK: - INSearchForMessagesIntentHandling
    
 
    
    // MARK: - INSetMessageAttributeIntentHandling
 
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////function to add the order
    
   
}
