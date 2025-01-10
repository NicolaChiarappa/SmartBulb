import Foundation
import Network

class ConnectionHandler: @unchecked Sendable{
    let host:NWEndpoint.Host
    let port:NWEndpoint.Port
    var connection:NWConnection?=nil
    private var response:Data?
    private var countRequests:Int
    private var completed:Bool=true
    private var lastRequest:String?=nil
    private var timer=Timer()
    
    
    
    init(host:String, port:UInt16){
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port) ?? 0
        self.countRequests = 0
        self.timer=Timer(timeInterval: 1, repeats: true) { _ in
            
            if(self.lastRequest != nil){
                DispatchQueue.global().async {
                    
                    Task{
                        
                        _ = try await self.sendSingleUDPCommand(message: self.lastRequest ?? "")
                    }
                }
            }
        }
    }
    
    
    private func sendSingleUDPCommand(message:String) async throws  -> Data{
        
        guard self.completed else {
            throw NSError(domain: "ConnectionError", code: -1, userInfo: [NSLocalizedDescriptionKey:"Too many requests"])
        }
        
        self.start()
        self.completed=false
        
        guard self.connection != nil else{
            throw NSError(domain: "ConnectionError", code: -1, userInfo: [NSLocalizedDescriptionKey:"There is no connection"])
        }
        
        print("riprovo")
        
        return try await withCheckedThrowingContinuation {
            continuation in
            
            defer{
                self.completed=true
            }
            
            self.connection?.send(content: message.data(using: .utf8), completion: .contentProcessed{
                error in
                
                if let error = error{
                    continuation.resume(throwing: error)
                    return
                }
                
                
                self.connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024, completion: {
                    data, _, _, error in
                    
                    if let error = error{
                        continuation.resume(throwing: error)
                        return
                    }else if let data = data{
                        continuation.resume(returning: data)
                        return
                    }else {
                        continuation.resume(throwing: NSError(domain: "ConnectionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                        return
                    }
                    
                })
            })
        }
    }
    
    
    
    
    
    private func start() {
        if(connection != nil){ self.stop()}
        if (connection == nil || connection?.state != .ready) {
            self.connection = NWConnection(host: self.host, port: self.port, using: .udp)
            self.connection?.start(queue: DispatchQueue.global())
        } else {
            print("Connessione già attiva o in stato non valido", connection?.state ?? "")
        }
    }
    
    
    
    private func stop(){
        connection?.cancel()
        connection = nil
    }
    
    
    
    //this logic ensures that last valid message will be sent
    func sendUDPCommand(message:String) async throws -> Data {
        var response:Data
        self.timer.invalidate()
        self.timer.fire()
        do{
            response = try await sendSingleUDPCommand(message: message)
            self.lastRequest=nil
        }
        catch{
            response=Data()
            lastRequest=message
        }
        
        return response
    }
    
    
}







enum Method: String{
    case set="setPilot"
    case get="getPilot"
    case system="getSystemConfig"
}
