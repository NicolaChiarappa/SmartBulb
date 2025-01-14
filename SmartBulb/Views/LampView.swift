import SwiftUI

struct LampView: View {
    var modes = ["Colors", "Scenes"]
    @State var lamp: LampViewModel
    @State var selectedMode = "Colors"
    @State var colore:Color = .black
    @State var dimming:Bool = false
    @State var isNewColor:Bool = false
    @State var newColor:CGColor=CGColor(red: 0, green: 0, blue: 0, alpha: 0)
    var body: some View {
        ZStack {
            NavigationStack{
                
                
                MainView(lamp: $lamp, dimming: $dimming)
                    .animation(.linear(duration: 0.3), value: dimming)
                    .navigationTitle(lamp.getName())
            }
            
            
            HStack(alignment: .bottom){
                CustomSlider(lamp: $lamp, dimming: $dimming)
                    .frame(height: UIScreen.main.bounds.height*0.5)
                    
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            .padding()
            
        }
        
    }
}

struct CustomSlider : View{
    let maxHeight: CGFloat = UIScreen.main.bounds.height*0.5
    let rectangleWidth: CGFloat = 75
    @State var width:CGFloat = 25
    @State var rectangleHeight: CGFloat = 0
    @State private var initialDragHeight: CGFloat = 0
    @Binding var lamp:LampViewModel
    @Binding var dimming:Bool
    var body : some View {
        
        
        
        ZStack() {
            HStack {
                Rectangle()
                    .fill(Color.init(uiColor: .systemGray))
                    .frame(width: rectangleWidth, height: maxHeight)
                    .padding()
                    .opacity(0.35)
                
            }
            .frame(maxWidth: .infinity, maxHeight: maxHeight, alignment: .trailing)
            
            
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.init(uiColor: .white))
                    .opacity(0.70)
                    .frame(width:rectangleWidth, height: rectangleHeight)
                    .padding(.horizontal)
                    .animation(.easeOut(duration: 0.4), value: rectangleHeight)
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: maxHeight, alignment: .trailing)
            
            HStack {
                Text(String(min(Int((rectangleHeight/maxHeight)*100),100)))
                    .font(.title3)
                    .bold()
                    .frame(width: width, height: maxHeight,  alignment: .center)
                    .opacity(width == 75 ? 1 : 0)
                    .shadow(radius: 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            .padding()
            .animation(nil, value:width)
            
            
            
        }
        
        .frame(maxWidth: width, maxHeight: .infinity)
        
        
        
        .mask {
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width:width, height: maxHeight-10)
                    .padding()
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: maxHeight, alignment: .trailing)
            
            
            
        }
        .contentShape(
            RoundedRectangle(cornerRadius: 15)
            
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    
                    width=75
                    dimming=true
                    
                    if (rectangleHeight == maxHeight){
                        rectangleHeight=rectangleHeight-10
                    }
                    
                    
                    
                    
                    // Se il drag è iniziato, memorizza l'altezza iniziale
                    if initialDragHeight == 0 {
                        initialDragHeight = rectangleHeight
                    }
                    
                    
                    
                    
                    
                    // Calcola la variazione dell'altezza in base al movimento del drag
                    let newHeight = initialDragHeight - value.translation.height
                    
                    // Limita l'altezza tra 0 e il massimo
                    rectangleHeight = min(max(0,newHeight), maxHeight)
                    lamp.setBrightness(dimming: Int((rectangleHeight/maxHeight)*100))
                    
                }
                .onEnded({ value in
                    //                    lamp.setBrightness(dimming: Int((rectangleHeight/maxHeight)*100))
                    DispatchQueue.global().async{
                        Task{
                            
                            let timer = 0.5
                            try? await Task.sleep(nanoseconds: UInt64(timer * 1_000_000_000))
                            await lamp.sync()
                        }
                        
                        
                    }
                    
                    initialDragHeight = 0
                    width=25
                    dimming=false
                    
                    
                })
        )
        .animation(.easeIn(duration: 0.3), value:width)
        .shadow(radius: 5)
        .onAppear{
            DispatchQueue.main.async {
                Task{
                    let timer = 0.5
                    try await Task.sleep(nanoseconds: UInt64(timer * 1_000_000_000))
                    self.rectangleHeight =  ((UIScreen.main.bounds.height * 0.5) * CGFloat(lamp.brightness) / 100)
                }
                
            }
            
        }
    }
}

struct MainView: View {
    let columns = [
        GridItem( alignment: .leading),
        GridItem( alignment: .leading),
        GridItem( alignment: .leading),
        
    ]
    
    
    @Binding var lamp:LampViewModel
    @Binding var dimming:Bool
    @State var color:CGColor=CGColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    var body: some View {
        ScrollView{
            VStack{
                VStack(alignment: .leading, spacing: 0) {
                    Text("Colors")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.secondary)
                    ScrollView(.horizontal) {
                        HStack{
                            ColorPicker(selection: $lamp.newColor, supportsOpacity: false, label: {})
                                .scaleEffect(1.6)
                                .padding(.trailing)
                                .frame(height: 45)
                                
                                
                                
                            
                            
                            ForEach(lamp.colorsList, id: \.self){
                                color in
                                ColorCircle(lamp: $lamp, color: color.color, temp:color.temp)
                                    .padding(.vertical)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    .scrollIndicators(.hidden)
                    
                }
                .padding()
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Scenes")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.secondary)
                    LazyVGrid(columns: columns)
                    {
                        ForEach(1..<25, id:\.self){
                            number in
                            
                            VStack(spacing: 0) {
                                Text("Scene")
                                    .font(.system(.caption, design: .rounded))
                                    .bold()
                                Text(String(number))
                                    .font(.system(.title3, design: .rounded))
                                
                                
                            }
                            .padding()
                            .background(Color(uiColor: .lightGray))
                            
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                            .onTapGesture {
                                self.lamp.setScene(number)
                            }
                            
                        }
                    }
                    .padding(.vertical)
                    
                }
                .padding()
            }
            
        }
        
    }
    
    
    
}




struct ColorCircle: View{
    @Binding var lamp:LampViewModel
    let color:CGColor
    let ray = CGFloat(45)
    let temp:Int
    
    var body: some View{
        VStack{
            
            Circle()
                .frame(width: ray, height: ray)
                .foregroundColor(Color(color))
        }
        .onTapGesture {
            lamp.setWhite(temp)
        }
    }
}



#Preview{
    LampView(lamp:LampViewModel(lamp: LampModel(name: "Desk Lamp", host: "192.168.1.3")))
}
