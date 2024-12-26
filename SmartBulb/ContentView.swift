import SwiftUI

struct ContentView: View {
    @State var lamp = LampViewModel(lamp: LampModel(name: "Desk lamp", host: "192.168.1.3", port: 38899))
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Slider(lamp: $lamp)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(lamp.getName())
        }
    }
}




struct Slider : View{
    var maxHeight: CGFloat = 500
    @State var rectangleHeight: CGFloat = 0
    @State var fillPercentage = 0.0
    @State var overflow = false
    @State private var initialDragHeight: CGFloat = 0
    @Binding var lamp:LampViewModel
    
    var body : some View {
        ZStack {
            HStack {
                Rectangle()
                    .fill(Color.init(uiColor: .systemFill))
                    .frame(width: 90, height: 500)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            HStack {
                Rectangle()
                    .fill(Color.init(uiColor: .systemYellow))
                    .frame(width:90, height: rectangleHeight)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .mask {
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width:90, height: overflow ? 500 : 490)
                    .padding()
                    .animation(.bouncy(), value: overflow)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    
                    if (rectangleHeight == maxHeight){
                        rectangleHeight=rectangleHeight-10
                    }
                    
                    
                    
                    
                    // Se il drag è iniziato, memorizza l'altezza iniziale
                    if initialDragHeight == 0 {
                        initialDragHeight = rectangleHeight
                    }
                    
                    
                    
                    if (initialDragHeight-value.translation.height>491){
                        overflow=true
                    }else{
                        overflow=false
                    }
                    
                    // Calcola la variazione dell'altezza in base al movimento del drag
                    let newHeight = initialDragHeight - value.translation.height
                    
                    // Limita l'altezza tra 0 e il massimo
                    rectangleHeight = min(max(0,newHeight), maxHeight)
                }
                .onEnded({ value in
                    if(initialDragHeight-value.translation.height<10){
                        lamp.power(isOn: false)
                    }else{
                        Task{
                            lamp.power(isOn: true)
                            try await Task.sleep(nanoseconds: 1000)
                            lamp.setBrightness(dimming: Int(rectangleHeight/4.9) )
                        }
                    }
                    initialDragHeight = 0
                    overflow=false
                })
        )
    }
}



#Preview {
    ContentView()
}
