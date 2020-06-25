import UIKit
import Speech

var postss = NSMutableArray()

class BikeTableViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {


    var data = NSMutableArray()
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var date = NSMutableString()
    var xpos = NSMutableString()
    var ypos = NSMutableString()
    var jibun_addr = NSMutableString()
    var byc_cnt = NSMutableString()
    var pump_yn = NSMutableString()
    var org_tel = NSMutableString()
    
    var name = ""
    var iii = 0
    var url = "http://api.vworld.kr/req/wfs?SERVICE=WFS&REQUEST=GetFeature&TYPENAME=lt_p_bycracks&MAXFEATURES=\(count)&SRSNAME=EPSG:900913&OUTPUT=GML2&EXCEPTIONS=text/xml&KEY=0083062C-0616-33EE-B075-1232548B3042&DOMAIN=[DOMAIN]"
    
    @IBOutlet weak var tbData: UITableView!
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var voiceButton: UIButton!
    @IBAction func pickButoon(_ sender: Any){
        if let indexPath = tbData.indexPathForSelectedRow {
            name = (data.object(at: (indexPath.row)) as AnyObject).value(forKey: "sop:rak_nam") as! NSString as String
            pickerData.append(name)
            print(pickerData.count)
        }
        else {
            name = (data.object(at: iii) as AnyObject).value(forKey: "sop:rak_nam") as! NSString as String
            pickerData.append(name)
            print(pickerData.count)
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var startVoice = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ["All","서울","경기도","강원도","충청","경상","전라","제주"]
        searchController.searchBar.delegate = self
        tbData.tableFooterView = searchFooter
        
        // Do any additional setup after loading the view.
        beginParsing()
        postss = posts
        data = posts
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vs = sb.instantiateViewController(withIdentifier: "map") as! ViewController
        vs.reload()
        
        authorizeSR()
    }
    @IBAction func voiceC (_ sender: Any){
        if startVoice {
            if audioEngine.isRunning {
                audioEngine.stop()
                speechRecognitionRequest?.endAudio()
                startVoice = false
                voiceButton.setTitle("음성인식 시작", for: .normal)
            }
        }
        else{
            try! startSession()
            startVoice = true
            voiceButton.setTitle("음성인식 중지", for: .normal)
        }
    }
    func startSession() throws {
        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)
        
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = speechRecognitionRequest else
        {
            fatalError("실패")
        }
        
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) {Result, error in
            var finished = false
            if let result = Result {
                self.searchController.searchBar.text? = result.bestTranscription.formattedString
                finished = result.isFinal
                //print(result.bestTranscription.formattedString)
            }
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                self.voiceButton.isEnabled = true
            }
        }
        let recodingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recodingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in self.speechRecognitionRequest?.append(buffer)}
        audioEngine.prepare()
        try audioEngine.start()
    }
    func authorizeSR() {
        SFSpeechRecognizer.requestAuthorization{ authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.voiceButton.isEnabled = true
                    
                case .denied:
                    self.voiceButton.isEnabled = false
                    self.voiceButton.setTitle("거부", for: .disabled)
                case .restricted:
                    self.voiceButton.isEnabled = false
                    self.voiceButton.setTitle("거부", for: .disabled)
                case .notDetermined:
                    self.voiceButton.isEnabled = false
                    self.voiceButton.setTitle("거부", for: .disabled)
                
                @unknown default:
                    break
                }
            }
        }
    }

    func isFiltering() -> Bool {
        let searchf = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchf)
    }
    func searchBarIsEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func filterSearchText(_ searchText: String, scope: String = "All"){
        data = []
        for i in 0 ..< posts.count{
            let addr = (posts.object(at: i) as AnyObject).value(forKey: "sop:rak_addr") as! String
            let name = (posts.object(at: i) as AnyObject).value(forKey: "sop:rak_nam") as! String
            if searchBarIsEmpty() && scope == "All"{
                data = posts
                break
            }
            else if name.contains(searchText) || addr.contains(searchText){
                if (scope == "All" || addr.contains(scope)){
                    data.add(posts.object(at: i))
                }
            }
        }
        print(scope)
        
        tbData.reloadData()
    }
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf: (URL(string:url))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
        postss = posts
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "sop:lt_p_bycracks")
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
            jibun_addr = NSMutableString()
            byc_cnt = NSMutableString()
            pump_yn = NSMutableString()
            org_tel = NSMutableString()
            jibun_addr = ""
            byc_cnt = ""
            pump_yn = ""
            org_tel = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String){
        if element.isEqual(to: "sop:rak_nam"){
            title1.append(string)
        } else if element.isEqual(to: "sop:rak_addr"){
            date.append(string)
        }else if element.isEqual(to: "sop:xpos"){
            xpos.append(string)
        }else if element.isEqual(to: "sop:ypos"){
            ypos.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if (elementName as NSString).isEqual(to: "sop:lt_p_bycracks"){
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "sop:rak_nam" as NSString)
            }
            if !date.isEqual(nil){
                elements.setObject(date, forKey: "sop:rak_addr" as NSString)
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
        //print(data.count)
        if isFiltering(){
            searchFooter.setIsFilteringToShow(filteredItemCount: data.count, of: posts.count)
        }
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (data.object(at: indexPath.row) as AnyObject).value(forKey: "sop:rak_nam") as! NSString as String
        cell.detailTextLabel?.text = (data.object(at: indexPath.row) as AnyObject).value(forKey: "sop:rak_addr") as! NSString as String
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BikeDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tbData.indexPath(for: cell)
                name = (data.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "sop:rak_nam") as! NSString as String
                if let detailViewController = segue.destination as? BikeDetailTableViewController {
                    detailViewController.url = url
                    detailViewController.name = name
                }
                iii = indexPath!.row 
            }
        }
    }
}


extension BikeTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension BikeTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedSope: Int){
        filterSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedSope])
    }
}
