import Foundation

/// Represents an error encountered during the execution of a GraphQL operation.
///
///  - SeeAlso: [The Response Format section in the GraphQL specification](https://facebook.github.io/graphql/#sec-Response-Format)
public struct GraphQLError: Error {
    
    private let object: JSONObject
    
    public init(_ object: JSONObject) {
        self.object = object
    }
    
    init(_ message: String) {
        self.init(["message": message])
    }
    
    public init(data: Data?, response: HTTPURLResponse?, error: Error?) {
        
        var code: Int = response?.statusCode ?? 0
        var messages: String = response?.statusCodeDescription ?? ""
        var message: [String] = [response?.statusCodeDescription ?? ""]
        var details: [String : [Any]] =  ["" : [""]]
        
        if let body = data {
            do {
                guard let body = try JSONSerializationFormat.deserialize(data: body) as? JSONObject else {
                    throw GraphQLError(data: nil, response: response, error: error)
                    return
                }
                self.init(body)
                return
            } catch {
                
            }
        }
        let dict: [String: JSONValue] = ["code": code,
                                         "type": "default",
                                         "message": message,
                                         "messages": messages,
                                         "details": details]
        
        self.init(dict)
    }
    
    /// GraphQL servers may provide additional entries as they choose to produce more helpful or machine‐readable errors.
    public subscript(key: String) -> Any? {
        return object[key]
    }
    
    public var messages: [String] {
        return object["messages"] as! [String]
    }
    
    public var message: String {
        return object["message"] as! String
    }
    
    public var code: Int {
        return object["code"] as! Int
    }
    
    public var type: String {
        return object["type"] as! String
    }
    public var details: [String: [String]] {
        return object["details"] as! [String : [String]]
    }
    
    
    /// A list of locations in the requested GraphQL document associated with the error.
    public var locations: [Location]? {
        return (self["locations"] as? [JSONObject])?.map(Location.init)
    }
    
    /// Represents a location in a GraphQL document.
    public struct Location {
        /// The line number of a syntax element.
        public let line: Int
        /// The column number of a syntax element.
        public let column: Int
        
        init(_ object: JSONObject) {
            line = object["line"] as! Int
            column = object["column"] as! Int
        }
    }
}

extension GraphQLError: CustomStringConvertible {
    public var description: String {
        return self.message
    }
}

extension GraphQLError: LocalizedError {
    public var errorDescription: String? {
        return description
    }
}
