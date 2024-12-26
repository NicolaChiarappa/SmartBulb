
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
    
    
    
    
    
    func sync(){
        DispatchQueue.main.async{
            Task{
                await self.lampModel.sync()
            }
        }
    }
    
    func getState()-> Bool{
        return lampModel.isOn
    }
    
    func getName()->String{
        return lampModel.name
    }
    
    
    func power (isOn:Bool){
        DispatchQueue.main.async{
            Task{
                try await self.lampModel.setPower(state: isOn)
                self.lampModel.isOn.toggle()
            }
        }
    }
    
    func setBrightness(dimming:Int){
        DispatchQueue.main.async{
            Task{
                try await self.lampModel.setDimming(dimming)
            }
        }
        
    }
    
    
    
}
