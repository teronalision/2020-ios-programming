import UIKit

class BikeDetailTableViewController: UITableViewController, XMLParserDelegate {
    @IBOutlet var detailTableView: UITableView!
    
    
    var url : String?
    var name : String?
    var parser = XMLParser()
    
    let postname : [String] = ["이름","도로주소","지번주소","자전거보관대수","공기주입기","관리기관연락처"]
    var data :[String] = ["","","","","",""]
    var element = NSString()
    var rak_nam = NSMutableString()
    var rak_addr = NSMutableString()
    var jibun_addr = NSMutableString()
    var byc_cnt = NSMutableString()
    var pump_yn = NSMutableString()
    var org_tel = NSMutableString()

    
    func beginParsing(){
        data = ["","","","","",""]
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        detailTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "sop:lt_p_bycracks")
        {
            //data = ["","","","","",""]
            rak_nam = NSMutableString()
            rak_addr = NSMutableString()
            jibun_addr = NSMutableString()
            byc_cnt = NSMutableString()
            pump_yn = NSMutableString()
            org_tel = NSMutableString()
            rak_nam = ""
            rak_addr = ""
            jibun_addr = ""
            byc_cnt = ""
            pump_yn = ""
            org_tel = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String){
        if element.isEqual(to: "sop:rak_nam"){
            rak_nam.append(string)
        } else if element.isEqual(to: "sop:rak_addr"){
            rak_addr.append(string)
        } else if element.isEqual(to: "sop:jibun_addr"){
            jibun_addr.append(string)
        } else if element.isEqual(to: "sop:byc_cnt"){
            byc_cnt.append(string)
        }else if element.isEqual(to: "sop:pump_yn"){
            pump_yn.append(string)
        } else if element.isEqual(to: "sop:org_tel"){
            org_tel.append(string)
        }
        
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if (elementName as NSString).isEqual(to: "sop:lt_p_bycracks") && (name! == rak_nam as String){
            if !rak_nam.isEqual(nil) {
                data[0] = rak_nam as String
            }
            if !rak_addr.isEqual(nil){
                data[1] = rak_addr as String
            }
            if !jibun_addr.isEqual(nil){
                data[2] = jibun_addr as String
            }
            if !byc_cnt.isEqual(nil){
                data[3] = byc_cnt as String
            }
            if !pump_yn.isEqual(nil){
                data[4] = pump_yn as String
            }
            if !org_tel.isEqual(nil){
                data[5] = org_tel as String
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginParsing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 6
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DCell", for: indexPath)

        cell.textLabel?.text = postname[indexPath.row]
        cell.detailTextLabel?.text = data[indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
