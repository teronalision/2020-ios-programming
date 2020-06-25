
import SwiftUI

struct Weather: View {
    var maxc :[Int] = []
    var minc :[Int] = []
    var wf :[String] = []
    
    @State var anim = false
    
    init(max: [Int], min:[Int], wf:[String]) {
        self.maxc = max
        self.minc = min
        self.wf = wf
    }
    func che(wf: String) -> String{
        switch wf {
        case "구름많음":
            return "cloud.fill"
        case "맑음":
            return "sun.min"
        case "흐리고 비":
            return "cloud.rain"
        case "흐림":
            return "cloud"
        default:
            return ""
        }
    }
    
    var body: some View {
        VStack{
            Button(action: {
                self.anim.toggle()
            }){
                Text("  최저기온 표시  ")
            }
            HStack{
                ForEach(0..<wf.count){ day in
                    VStack{
                        Image(systemName: self.che(wf: self.wf[day]))
                            
                        Text(self.wf[day])
                    }
                }
            }
        
        ZStack{
        ForEach(0..<8){ mark in
            Rectangle()
                .fill(Color.gray)
                .offset(y: (CGFloat(mark - 1 ) * 13 * 5) - 30)
                .frame(height: 1.0)
                
        }
        HStack{
            ForEach(0..<maxc.count){ day in
                VStack{
                    Spacer()
                    HStack{
                        ZStack{
                            VStack{
                                Spacer()
                            Text("\(self.maxc[day])")
                                .offset(y: 35)
                                .zIndex(1)
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 20, height: CGFloat(Double(self.maxc[day]) * 13.0))
                                
                            }
                            
                            VStack{
                                Spacer()
                                if !self.anim{
                                    Text("\(self.minc[day])")
                                        .offset(y: 35)
                                        .zIndex(1)
                                    .animation(.easeInOut)
                                }
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: self.anim ? 0 : CGFloat(Double(self.minc[day]) * 13.0))
                                .animation(.easeInOut)
                            }
                        }
                    }
                    Text("\(day+1)일 후")
                        .frame(height: 20)
                }
            }
        }
        }
    }
    }
}

struct Weather_Previews: PreviewProvider {
    static var previews: some View {
        Weather(max: [21,22],min: [13,10], wf: ["맑음", "흐리고 비"])
    }
}
