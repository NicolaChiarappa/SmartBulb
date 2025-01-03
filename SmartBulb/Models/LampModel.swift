import Foundation


@Observable class LampModel{
    var name=String()
    var isOn:Bool=false
    var brightness:Int=0
    var sceneId:Int=0
    let host:String
    let port:UInt16
    var connection:ConnectionHandler
    
    
    init(name:String, host:String, port:UInt16){
        self.name=name
        self.host=host
        self.port=port
        self.connection=ConnectionHandler(host: host, port: port)
    }
    
    
    func sync() async {
        let request=GetRequest()
        do{
            print("avvio sync")
            let response = try await connection.sendUDPCommand(message: request.toString() )
            print(String(data: response, encoding: .utf8) ?? "errore di decoding")
            if let json = try JSONSerialization.jsonObject(with: response) as? [String:Any]{
                if let result = json["result"] as? [String:Any]{
                    self.isOn = result["state"] as? Bool ?? false
                    self.brightness = result["dimming"] as? Int ?? 0
                    
                }
                
            }
            
        }catch{
            
            print("errore sync \(error)")
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
        let request = SetRequest(dimming: value)
        
        do{
            _ =  try await connection.sendUDPCommand(message: request.toString())
            
        }
        catch{
            
            print("dimming error \(error)")
            
        }
        
        
        
    }
    
    

}
