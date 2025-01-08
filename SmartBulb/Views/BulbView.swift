import SwiftUI

struct BulbView: View {
    @State var lamp: LampViewModel
    @State var selectedMode = "Colors"
    @State var colore:Color = .black
    @State var dimming:Bool = false
    var body: some View {
            ZStack {
                MainView(lamp: $lamp, dimming: $dimming)
                    .animation(.linear(duration: 0.3), value: dimming)
                HStack{
                    CustomSlider(lamp: $lamp, dimming: $dimming)
                        
                        
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }
            .onAppear{
                DispatchQueue.global().async {
                    Task{
                        await self.lamp.sync()
                    }
                    
                }
                
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
                    .frame(width:rectangleWidth, height: rectangleHeight)
                    .padding(.horizontal)
                    .animation(.easeOut(duration: 0.4), value: rectangleHeight)
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: maxHeight, alignment: .trailing)
            
            HStack {
                Text(String(min(Int((rectangleHeight/maxHeight)*100),100)))
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                    .frame(width: width, height: maxHeight,  alignment: .center)
                    .opacity(width == 75 ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            .padding()
            .animation(nil, value:width)
            
            
            
        }
        .frame(maxWidth: width, maxHeight: .infinity, alignment: .top)
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
    @Binding var lamp:LampViewModel
    @Binding var dimming:Bool
    var body: some View {
        TabView(){
            
            
            Tab("Colors", systemImage: "paintpalette.fill"){
                ColorsView(dimming:$dimming, lamp: $lamp)
                    
            }
            
            Tab("Scenes", systemImage: "lamp.desk.fill"){
                ScenesView(dimming: $dimming)
                    
            }
            
        }
        .tabViewStyle(.automatic)
        
        
        
    }
}

struct ScenesView: View {
    let columns = [
        GridItem(),
        GridItem(),
        GridItem(),
    ]
    @Binding var dimming:Bool
    var body: some View {
        NavigationStack{
            ScrollView{
                
                LazyVGrid(columns: columns){
                    ForEach(0..<26){
                        _ in
                        Text("Sce")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .padding(.trailing)
                .padding(.trailing)
                .padding(.trailing)
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .blur(radius: dimming ? 2:0)
            .navigationTitle("Scenes")
        }
    }
}


struct ColorsView: View {
    @Binding var dimming:Bool
    @Binding var lamp:LampViewModel
    @State var colors: [CGColor] = [
        CGColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1),      // Rosso
        CGColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1),      // Verde
        CGColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1),      // Blu
        CGColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1),    // Giallo
        CGColor(red: 255/255, green: 0/255, blue: 255/255, alpha: 1),    // Magenta
        CGColor(red: 0/255, green: 255/255, blue: 255/255, alpha: 1),    // Ciano
        CGColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1),  // Grigio
        CGColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1),    // Arancione
        CGColor(red: 75/255, green: 0/255, blue: 130/255, alpha: 1),     // Indigo
        CGColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1),  // Rosa
        CGColor(red: 139/255, green: 69/255, blue: 19/255, alpha: 1),    // Marrone
        CGColor(red: 128/255, green: 0/255, blue: 0/255, alpha: 1),      // Rosso scuro
        CGColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1),      // Verde scuro
        CGColor(red: 0/255, green: 0/255, blue: 128/255, alpha: 1),      // Blu scuro
        CGColor(red: 255/255, green: 222/255, blue: 173/255, alpha: 1),  // Beige
        CGColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1),   // Acciaio
        CGColor(red: 240/255, green: 230/255, blue: 140/255, alpha: 1),  // Giallo chiaro
        CGColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1),    // Cremisi
        CGColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1),    // Viola
        CGColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1),    // Arancione scuro
        CGColor(red: 154/255, green: 205/255, blue: 50/255, alpha: 1),   // Verde oliva
        CGColor(red: 106/255, green: 90/255, blue: 205/255, alpha: 1),   // Viola medio
        CGColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1),  // Azzurro
        CGColor(red: 244/255, green: 164/255, blue: 96/255, alpha: 1),   // Sabbia
        CGColor(red: 255/255, green: 228/255, blue: 181/255, alpha: 1)   // Melone chiaro
    ]

    let columns = [
        GridItem(),
        GridItem(),
        GridItem(),
    ]
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 0){
                    ForEach(colors, id: \.self){
                        color in
                        ColorCircle(lamp: $lamp, color: color)
                            .padding()
                    }
                }
                .padding(.trailing)
                .padding(.trailing)
                .padding(.trailing)
            }
            .navigationTitle("Colors")
        }
    }
}

struct ColorCircle: View{
    @Binding var lamp:LampViewModel
    let color:CGColor
    let ray = CGFloat(70)
    
    var body: some View{
        VStack{
            
            RoundedRectangle(cornerRadius: 15)
                .frame(width: ray, height: ray)
                .foregroundColor(Color(color))
        }
        .onTapGesture {
            lamp.setColor(r: Int(color.components![0]*255), g: Int(color.components![1]*255), b: Int(color.components![2]*255))
        }
    }
}

