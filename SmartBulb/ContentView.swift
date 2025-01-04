import SwiftUI

struct ContentView: View {
    let modes = ["Colors", "Scenes"]
    
    @State var lamp = LampViewModel(lamp: LampModel(name: "Desk Lamp", host: "192.168.1.3", port: 38899))
    @State var selectedMode = "Colors"
    @State var colore:Color = .black
    var body: some View {
        NavigationStack {
            
            ZStack {
                MainSection()
                HStack{
                    CustomSlider(lamp: $lamp)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                    .padding()
                
            }
            .navigationTitle(lamp.getName())
        }
    }
}



struct CustomSlider : View{
    let maxHeight: CGFloat = UIScreen.main.bounds.height*0.6
    let rectangleWidth: CGFloat = 110
    @State var width:CGFloat = 7
    @State var rectangleHeight: CGFloat = 0
    @State var fillPercentage = 0.0
    @State var overflow = false
    @State private var initialDragHeight: CGFloat = 0
    @Binding var lamp:LampViewModel
    
    var body : some View {
        
        
        
        ZStack() {
            HStack {
                Rectangle()
                    .fill(Color.init(uiColor: .systemGray))
                    .frame(width: rectangleWidth, height: maxHeight)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            HStack {
                Rectangle()
                    .fill(Color.init(uiColor: .white))
                    .frame(width:rectangleWidth, height: rectangleHeight)
                    .padding()
                    .animation(.linear(duration: 0.2), value: overflow)
                    .animation(.easeOut(duration: 0.4), value: rectangleHeight)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            
            HStack {
                Text(String(min(Int((rectangleHeight/maxHeight)*100),100)))
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                    .frame(width: width, height: maxHeight,  alignment: .center)
                    .opacity(width == 75 ? 1 : 0)
                
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding()
            
            
            
        }
        .frame(maxWidth: width, maxHeight: .infinity, alignment: .top)
        .background(.green)
        .mask {
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width:width, height: overflow ? maxHeight+10 : maxHeight)
                    .padding()
                    .animation(.linear(duration: 0.2), value: overflow)
                    .animation(.linear(duration: 0.2), value: width)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    
                    width=75
                    
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
                    overflow = newHeight > maxHeight+10
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
                    overflow=false
                    width=7
                    
                    
                })
        )
        .shadow(radius: 5)
        .onAppear{
            DispatchQueue.global().async {
                Task{
                    await self.lamp.sync()
                    DispatchQueue.main.async{
                        rectangleHeight=(UIScreen.main.bounds.height*0.6)*Double(self.lamp.brightness)/100
                        
                    }
                }
                
            }
            
        }
        
        
        
        
        
    }
}



#Preview {
    ContentView()
}

struct MainSection: View {
    var body: some View {
        TabView(){
            Tab("Colors", systemImage: "paintpalette.fill"){
                VStack{}
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
            }
            
            Tab("Scenes", systemImage: "lamp.desk.fill"){
                VStack{}
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
            }
        }
        
    }
}
