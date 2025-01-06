
import Foundation

@Observable class LampViewModel{
    private var lampModel: LampModel
    var isOn: Bool {
        get {
            lampModel.isOn
        }
        set {
            
            power(isOn: newValue)
            
        }
    }
    
    
    var brightness: Int{
        get {
            lampModel.brightness
        }
        set{
            lampModel.brightness=newValue
        }
    }
    
    
    init(lamp: LampModel) {
        self.lampModel = lamp
        
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
    
    
    
}
