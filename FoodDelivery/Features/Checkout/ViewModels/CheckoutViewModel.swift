//
//  CheckoutViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 08/01/24.
//

import CoreLocation
import Foundation

enum PaymentMethod: String{
    case cash = "Cash"
    case paylater = "Paylater"
}

@MainActor
final class CheckoutViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    let manager = CLLocationManager()
    
    @Published var showingAlert = false
    @Published private(set) var payment = PaymentMethod.cash
    let payments: [PaymentMethod] = [.cash, .paylater]
    
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var checkoutError: CheckoutError?
    @Published var hasError = false
    @Published var address: String?
    
    private let networkingManager: NetworkingManager!
    private var addressResponse: Response<Address>?
    
    override init() {
        networkingManager = NetworkingManagerImpl.shared
        super.init()
        manager.delegate = self
    }
    
    var formattedAddress: String {
        if address == nil {
            return ""
        } else {
            return address!
        }
    }
    
    var isDisabled: Bool {
        formattedAddress.isEmpty
    }
    
    func getUserAddress() async {
        networkingState = .loading
        
        do {
            addressResponse = try await networkingManager.request(session: .shared, .getUserAddress, type: Response<Address>.self)
            address = addressResponse?.data.address
            
            networkingState = .success
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.checkoutError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.checkoutError = .system(error: error)
            }
        }
    }
    
    func updateUserAddress() async {
        networkingState = .loading
        
        do {
            let addressModel = Address(address: address!)
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(addressModel)
            
            try await networkingManager.request(session: .shared, .updateUserAddress(submissionData: data))
            networkingState = .success
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
            case is NetworkingManagerImpl.NetworkingError:
                self.checkoutError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.checkoutError = .system(error: error)
            }
        }
    }
    
    func checkoutOrder(orders: [Order]) async -> Bool {
        networkingState = .loading
        
        do {
            let checkoutForms = orders.map { order in
                CheckoutForm(orderID: order.id, foodID: order.foodID, total: order.price * order.quantity, quantity: order.quantity)
            }
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(checkoutForms)
            
            try await networkingManager.request(session: .shared, .checkoutOrder(submissionData: data))
            networkingState = .success
            
            return true
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.checkoutError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.checkoutError = .system(error: error)
            }
            
            return false
        }
    }
    
    func changePayment(payment: PaymentMethod){
        self.payment = payment
    }
    
    func requestLocation(){
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lookUpCurrentLocation { placemark in
            if placemark != nil {
                self.address = placemark
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (String?) -> Void){
        if let lastLocation = manager.location{
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation) { placemarks, error in
                if error == nil {
                    let firstLocation = placemarks?[0].name
                    completionHandler(firstLocation)
                } else {
                    completionHandler(nil)
                }
            }
        } else {
            completionHandler(nil)
        }
    }
}

extension CheckoutViewModel {
    enum CheckoutError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension CheckoutViewModel.CheckoutError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension CheckoutViewModel.CheckoutError: Equatable {
    
    static func == (lhs: CheckoutViewModel.CheckoutError, rhs: CheckoutViewModel.CheckoutError) -> Bool {
        switch (lhs, rhs) {
        case (.networking(let lhsType), .networking(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.system(let lhsType), .system(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}
