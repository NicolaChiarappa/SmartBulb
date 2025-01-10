
import Foundation
import SwiftUI

@Observable class LampViewModel:Hashable, Codable{
    private var lampModel: LampModel
    private enum CodingKeys: String, CodingKey {
            case name, host
        }
    
    init(lamp: LampModel) {
        self.lampModel = lamp
        self.newColor=CGColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
   
    required init(from decoder: any Decoder) throws {
        var name=String()
        var host=String()
        
        if let container = try? decoder.container(keyedBy: CodingKeys.self){
            
            name = try! container.decode(String.self, forKey: .name)
            host = try! container.decode(String.self, forKey: .host)
            
            
        }
        
        
        self.lampModel=LampModel(name: name, host: host)
       
        self.newColor=CGColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.lampModel.name, forKey: .name )
        try container.encode(self.lampModel.host, forKey: .host )
    }
    
    
    var isSynced: Bool{
        get{
            return lampModel.synced
        }
    }
    
    var isOn: Bool {
        get {
            lampModel.isOn
        }
        
        set {
            power(isOn: newValue)
        }
    }
    
   var brightness: Int
    {
        get {
            lampModel.brightness
        }
        set{
            lampModel.brightness=newValue
        }
    }
    
    
    
    var colorsList : [WhiteColor] = [
        WhiteColor(CGColor(red: 224/255, green: 243/255, blue: 255/255, alpha: 1), temp:6500),
        WhiteColor(CGColor(red: 236/255, green: 246/255, blue: 255/255, alpha: 1), temp: 5500),
        WhiteColor(CGColor(red: 255/255, green: 250/255, blue: 244/255, alpha: 1), temp: 4500),
        WhiteColor(CGColor(red: 255/255, green: 239/255, blue: 224/255, alpha: 1), temp: 3500),
        WhiteColor(CGColor(red: 255/255, green: 224/255, blue: 189/255, alpha: 1), temp: 2700),
        WhiteColor(CGColor(red: 255/255, green: 197/255, blue: 143/255, alpha: 1), temp: 2000)

    ]

    
    var newColor : CGColor {
        didSet{
            self.setColor(r: Int(newColor.components![0]*255), g: Int(newColor.components![1]*255), b: Int(newColor.components![2]*255))
        }
    }
    
    
    struct WhiteColor: Hashable{
        let color:CGColor
        let temp:Int
        
        init(_ color:CGColor, temp:Int){
            self.color = color
            self.temp = temp
        }
    }
    
    
    
    
    
    
    
    
    func hash(into hasher: inout Hasher){
        hasher.combine(self.lampModel.name)
        hasher.combine(self.lampModel.host)
    }
    
    
    
    
    
    
    func getState()-> Int{
        return lampModel.brightness
    }
    
    func getName()->String{
        return lampModel.name
    }
    
    
    func sync() async {
        await self.lampModel.sync()
    }
    
    
    func power (isOn:Bool){
        DispatchQueue.global().async{
            Task{
                try await self.lampModel.setPower(state: isOn)
                self.lampModel.isOn.toggle()
            }
        }
    }
    
    
    
    func setBrightness(dimming:Int){
        DispatchQueue.global().async{
            Task{
                try await self.lampModel.setDimming(dimming)
            }
        }
        
    }
    
    func setColor(r:Int, g:Int, b:Int){
        DispatchQueue.global().async{
            Task{
                try await self.lampModel.setColor(r: r, g: g, b: b)
            }
        }
    }
    
    
    func setScene(_ scene:Int){
        DispatchQueue.global().async{
            Task{
                try await self.lampModel.setScene(scene)
            }
        }
    }
    
    
    
    func setWhite(_ temp:Int){
        DispatchQueue.global().async{
            Task{
                try await self.lampModel.setWhite(temp: temp )
            }
        }
    }
    
    
    static func == (lhs: LampViewModel, rhs: LampViewModel) -> Bool {
        lhs.hashValue==rhs.hashValue
    }
    
    
}
