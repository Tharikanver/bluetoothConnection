//
//  ViewController.swift
//  bluetoothConnection
//
//  Created by vignesh b on 15/02/24.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate,CBCentralManagerDelegate {
    @IBOutlet weak var myBtButton: UIButton!
    
    @IBOutlet weak var myTableView: UITableView!
    
    var peripherals:[CBPeripheral] = []
      var centralManager: CBCentralManager!
    
       let UUIDdevice = UUID(uuidString:"A6DCBC6F-0021-6BO9-10C1-BDA4S6CV8N68")
    
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.myTableView.isHidden = true
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
            centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
  
  
    @IBAction func btnScanClick( sender: Any) {
        print("scan Start")
        self.myTableView.isHidden = false
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) {
          self.centralManager.stopScan()
          print("Scanning stop")
        }
      }
    
       func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
      }
       
        func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "newTableViewCell", for: indexPath) as! newTableViewCell
        let peripheral = peripherals[indexPath.row]
          cell.myLabel.text = peripheral.name
        return cell
      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
//        private func tableView( tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let peripheral = peripherals[indexPath.row]
//        print("Details : ", peripheral)
//      }
        
        private func centralManager( central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripherals.append(peripheral)
        print("Discovered \(peripheral.name ?? "")")
        self.myTableView.reloadData()
      }
        
        func centralManagerDidUpdateState( _ central: CBCentralManager) {
            print("Central state update")
            if central.state != .poweredOn{
                print("Central is powered off")
            }else{
                print("Central scanning for",peripherals.description)
                centralManager.scanForPeripherals(withServices: nil, options: nil)
            }
        }
//        switch central.state {
//         case .unknown:
//          print("central.state is .unknown")
//         case .resetting:
//          print("central.state is .resetting")
//         case .unsupported:
//          print("central.state is .unsupported")
//         case .unauthorized:
//          print("central.state is .unauthorized")
//         case .poweredOff:
//          print("central.state is .poweredOff")
//         case .poweredOn:
//          print("central.state is .poweredOn")
//         default:
//          break
//        }
      
      func centralManager( central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to "+peripheral.name!)
      }

        private func centralManager( central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
      }
    }
