import Foundation
import Network


class ConnectionHandler{
    let host:NWEndpoint.Host
    let port:NWEndpoint.Port
    var connection:NWConnection?=nil
    
    init(host:String, port:UInt16){
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port) ?? 0
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
    
    func start(){
        print("Connessione started")
        connection = NWConnection(host: self.host, port: self.port, using: .udp)
        connection?.start(queue: .global())
        
    }
    
    func stop(){
        connection?.cancel()
    }
    
    
}
