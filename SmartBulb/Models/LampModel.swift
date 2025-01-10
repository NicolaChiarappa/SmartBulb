import Foundation


@Observable class LampModel: @unchecked Sendable{
    var name=String()
    var isOn:Bool=false
    var brightness:Int=0
    var sceneId:Int=0
    let host:String
    let port:UInt16
    var connection:ConnectionHandler
    var synced: Bool = false
    
    init(name:String, host:String, port:UInt16 = 38899){
        self.name=name
        self.host=host
        self.port=port
        self.connection=ConnectionHandler(host: host, port: port)
    }
    
    
    func sync() async {
        let request=GetRequest()
        do{
            let response = try await connection.sendUDPCommand(message: request.toString() )
            if let json = try JSONSerialization.jsonObject(with: response) as? [String:Any]{
                if let result = json["result"] as? [String:Any]{
                    
                    DispatchQueue.main.async{
                        self.synced=true
                        self.isOn = result["state"] as? Bool ?? false
                        self.brightness = result["dimming"] as? Int ?? 0
                    }
                    
                }
                
            }
            
        }catch{
            
        }
        
    }
    
    
    func setPower(state:Bool) async throws{
        let request = SetRequest(state: state)
        let _ = try await connection.sendUDPCommand(message: request.toString())
    }
    
    
    func setColor(r:Int, g:Int, b:Int) async throws{
        let request = SetRequest(r: r, g: g, b: b)
        let _ = try await String(data:connection.sendUDPCommand(message: request.toString()),encoding: .utf8 )
        
    }
    
    
    func setWhite(temp:Int) async throws{
        let request = SetRequest(temp: temp)
        let _ = try await connection.sendUDPCommand(message: request.toString() )
        
        
    }
    
    func setDimming(_ value:Int) async throws{
        let request:SetRequest
        
        if (!self.isOn){
            request = SetRequest(state: true, dimming: value)
        }else{
            request = SetRequest(dimming: value)
        }
        
        do{
            
            
            if(value<1){
                try await self.setPower(state: false)
            }else{
               
                _ =  try await connection.sendUDPCommand(message: request.toString())
            }
            
            
        }
        catch{
            
            print("dimming error \(error)")
            
        }
        
        
        
    }
    
    func setScene(_ value:Int) async throws{
        let request = SetRequest(state: true, sceneId: value)
        _ = try await connection.sendUDPCommand(message: request.toString())
    }
    
    

}
