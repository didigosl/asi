//
//  SocketSingleton.swift
//  G-eatClient
//
//  Created by JS_Coder on 25/07/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation
import SocketIO

protocol GECTakeInCartSocketDelegate {
    func socketUpdateTakeInCartOperationView()
}
// Socket
let manager: SocketManager = SocketManager(socketURL: URL(string: "\(baseUrl)\(GECApis.socketUrl)")!, config: [.log(true), .compress])
class CartSocketSingleton {

    static let shared = CartSocketSingleton.init()
    // Properties
    var socketClient: SocketIOClient!
    var delegate: GECTakeInCartSocketDelegate?
    // Initialization
    private init() { }

    func cartSocketDisconnect() {
        socketClient.disconnect()
    }

    func cartSocketConnect() {
        self.socketClient = manager.defaultSocket
        socketClientEvent()
    }

    //MARK: 监听Socket 更新购物车
    private func socketClientEvent() {
        socketClient.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        socketClient.on("message_\(GECHomeViewModel.scanInfos?.tableGuid ?? "")") { (data, act) in
            guard let dataStr = data.first as? String else { return }
            if dataStr.count > 0{
                GECHomeViewModel.generatorTakeInCartJson(dataStr, completed: { (errorCode) in
                    self.delegate?.socketUpdateTakeInCartOperationView()
                })
            }else {
                GECHomeViewModel.totalDishesInCart = 0
                GECHomeViewModel.takeInCartModel = nil
                self.delegate?.socketUpdateTakeInCartOperationView()
            }
        }
        socketClient.connect()
    }
}
