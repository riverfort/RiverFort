//
//  YahooFinanceQuoteWebSocket.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 22/10/2021.
//

import Foundation

class YahooFinanceQuoteWebSocket: NSObject {
    private var session: URLSession!
    private var webSocketTask: URLSessionWebSocketTask!
    
    override init() {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        connect()
    }
}

extension YahooFinanceQuoteWebSocket {
    private func connect() {
        guard let url = URL(string: "wss://streamer.finance.yahoo.com") else { return }
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask.resume()
    }
    
    private func close() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    private func send(message: URLSessionWebSocketTask.Message) {
        webSocketTask.send(message) { error in
            if let error = error {
                print("Error when sending a message \(error)")
            }
        }
    }
    
    private func listen() {
        webSocketTask.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self.handle(data)
                case .string(let text):
                    guard let data = Data(base64Encoded: text, options: .ignoreUnknownCharacters) else { return }
                    self.handle(data)
                @unknown default: break
                }
            case .failure(let error):
                print("Error when receiving \(error)")
            }
            self.listen()
        }
    }
    
    private func handle(_ data: Data) {
        do {
            let quote = try YahooFinanceRealTimeQuote(serializedData: data)
            print(quote)
        } catch {
            print("Error then handling \(error)")
        }
    }
}

extension YahooFinanceQuoteWebSocket {
    public func subscribe(symbols: [String]) {
        do {
            let params = ["subscribe": symbols]
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let message = URLSessionWebSocketTask.Message.string(jsonString)
            send(message: message)
        } catch {
            print("Error when subscribing \(error)")
        }
    }
    
    public func unsubscribe(symbols: [String]) {
        do {
            let params = ["unsubscribe": symbols]
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let message = URLSessionWebSocketTask.Message.string(jsonString)
            send(message: message)
        } catch {
            print("Error when unsubscribing \(error)")
        }
    }
}

extension YahooFinanceQuoteWebSocket: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
        listen()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
}
