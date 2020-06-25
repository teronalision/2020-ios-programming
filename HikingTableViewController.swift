import UIKit

class HikingTableViewController: UIViewController, XMLParserDelegate, UITableViewDataSource {

    var data :[String] = []
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var date = NSMutableString()
    var xpos = NSMutableString()
    var ypos = NSMutableString()
    
    @IBOutlet weak var tbData: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        beginParsing()
        
    }

    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf: (URL(string:"http://api.vworld.kr/req/wfs?SERVICE=WFS&REQUEST=GetFeature&TYPENAME=lt_l_frstclimb&MAXFEATURES=\(count)&SRSNAME=EPSG:900913&OUTPUT=GML2&EXCEPTIONS=text/xml&KEY=0083062C-0616-33EE-B075-1232548B3042&DOMAIN=[DOMAIN]"))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "sop:lt_l_frstclimb")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            date = NSMutableString()
            date = ""
            xpos = NSMutableString()
            xpos = ""
            ypos = NSMutableString()
            ypos = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String){
        if element.isEqual(to: "sop:pmntn_nm"){
            title1.append(string)
        } else if element.isEqual(to: "sop:mntn_nm"){
            date.append(string)
        }else if element.isEqual(to: "sop:xpos"){
            xpos.append(string)
        }else if element.isEqual(to: "sop:ypos"){
            ypos.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if (elementName as NSString).isEqual(to: "sop:lt_l_frstclimb"){
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "sop:pmntn_nm" as NSString)
            }
            if !date.isEqual(nil){
                elements.setObject(date, forKey: "sop:mntn_nm" as NSString)
            }
            if !xpos.isEqual(nil) {
                elements.setObject(xpos, forKey: "sop:xpos" as NSString)
            }
            if !ypos.isEqual(nil){
                elements.setObject(ypos, forKey: "sop:ypos" as NSString)
            }
            posts.add(elements)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "sop:pmntn_nm") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "sop:mntn_nm") as! NSString as String
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "HikingDetail" {
        if let ViewController = segue.destination as? BikeDetailTableViewController {
                ViewController.data = data
        }
    }
}

}


