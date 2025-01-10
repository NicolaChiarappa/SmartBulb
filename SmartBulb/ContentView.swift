
import SwiftUI

struct ContentView:View {
    let contentViewModel=ContentViewModel()
    
    @State var isAdding:Bool=false
    
    
    @State var isDeleting:Bool=false
    
    
    
    let columns=[
        GridItem(alignment: .leading)
    ]
    
    var body: some View {
        
        NavigationStack {
            
            
            
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns) {
                        ForEach(contentViewModel.bulbs, id: \.self){
                            bulb in
                            BulbCard(bulb: bulb, contentViewModel:contentViewModel, isDeleting: $isDeleting)
                            
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .toolbar(content: {
                
                ToolbarItem(placement: .topBarLeading) {
                    
                    Button(action:{
                        isDeleting=true
                    }){
                        Label("Edit", systemImage:"")
                    }
                    .disabled(contentViewModel.bulbs.count<=0)
                    .foregroundColor(Color(uiColor: .black))
                    
                    
                }
                
                ToolbarItem {
                    
                        
                        Button(action: isDeleting ?
                               {isDeleting=false} :
                                {isAdding=true}
                        ){
                            if(isDeleting){
                                Text("Done")
                                    .bold()
                                    .foregroundColor(Color(uiColor: .black))
                            }
                            
                            else{
                                
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                                    
                                    
                            }
                        }
                        
                        
                    }
                
                
            })
            .background(
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .opacity(0.45)
                
            )
            .navigationTitle("Home")
            .sheet(isPresented: $isAdding) {
                AddBulbView(contentViewModel: contentViewModel)
                
                
                
            }
            .onAppear(){
                self.contentViewModel.loadLamps()
            }
            
        }
        
        
    }
    
}





#Preview {
    ContentView()
}

struct BulbCard: View {
    let bulb:LampViewModel
    let contentViewModel:ContentViewModel
    
    @Binding var isDeleting:Bool
    
    @State var clicked:Bool=true
    var body: some View {
        
        ZStack {
            
            
            NavigationLink(destination: LampView(lamp: bulb)) {
                ZStack {
                    
                    
                    
                    
                    
                    
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor( bulb.isSynced && bulb.isOn ? .primary :  .secondary)
                        .opacity(0.45)
                        .shadow(radius: 20)
                    HStack {
                        Image(systemName: "lightbulb.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor( bulb.isSynced && bulb.isOn ? .yellow :  .secondary)
                            .symbolEffect(.bounce.up.byLayer, value: clicked)
                            .onTapGesture {
                                clicked.toggle()
                                bulb.power(isOn: !bulb.isOn)
                            }
                        
                        VStack(alignment: .leading) {
                            Text(bulb.getName())
                                .font(.callout)
                                .bold()
                            
                            HStack(spacing: 5) {
                                
                                Text(bulb.brightness, format: .percent)
                                    .font(.caption)
                                    .frame(maxWidth: bulb.isSynced ? .infinity : .zero, alignment: .leading)
                                
                            }
                            
                            Text("Updating...")
                                .font(.caption)
                                .frame(maxWidth: !bulb.isSynced ? .infinity : .zero, alignment: .leading)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    
                    
                    
                    
                }
            }
            .foregroundColor(bulb.isSynced ? Color.primary : Color.secondary)
            .disabled(bulb.isSynced  ? false : true)
            .onAppear{
                DispatchQueue.global().async {
                    Task{
                        await self.bulb.sync()
                    }
                    
                }
                
            }
            VStack {
                Image(systemName: "minus")
                    .foregroundColor(.white)
                    .frame(maxWidth: 40, maxHeight: 40)
                    .background(Color(uiColor: .systemRed))
                    .clipShape(Circle())
                    .onTapGesture {
                        contentViewModel.deleteLamp(myLamp:self.bulb)
                    }
            }
            .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .topTrailing)
            .opacity(isDeleting ? 1 : 0)
        }
        .frame(maxWidth: UIScreen.main.bounds.width/2.3, maxHeight: 70, alignment: .leading)
    }
}



struct AddBulbView:View{
    
    let contentViewModel:ContentViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var newLampName:String=""
    @State var newLampHost:String=""
    
    
    
    var body: some View{
        NavigationView {
            Form{
                Section {
                    TextField("", text: $newLampName)
                } header: {
                    Text("Name")
                }
                
                Section {
                    TextField("", text: $newLampHost)
                        .keyboardType(.numbersAndPunctuation)
                } header: {
                    Text("Host")
                }
                
                
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Done"){
                        
                            
                            contentViewModel.bulbs.append(
                                LampViewModel(lamp: LampModel(name: newLampName, host: newLampHost))
                            )
                            
                            self.contentViewModel.saveData()
                        
                        dismiss()
                    }
                    .disabled(newLampName.isEmpty || newLampHost.isEmpty)
                    .bold()
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                    
                }
            }
        }
    }
}
