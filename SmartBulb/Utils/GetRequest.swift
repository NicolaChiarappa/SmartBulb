///
///
/// - Tag: 
///

struct GetRequest{
    
    let method: Method = .get
    
    func toString()->String{
        return "{\"method\":\"\(method.rawValue)\", \"params\":{}}"
    }
}
