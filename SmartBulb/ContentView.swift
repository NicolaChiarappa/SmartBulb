import SwiftUI

struct ContentView: View {
    @State var lamp = LampViewModel(lamp: LampModel(name: "Desk lamp", host: "192.168.1.3", port: 38899))
    let modes = ["Colors", "Scenes"]
    @State var selectedMode = "Colors"
    @State var colore:Color = .black
    var body: some View {
        NavigationStack {
            VStack (alignment: .trailing) {
                
                
                Picker(selection: $selectedMode, label: Text("Mode")){
                    
                    
                    ForEach(modes, id: \.self){ mode in
                        Text(mode)
                        
                        
                    }
                    
                }
                .font(.largeTitle)
                .pickerStyle(.segmented)
                
                
                
                
                
                Slider(lamp: $lamp)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(lamp.getName())
            .padding()
        }
    }
}




struct Slider : View{
    let maxHeight: CGFloat = 490
    let rectangleWidth: CGFloat = 110
    
    @State var width:CGFloat = 7
    @State var rectangleHeight: CGFloat = 280
    @State var fillPercentage = 0.0
    @State var overflow = false
    @State private var initialDragHeight: CGFloat = 0
    @Binding var lamp:LampViewModel
    
    var body : some View {
        
        VStack (alignment: .trailing){
            
            
            
            
            
            
            
            ZStack {
                HStack {
                    Rectangle()
                        .fill(Color.init(uiColor: .systemGray))
                        .frame(width: rectangleWidth, height: 500)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                HStack {
                    Rectangle()
                        .fill(Color.init(uiColor: .white))
                        .frame(width:rectangleWidth, height: rectangleHeight)
                        .padding()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
                HStack {
                    Text(String(min(Int(rectangleHeight/4.9),100).formatted(.percent)))
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: rectangleWidth, alignment: .center)
                        
                        
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
               
                    
            }
            
            
            
            .frame(maxWidth: rectangleWidth, maxHeight: .infinity, alignment: .bottomTrailing)
            
            .mask {
                HStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width:width, height: overflow ? 500 : 490)
                        .padding()
                        .animation(.linear(duration: 0.2), value: overflow)
                        .animation(.linear(duration: 0.2), value: width)
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
            }
            .shadow(radius: 5)
            
            
            
            
            
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
                        rectangleHeight = min(max(0,newHeight), maxHeight+10)
                        
                        if(rectangleHeight<10){
                            print("spengo")
                            lamp.power(isOn: false)
                        
                        }else{
                            Task{
                                if(lamp.getState()==false){
                                    lamp.power(isOn: true)
                                }
                                
                                try await Task.sleep(nanoseconds: 1000)
                                lamp.setBrightness(dimming: Int(rectangleHeight/4.9) )

                            }
                        }
                        
                        
                        overflow = newHeight > maxHeight
                    }
                    .onEnded({ value in
                        
                        initialDragHeight = 0
                        overflow=false
                        width=7
                    })
            )
            //.background(.green)
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: 600, alignment: .bottomTrailing)
        
        
        
        
    }
    
}



#Preview {
    ContentView()
}
