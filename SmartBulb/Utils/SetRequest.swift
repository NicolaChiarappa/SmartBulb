struct SetRequest{
    
    private let method: Method = .set
    let params:Params
    
    
    //set power
    init(state:Bool){
        params=Params(state: state, dimming: nil, sceneId: nil, r: nil, g: nil, b: nil, temp: nil)
    }
    
    
    //setDimming
    init(dimming:Int){
        params=Params(state: nil, dimming: dimming, sceneId: nil, r: nil, g: nil, b: nil, temp: nil)
    }
    
    //setDimming and setPower
    init(state:Bool, dimming:Int){
        params=Params(state: state, dimming: dimming, sceneId: nil, r: nil, g: nil, b: nil, temp: nil)
    }
    
    
    //set sceneId
    init(state:Bool=false, dimming:Int=0,sceneId:Int ){
        params=Params(state:state, dimming:dimming, sceneId: sceneId, r: nil, g: nil, b: nil, temp: nil)
    }
    
    //set white
    init(temp:Int ){
        params=Params(state:nil, dimming:nil, sceneId: nil, r: nil, g: nil, b: nil, temp: temp)
    }
    
    //set rgb
    init(state:Bool?=nil, dimming:Int?=nil, r:Int, g:Int, b:Int ){
        params=Params(state:state, dimming:dimming, sceneId: nil, r: r, g: g, b: b, temp: nil)
    }
    
    struct Params{
        let state:Bool?
        let dimming:Int?
        let sceneId:Int?
        let r:Int?
        let g:Int?
        let b:Int?
        let temp:Int?
        
        init(state: Bool?, dimming: Int?, sceneId: Int?, r: Int?, g: Int?, b: Int?, temp: Int?) {
            self.state = state
            self.dimming = dimming
            self.sceneId = sceneId
            self.r = r.map { min($0, 255) }
            self.g = g.map { min($0, 255) }
            self.b = b.map { min($0, 255) }
            self.temp = temp.map { max(2200, min($0, 6500)) }
        }
    }
    
    
    func toString() -> String {
        var paramsString = "{"
        
        if let state = params.state {
            paramsString += "\"state\":\(state),"
        }
        if let dimming = params.dimming {
            paramsString += "\"dimming\":\(dimming),"
        }
        if let sceneId = params.sceneId {
            paramsString += "\"sceneId\":\(sceneId),"
        }
        if let r = params.r {
            paramsString += "\"r\":\(r),"
        }
        if let g = params.g {
            paramsString += "\"g\":\(g),"
        }
        if let b = params.b {
            paramsString += "\"b\":\(b),"
        }
        if let temp = params.temp {
            paramsString += "\"temp\":\(temp),"
        }
        
        // Rimuove l'ultima virgola, se presente
        if paramsString.last == "," {
            paramsString.removeLast()
        }
        
        paramsString += "}"
        
        return "{\"method\":\"\(method.rawValue)\", \"params\":\(paramsString)}"
    }

}
