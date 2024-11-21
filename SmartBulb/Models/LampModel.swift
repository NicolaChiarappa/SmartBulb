import Foundation


class LampModel{
    var isOn:Bool=false
    var brightness:Int=0
    var sceneId:Int=0
    let host:String
    let port:UInt16
    var connection:ConnectionHandler
    
    
    init(host:String, port:UInt16){
        self.host=host
        self.port=port
        self.connection=ConnectionHandler(host: host, port: port)
    }
    
    
    func sync() async {
        let request=GetRequest()
        print(request.toString())
        do{
            let response = try await connection.sendUDPCommand(message: request.toString() )
            print(String(data: response, encoding: .utf8) ?? "errore di decoding")
        }catch{
            
        }
        
    }

}
