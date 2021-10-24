//
//  WatchlistWebSocketController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 22/10/2021.
//

import Foundation

class WatchlistWebSocketController: NSObject {
    private var session: URLSession!
    private var socket: URLSessionWebSocketTask!
    
    override init() {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        connect()
    }
    
    private func connect() {
        guard let url = URL(string: "wss://streamer.finance.yahoo.com") else { return }
        socket = session.webSocketTask(with: url)
        socket.resume()
    }
    
    func send(symbols: [String]) {
        let params = ["subscribe": symbols]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            socket.send(.string(jsonString)) { error in
                if let error = error { print(error.localizedDescription) }
            }
        } catch { print(error.localizedDescription) }
    }
    
    private func listen() {
        socket.receive { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self.handle(data)
                case .string(let str):
                    guard let data = Data(base64Encoded: str, options: .ignoreUnknownCharacters) else { return }
                    self.handle(data)
                @unknown default: break
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.listen()
        }
    }
    
    private func handle(_ data: Data) {
        do {
            let quote = try YahooFinanceRealTimeQuote(serializedData: data)
            print(quote)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension WatchlistWebSocketController: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
        send(symbols: ["BTC-USD","ETH-USD","BNB-USD","ADA-USD","USDT-USD","SOL1-USD","HEX-USD"])
        listen()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
}
