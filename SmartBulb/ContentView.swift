import SwiftUI

struct ContentView: View {
    @State var lamp = LampViewModel(lamp: LampModel(name: "Desk Lamp", host: "192.168.1.3", port: 38899))
    @State var selectedMode = "Colors"
    @State var colore:Color = .black
    @State var dimming:Bool = false
    var body: some View {
        NavigationStack {
            
            ZStack {
                MainView(lamp: $lamp)
                    .blur(radius: dimming ? 2 : 0)
                    .animation(.linear(duration: 0.3), value: dimming)
                    .padding(.trailing)
                HStack{
                    CustomSlider(lamp: $lamp, dimming: $dimming)
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
    let rectangleWidth: CGFloat = 75
    @State var width:CGFloat = 15
    @State var rectangleHeight: CGFloat = 0
    @State var fillPercentage = 0.0
    @State var overflow = false
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
            .animation(nil, value:width)
            
            
            
        }
        .frame(maxWidth: width, maxHeight: .infinity, alignment: .top)
        
       
        .mask {
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width:width, height: maxHeight)
                    .padding()
                    .animation(.default, value: overflow)
                    
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
           
            
            
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
                    width=15
                    dimming=false
                    
                    
                })
        )
        .animation(.easeIn, value:width)
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

struct MainView: View {
    @Binding var lamp:LampViewModel
    var body: some View {
        TabView(){
            Tab("Colors", systemImage: "paintpalette.fill"){
                ColorsView(lamp: $lamp)
            }
            
            Tab("Scenes", systemImage: "lamp.desk.fill"){
                ScenesView()
                    
            }
            
        }
        .tabViewStyle(.sidebarAdaptable)
        
        
        
    }
}

struct ScenesView: View {
    var body: some View {
        VStack{
            Text("Scenes")
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ColorsView: View {
    @Binding var lamp:LampViewModel
    @State var colors: [CGColor] = [
        CGColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1),
        CGColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1),
        CGColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1),
        CGColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1),
        CGColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1),
        CGColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1),
        CGColor(red: 0/255, green: 255/255, blue: 255/255, alpha: 1),
        CGColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1),
        CGColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1),
        CGColor(red: 165/255, green: 42/255, blue: 42/255, alpha: 1),
        CGColor(red: 75/255, green: 0/255, blue: 130/255, alpha: 1),
        CGColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1),
        CGColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1),
        CGColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1)
    ]

    let columns = [
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem()
    ]
    var body: some View {
        
        LazyVGrid(columns: columns){
            ForEach(colors, id: \.self){
                color in
                ColorCircle(lamp: $lamp, color: color)
                    .padding()
            }
            
            
        }
        .padding()
        Spacer()
            
        
       
    }
}

struct ColorCircle: View{
    @Binding var lamp:LampViewModel
    let color:CGColor
    
    var body: some View{
        VStack{
            
            Circle()
                .frame(width: 55, height: 55)
                .foregroundColor(Color(color))
            
        }
        .onTapGesture {
            lamp.setColor(r: Int(color.components![0]*255), g: Int(color.components![1]*255), b: Int(color.components![2]*255))
        }
        
    }
}

struct AddCircle:View{
    var body: some View{
        VStack{
            Image(systemName: "plus")
                .frame(width: 45, height: 45)
                .background(.gray)
                .clipShape(.circle)
            Text("Add color")
                .font(.caption)
        }
    }
}

#Preview {
    ContentView()
}
