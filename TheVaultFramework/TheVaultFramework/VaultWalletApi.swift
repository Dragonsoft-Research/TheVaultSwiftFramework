//
//  VaultWalletApi.swift
//  TheVaultFramework
//
//  Created by Paul Stinchcombe on 8/6/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation
import SocketIO


@objc public protocol VaultWalletEventsDelegate {
    @objc func didReceiveTransactionEvent(_ type: WalletEvent, data: NotificationData)
    @objc optional func didReceiveDebugEvent(data: String)
    @objc optional func didReceiveBroadcast(data: String)
}

@objc public enum WalletEvent : Int {
    case TransactionStatus  = 0
    case NewTransaction     = 1
    case DebugInfo          = 2
}

@objcMembers public class NotificationData: NSObject, Decodable {
    public let txHash  :String
    public let to      :String
    public let from    :String
    public let value   :String
    public let status  :String
}

public struct AuthResult: Decodable {
    let success: Bool
}




@objcMembers open class VaultWalletApi: NSObject {

    public static var walletEventsDelegate: VaultWalletEventsDelegate?
    
    private static let Version = "1.3"
    
    private static var instance: VaultWalletApi? = nil
    
    private static var Instance :VaultWalletApi {
        get {
            if VaultWalletApi.instance == nil {
                VaultWalletApi.instance = VaultWalletApi()
            }
            return instance!
        }
    }
    
    fileprivate let manager:SocketManager = {
        return SocketManager(socketURL: URL(string: "https://api.thevault.cc:81")!, config: [.log(true)])
    }()
    
    fileprivate var socket: SocketIOClient!
    fileprivate var isSocketAutherised = false

    public enum BackendError: Error {
        case urlError(reason: String)
        case objectSerialization(reason: String)
    }
    
    public enum VaultFrameworkError: Error {
        case noData
        case jsonError(error: Error)
        case blockchainError(error: String)
        case genericError(error: String)
    }
    

    override public init() {
        super.init()
        
        print("Framework Init")
        VaultWalletApi.instance = self
        
        socket = manager.defaultSocket
        initSocketIO()
    }

    
    fileprivate func initSocketIO() {
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
            if VaultWalletApi.walletEventsDelegate?.didReceiveDebugEvent != nil {
                VaultWalletApi.walletEventsDelegate?.didReceiveDebugEvent!(data: "Connected")
            }
        }

        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected")
            if VaultWalletApi.walletEventsDelegate?.didReceiveDebugEvent != nil {
                VaultWalletApi.walletEventsDelegate?.didReceiveDebugEvent!(data: "Disconnected")
            }
        }

        socket.on("authResult") { data, ack in
            print("Socket.IO: authResult")
            guard let delegate = VaultWalletApi.walletEventsDelegate?.didReceiveDebugEvent else { return }
            let json = data[0] as! String
            if let auth = try? JSONDecoder().decode(AuthResult.self, from: json.data(using: .utf8)!) as AuthResult {
                if auth.success {
                    delegate("Authorised")
                } else {
                    delegate("Not Authorised")
                }
                self.isSocketAutherised = auth.success
            }
            ack.with("received")
        }
             
        socket.on("general") { data, ack in
            print("Socket.IO: general")
            guard let delegate = VaultWalletApi.walletEventsDelegate?.didReceiveBroadcast else { return }
            delegate(data[0] as! String)
            ack.with("received")
        }

        socket.on("transactionStatus") { data, ack in
            print("Socket.IO: transactionStatus")
            let jsonP1 = (data[0] as! String).replacingOccurrences(of: "\\\"", with: "\"")
            let jsonP2 = jsonP1.prefix(jsonP1.count-1)
            let json = jsonP2.suffix(jsonP2.count-1)
            
            do {
                let txStatus = try JSONDecoder().decode(NotificationData.self, from: json.data(using: .utf8)!) as NotificationData
                VaultWalletApi.walletEventsDelegate?.didReceiveTransactionEvent(.TransactionStatus, data: txStatus)
            } catch {
                print(error.localizedDescription)
            }
            ack.with("received")
        }

        socket.on("newTransaction") { data, ack in
            print("Socket.IO: newTransaction")
            let jsonP1 = (data[0] as! String).replacingOccurrences(of: "\\\"", with: "\"")
            let jsonP2 = jsonP1.prefix(jsonP1.count-1)
            let json = jsonP2.suffix(jsonP2.count-1)

            do {
                let newTx = try JSONDecoder().decode(NotificationData.self, from: json.data(using: .utf8)!) as NotificationData
                VaultWalletApi.walletEventsDelegate?.didReceiveTransactionEvent(.NewTransaction, data: newTx)
            } catch {
                print(error.localizedDescription)
            }
            ack.with("received")
        }

        print("Connecting Socket")
        socket.connect()
    }
    
    
    
    /* API Methods */
    
    open class func ApiVersion() -> String      { return Version               }
    open class func SetToken(token: String)     { Globals.Token = token        }
    open class func SetCoin(coin:String)        { Globals.CurrentSymbol = coin }
    open class func SetServerUrl(url:String)    { Globals.SERVER = url         }
    open class func GetServerUrl() -> String    { return Globals.SERVER        }

    open class func SetApiKey(apikey: String)   {
        let _ = VaultWalletApi.Instance;
        Globals.APIKEY = apikey
    }

    open class func RegisterDevice(userName: String, pushToken: String) {
        let request = RegisterDeviceAPI(userName: userName, pushToken: pushToken)
        VaultWalletApi.Instance.fetchData(from: "/registerDevice", request: request) { (registrationData: RegistrationData?, error) in
            if let error = error {
                print("boom... RegisterDevice: \(error.localizedDescription)")
                return
            }
            if let response = registrationData {
                Globals.DeviceRegistered = response.success
            }
        }
    }
    
    open class func CheckUsername(username: String, completionHandler: @escaping (Bool)->Void) {
        let request = CheckUsernameAPI(username: username)
        VaultWalletApi.Instance.fetchData(from: "/checkUsername", request: request) { (response:SimpleOperationResponse?, error) in
            if let response = response {
                completionHandler(response.success)
            } else {
                completionHandler(false)
            }
        }
    }
    
    open class func GetUserDetails(completionHandler: @escaping (UserData?, VaultFrameworkError?)->Void) {
        if let ud = UserData.get() {
            completionHandler(ud, nil)
            DispatchQueue.global().async {
                VaultWalletApi.Instance.fetchData(from: "/getUserDetails", request: nil, completion: { (ud: UserData?, err) in
                    if let ud = ud { ud.save() }
                })
            }
        } else {
            VaultWalletApi.Instance.fetchData(from: "/getUserDetails", request: nil, completion: { (ud: UserData?, err) in
                if let ud = ud { ud.save() }
                completionHandler(ud, err)
            })
        }
    }
    
    
    open class func GetAccounts(completionHandler: @escaping (AccountsData?, Error?)->Void) {
        VaultWalletApi.Instance.fetchData(from: "/getAccounts", request: nil) { (accountsData: AccountsData?, error) in
            if let ad = accountsData {
                Globals.Accounts = ad.accounts
            }
            completionHandler(accountsData, error)
        }
    }
    
    open class func GetFavorites(completionHandler: @escaping (FavoritesData?, Error?)->Void) {
        VaultWalletApi.Instance.fetchData(from: "/getFavorites", request: nil, completion: completionHandler)
    }
    
    
    open class func AddFavorite(address:String, nickname:String, currency:String, completionHandler: @escaping (SimpleOperationResponse?, Error?)->Void) {
        let request = AddDeleteFavoriteAPI(address: address, nickname: nickname, currency: currency)
        VaultWalletApi.Instance.fetchData(from: "/addFavorite", request: request, completion: completionHandler)
    }
    
    
    open class func DeleteFavorite(address:String, nickname:String, currency:String, completionHandler: @escaping (SimpleOperationResponse?, Error?)->Void) {
        let request = AddDeleteFavoriteAPI(address: address, nickname: nickname, currency: currency)
        VaultWalletApi.Instance.fetchData(from: "/deleteFavorite", request: request, completion: completionHandler)
    }
    
    
    open class func GetBalance(account: String, completionHandler: @escaping (String?, Error?)->Void) {
        let request = AddressAPI(account: account)
        VaultWalletApi.Instance.fetchData(from: "/getBalance", request: request) { (bal:BalanceData?, error) in
            if let error = error { completionHandler(nil, error) }
            else { completionHandler(bal?.balance, nil) }
        }
    }
    

    open class func GetBalance(account: String, symbol: String, completionHandler: @escaping (String?, Error?)->Void) {
        let request = GetTokenBalanceAPI(account: account, symbol: symbol)
        VaultWalletApi.Instance.fetchData(from: "/getBalance", request: request) { (bal:BalanceData?, error) in
            if let error = error { completionHandler(nil, error) }
            else { completionHandler(bal?.balance, nil) }
        }
    }
    
    
    open class func Login(userName: String, password: String, completionHandler: @escaping (LoginData?, Error?)->Void) {
        let request = LoginAPI(username: userName, password: password)
        VaultWalletApi.Instance.fetchData(from: "/login", request: request) { (loginData: LoginData?, error) in
            if let lData = loginData {
                Globals.Token = lData.token
                let json = "{\"username\":\"\(userName)\", \"password\":\"\(password)\", \"apikey\":\"\(Globals.APIKEY)\"}"
                VaultWalletApi.Instance.socket.emit("auth", [json])
            }
            completionHandler(loginData, error)
        }
    }
    
    
    open class func SendTransaction(to:String, value:Double, unit:EthUnitConverter.EthereumUnit, txFee:String, memo:String, merchant:MerchantData? = nil, completionHandler: @escaping (SimpleOperationResponse?, Error?)->Void) {
        let weiValue = EthUnitConverter.toWei(value, from: unit)
        let strValue = String(format: "%.0f",weiValue)

        let request = SendTransactionAPI(to: to, value: strValue, txFee: String(txFee), memo: memo, merchant: merchant)
        VaultWalletApi.Instance.fetchData(from: "/sendTxn", request: request, completion: completionHandler)
    }


    open class func SendTransaction(to:String, value:Double, unit:BtcUnitConverter.BitcoinUnit, txFee: String, memo:String, merchant:MerchantData? = nil, completionHandler: @escaping (SimpleOperationResponse?, Error?)->Void) {
        let satoshiValue = BtcUnitConverter.toSatoshi(value, from: unit)
        let strValue = String(format: "%.0f",satoshiValue)

        let request = SendTransactionAPI(to: to, value: strValue, txFee: String(txFee), memo: memo, merchant: merchant)
        VaultWalletApi.Instance.fetchData(from: "/sendTxn", request: request, completion: completionHandler)
    }

    @objc open class func SendTransaction(to:String, value:Double, unit:String, txFee:String, memo:String, merchant: MerchantData? = nil, completionHandler: @escaping (SimpleOperationResponse?, Error?)->Void) {
        
        if let btcUnit = BtcUnitConverter.BitcoinUnit(rawValue: unit) {
            SendTransaction(to: to, value: value, unit: btcUnit, txFee: txFee, memo: memo, merchant: merchant, completionHandler: completionHandler)
        } else if let ethUnit = EthUnitConverter.EthereumUnit(rawValue: unit) {
            SendTransaction(to: to, value: value, unit: ethUnit, txFee: txFee, memo: memo, merchant: merchant, completionHandler: completionHandler)
        } else {
            completionHandler(SimpleOperationResponse(success: false, error: "Invalid Unit"), nil)
        }
    }

    open class func SendToken(to:String, value:String, token:String, txFee:String, memo:String, merchant:MerchantData? = nil, completionHandler: @escaping (SimpleOperationResponse?, Error?)->Void) {
        print("boom value = \(String(value))")
        let request = SendTokenAPI(to: to, value: value, symbol: token, txFee: txFee, memo: memo, merchant: merchant)
        VaultWalletApi.Instance.fetchData(from: "/sendTxn", request: request, completion: completionHandler)
    }
    
    open class func GetTransactionsForToken(account : String, symbol:String, completionHandler: @escaping ([TokenTransactionItem]?, Error?)->Void) {
        let request = AddTokenToAccountAPI(account: account, symbol: symbol)
        VaultWalletApi.Instance.fetchData(from: "/getTransactionsForToken", request: request) { (ttd:TokenTransactionData?, error) in
            guard ttd != nil else {
                completionHandler(nil, error)
                return
            }
            if (ttd?.success)! {
                completionHandler(ttd?.transactions, nil)
            } else {
                completionHandler([TokenTransactionItem](), nil)
            }
        }
    }
    
    
    open class func GetTransactions(account : String, completionHandler: @escaping (TransactionData?, Error?)->Void) {
        let request = AddressAPI(account: account)
        VaultWalletApi.Instance.fetchData(from: "/listTxns", request: request, completion: completionHandler)
    }
    
    
    open class func GetExchangeRate(completionHandler: @escaping (ExchangeData?, Error?)->Void) {
        VaultWalletApi.Instance.getExchangeRate(completionHandler: completionHandler)
    }
    
    
    open class func CreateUser(username:String, password:String, fullname: String, secureWord :String, question: String, answer: String, completionHandler: @escaping (Bool, Error?)->()) {
        let request = CreateUserAPI(username: username, password: password, fullname: fullname, secureWord: secureWord, question: question, answer: answer)
        VaultWalletApi.Instance.fetchData(from: "/createUser", request: request) { (sor: SimpleOperationResponse?, error) in
            var err = error
            if let sor = sor, !sor.success, let sorError = sor.error {
                err = VaultFrameworkError.genericError(error: sorError)
                completionHandler(sor.success, err)
            } else if let sor = sor {
                completionHandler(sor.success, err)
            } else {
                completionHandler(false, err)
            }
        }
    }
    
    
    open class func CreateAccount(nickname: String, password:String, completionHandler: @escaping (CreateAccountData?, Error?)->Void) {
        let request = CreateAccountAPI(nickname: nickname, wpw: password)
        VaultWalletApi.Instance.fetchData(from: "/createAccount", request: request, completion: completionHandler)
    }
    
    
    open class func SetNicknameForAccount(account: String, nickname: String, completionHandler: @escaping (SimpleOperationResponse?, Error?)->Void) {
        let request = SetAccountNicknameAPI(account: account, nickname: nickname)
        VaultWalletApi.Instance.fetchData(from: "/setNicknameForAccount", request: request, completion: completionHandler)
    }
    
    
    open class func GetCoinList(completionHandler: @escaping (CoinData?, Error?)->Void) {
        VaultWalletApi.Instance.fetchData(from: "/getCoinList", request: nil, completion: completionHandler)
    }
    
    
    open class func GetTokensForAccount(account: String, completionHandler: @escaping ([Erc20Token]?, Error?) -> Void) {
        let request = AddressAPI(account: account)
        VaultWalletApi.Instance.fetchData(from: "/getTokensForAccount", request: request) { (erc20td: Erc20TokenData?, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let erc20td = erc20td else {
                completionHandler(nil, VaultFrameworkError.noData)
                return
            }
            
            completionHandler(erc20td.tokens, nil)
        }
    }
    
    
    open class func AddTokenToAccount(account: String, token: String, completionHandler: @escaping (SimpleOperationResponse?, Error?) -> Void) {
        let request = AddTokenToAccountAPI(account: account, symbol: token)
        VaultWalletApi.Instance.fetchData(from: "/addTokenToAccount", request: request, completion: completionHandler)
    }
    
    open class func RemoveTokenFromAccount(account: String, token: String, completionHandler: @escaping (SimpleOperationResponse?, Error?) -> Void) {
        let request = AddTokenToAccountAPI(account: account, symbol: token)
        VaultWalletApi.Instance.fetchData(from: "/removeTokenFromAccount", request: request, completion: completionHandler)
    }
    
    open class func GetTokenInfo(token: String, completionHandler: @escaping (TokenInfo?, Error?) -> Void) {
        let request = TokenInfoAPI(symbol: token)
        VaultWalletApi.Instance.fetchData(from: "/getTokenInfo", request: request) { (tiData: TokenInfoData?, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            guard let tiData = tiData else {
                completionHandler(nil, error)
                return
            }
            completionHandler(tiData.tokenInfo, nil)
        }
    }
    
    
    open class func ChangePassword(password: String, completionHandler: @escaping (SimpleOperationResponse?, Error?)->()) {
        let request = ChangePasswordAPI(password: password)
        VaultWalletApi.Instance.fetchData(from: "/changePassword", request: request, completion: completionHandler)
    }
    

    open class func ImportAccount(account: String, privateKey: String, nickname: String, completionHandler: @escaping (CreateAccountData?, Error?)->()) {
        let request = ImportAccountAPI(account: account, privateKey: privateKey, nickname: nickname)
        VaultWalletApi.Instance.fetchData(from: "/importAccount", request: request, completion: completionHandler)
    }
    
    
    open class func ExportAccount(account: String, password: String, completionHandler: @escaping (String?, Error?)->()) {
        let request = ExportWalletAPI(account: account, password: password)
        VaultWalletApi.Instance.fetchData(from: "/exportWallet", request: request) { (tiData: ExportWalletData?, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            guard let ewData = tiData else {
                completionHandler(nil, error)
                return
            }
            completionHandler(ewData.wallet, nil)
        }
    }
    

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Class Methods
    
    fileprivate func fetchData<T: Decodable>(from endpoint: String, request: JSONCodable?, completion: @escaping (T?, VaultFrameworkError?)->()) {
        let urlString = Globals.SERVER + endpoint
        _ = getDataFromURL(endPoint: urlString, request: request?.toDictionary(), completionHandler: {
            (responseData, error) in
            if let error = error {
                print(error)
                completion(nil, VaultFrameworkError.genericError(error: error.localizedDescription))
                return
            }
            
            let result = self.processResponse(responseData, T.self)
            guard let td = result.object else {
                print(result.error!.localizedDescription)
                completion(nil, result.error)
                return
            }
            
            completion(td, nil)
        })
    }
    
    
    fileprivate func processResponse<T: Decodable>(_ responseData: Data?, _ type: T.Type) -> (object: T?, error: VaultFrameworkError?) {
        var returnObject: T? = nil
        
        guard let responseData = responseData else {
            return (object: nil, error: .noData)
        }
        
        print("responseData: \(String(data: responseData, encoding: .utf8)!)")
        
        let decoder = JSONDecoder()
        do {
            let sor = try decoder.decode(SimpleOperationResponse.self, from: responseData)
            if !sor.success {
                return (object: nil, error: .blockchainError(error: sor.error!))
            }
            
            returnObject = try decoder.decode(T.self, from: responseData)
        } catch {
            print("error trying to convert data from JSON")
            print(error)
            return (object: nil, error: .jsonError(error: error))
        }
        
        return (object:returnObject, error: nil)
    }
    
    
    fileprivate func getExchangeRate(completionHandler: @escaping (ExchangeData?, Error?)->Void) {
        guard let url = URL(string: Globals.EXCHANGE) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            print("getExchangeRate: responseData=\(String(data: responseData, encoding:.utf8)!)")
            
            let decoder = JSONDecoder()
            do {
                let exData = try decoder.decode(ExchangeData.self, from: responseData)
                Globals.ExchangeRate = exData.USD
                completionHandler(exData, nil)
                
            } catch {
                print("error trying to convert data from JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    
    private func getDataFromURL(endPoint:String, request:JSONCodable.JSON?, completionHandler: @escaping (Data?, Error?)->Void) {
        print("Endpoint = \(endPoint)")
        guard let url = URL(string: endPoint) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        // Setup headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(Globals.CurrentSymbol, forHTTPHeaderField: "cryptocoin")
        urlRequest.setValue(Globals.APIKEY, forHTTPHeaderField: "apikey")
        urlRequest.setValue(Globals.Token, forHTTPHeaderField: "token")
        
        // Create JSON request body
        if let request = request {
            let jsondata = try? JSONSerialization.data(withJSONObject: request, options: .prettyPrinted)
            urlRequest.httpBody = jsondata
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            print(response!)
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            print("getDataFromURL: responseData=\(String(data: responseData, encoding:.utf8)!)")
            completionHandler(responseData, nil)
        }
        task.resume()
    }
    
}

