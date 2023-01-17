import Foundation
import WolfAPI
import WolfBase

public enum EsploraNetwork {
    case mainnet
    case testnet
    
    var pathPrefix: [String] {
        switch self {
        case .mainnet:
            return ["api"]
        case .testnet:
            return ["testnet", "api"]
        }
    }
}

func makePath(_ network: EsploraNetwork, _ path: [Any]?) -> [Any] {
    var path = network.pathPrefix
    path.append(contentsOf: path)
    return path
}

extension API {
    public func call(
        isAuth: Bool = false,
        method: WolfAPI.Method = .get,
        scheme: Scheme? = nil,
        network: EsploraNetwork,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String?>? = nil,
        body: RequestBody? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        actions: URLSessionActions? = nil,
        mock: Mock? = nil
    ) async throws -> Data {
        try await call(isAuth: isAuth, method: method, scheme: scheme, path: makePath(network, path), query: query, body: body, successStatusCodes: successStatusCodes, actions: actions, mock: mock)
    }
    
    public func call<T: Decodable>(
        returning returnType: T.Type,
        isAuth: Bool = false,
        method: WolfAPI.Method = .get,
        scheme: Scheme? = nil,
        network: EsploraNetwork,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String?>? = nil,
        body: RequestBody? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        actions: URLSessionActions? = nil,
        mock: Mock? = nil
    ) async throws -> T  {
        try await call(returning: returnType, isAuth: isAuth, method: method, scheme: scheme, path: makePath(network, path), query: query, body: body, successStatusCodes: successStatusCodes, actions: actions, mock: mock)
    }
}
