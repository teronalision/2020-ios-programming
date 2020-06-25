
import UIKit
import SwiftUI

class ViewController_W: UIViewController, XMLParserDelegate {
    
    var parser = XMLParser()
    var elements = NSMutableDictionary()
    var element = NSString()
    var maxc : [Int] = []
    var minc : [Int] = []
    var wf : [String] = []
    
    @IBOutlet weak var mview : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let stars = StardustView(frame: CGRect(x: 100, y: 100, width: 10, height: 10))
        mview.addSubview(stars)
        
        print("start")
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {stars.center = CGPoint(x: 500, y: 200)}, completion: {(Value:Bool) in stars.removeFromSuperview()})
    }
    @IBSegueAction func embedSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        let day = "202006250600"
        let url = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?serviceKey=e20GlP6AHkpkkdAr0AYT50r6zfv%2Fgj8KNbomL7RzhiSCSxpFb0vhZgYU7DADHoto16Zxg7xK01%2BCd69yoAssag%3D%3D&pageNo=1&numOfRows=10&dataType=XML&regId=11B10101&tmFc=" + day
        let url2 = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst?serviceKey=e20GlP6AHkpkkdAr0AYT50r6zfv%2Fgj8KNbomL7RzhiSCSxpFb0vhZgYU7DADHoto16Zxg7xK01%2BCd69yoAssag%3D%3D&pageNo=1&numOfRows=10&dataType=XML&regId=11B00000&tmFc=" + day

        beginParsing(url: url)
        beginParsing(url: url2)
        return UIHostingController(coder: coder, rootView: Weather(max: maxc, min: minc, wf: wf))
    }
    
    func beginParsing(url:String){
        
        parser = XMLParser(contentsOf: (URL(string: url))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String){
        for idx in 3 ..< 11{
            if element.isEqual(to: "taMax" + String(idx)){
                maxc.append(Int(string)!)
            } else if element.isEqual(to: "taMin" + String(idx)){
                minc.append(Int(string)!)
            } else if element.contains("wf" + String(idx)) && !element.contains("Pm"){
                wf.append(string)
            }
        }
        
    }
    
}


struct WeatherViewController_Previews: PreviewProvider {
    static var previews: some View {
        Weather(max: [21,22],min: [13,10], wf: ["맑음","흐림"])
    }
}
