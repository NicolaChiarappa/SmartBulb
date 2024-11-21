struct GetRequest{
    
    let method="getPilot"
    
    func toString()->String{
        return "{\"method\":\"\(method)\", \"params\":{}}"
    }
}
