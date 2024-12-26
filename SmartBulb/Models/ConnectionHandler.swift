import Foundation
import Network


class ConnectionHandler {
    let host:NWEndpoint.Host
    let port:NWEndpoint.Port
    //var queue:DispatchQueue
    var connection:NWConnection?=nil
    
    
    init(host:String, port:UInt16){
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port) ?? 0
        //self.queue = DispatchQueue(label: "com.smartbulb.netqueue")
        
        
    }
    
    
    func sendUDPCommand(message:String) async throws  ->Data{
        start()
        guard connection != nil else{
            throw NSError(domain: "ConnectionError", code: -1, userInfo: [NSLocalizedDescriptionKey:"There is no connection"])
        }
        return try await withCheckedThrowingContinuation {
            continuation in
            connection?.send(content: message.data(using: .utf8), completion: .contentProcessed{
                error in
                if let error = error{
                    continuation.resume(throwing: error)
                    
                }else{
                    self.connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024, completion: {
                        data, _, _, error in
                        if let error = error{
                            continuation.resume(throwing: error)
                        }else if let data = data{
                            continuation.resume(returning: data)
                            
                        }
                        
                    })
                    
                }
                
            })
            
        }
    }
    
    func start() {
        if connection == nil || connection?.state == .cancelled {
            self.connection = NWConnection(host: self.host, port: self.port, using: .udp)
            print("Avviando connessione a \(host):\(port)")
            self.connection?.start(queue: .main)
        } else {
            print("Connessione già attiva o in stato non valido")
        }
    }


    
    func stop(){
        connection?.cancel()
    }
    
    
}


enum Method: String{
    case set="setPilot"
    case get="getPilot"
    case system="getSystemConfig"
}
