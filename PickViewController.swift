var pickerData:[String] = ["경포고등학교 내"]


import UIKit

class PickViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var name = ""
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        name = pickerData[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let url = "http://api.vworld.kr/req/wfs?SERVICE=WFS&REQUEST=GetFeature&TYPENAME=lt_p_bycracks&MAXFEATURES=\(count)&SRSNAME=EPSG:900913&OUTPUT=GML2&EXCEPTIONS=text/xml&KEY=0083062C-0616-33EE-B075-1232548B3042&DOMAIN=[DOMAIN]"

                if let detailViewController = segue.destination as? BikeDetailTableViewController {
                    detailViewController.url = url
                    detailViewController.name = name
                }
        pickerView.reloadAllComponents()
    }
}

