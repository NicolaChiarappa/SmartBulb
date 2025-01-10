//
//  ContentViewModel.swift
//  SmartBulb
//
//  Created by Nicola Chiarappa on 10/01/25.
//

import Foundation
import SwiftUI


@Observable class ContentViewModel{
    
    
     var bulbs = [LampViewModel]()
    
    @ObservationIgnored @AppStorage("lamps") private var lampsData:Data?
    
    func saveData(){
        if let encodedData=try? JSONEncoder().encode(self.bulbs){
            self.lampsData=encodedData
        }
    }
    
    func loadLamps() {
        if let savedData = self.lampsData,
               let decodedLamps = try? JSONDecoder().decode([LampViewModel].self, from: savedData) {
                self.bulbs = decodedLamps
            }
        }
    
    func deleteLamp(myLamp:LampViewModel){
        print("deleting")
        bulbs.removeAll(where: { lamp in
            lamp==myLamp
        })
        
        saveData()
    }
    
    
}
