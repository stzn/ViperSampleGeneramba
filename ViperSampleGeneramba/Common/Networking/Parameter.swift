import Foundation

protocol ParamKey {
    var stringValue: String { get }
}

extension RawRepresentable where RawValue == String {
    var stringValue: String {
        return rawValue
    }
}

protocol ApiParameter {
    var properties:Array<ParamKey> { get }
    func valueForKey(key: ParamKey) -> Any?
    func toDictionary() -> [String:Any]
}

protocol GetApiParameter: ApiParameter {
    func makeQueryItem() -> [URLQueryItem]
}

protocol PostApiParameter: ApiParameter {
    func makeParameterString() -> String
}

extension ApiParameter {
    
    func toDictionary() -> [String:Any] {
        
        var dict:[String:Any] = [:]
        
        for prop in self.properties {
            if let val = self.valueForKey(key: prop) as? String {
                dict[prop.stringValue] = val
            } else if let val = self.valueForKey(key: prop) as? Int {
                dict[prop.stringValue] = val
            } else if let val = self.valueForKey(key: prop) as? Double {
                dict[prop.stringValue] = val
            } else if let val = self.valueForKey(key: prop) as? Array<String> {
                dict[prop.stringValue] = val
            } else if let val = self.valueForKey(key: prop) as? ApiParameter {
                dict[prop.stringValue] = val.toDictionary()
            } else if let val = self.valueForKey(key: prop) as? Array<ApiParameter> {
                var arr = Array<[String:Any]>()
                
                for item in (val as Array<ApiParameter>) {
                    arr.append(item.toDictionary())
                }
                
                dict[prop.stringValue] = arr
            }
        }
        return dict
    }
}


extension GetApiParameter {
    func makeQueryItem() -> [URLQueryItem] {
        var items:[URLQueryItem] = []
        let parameter: [String:Any] = self.toDictionary()
        parameter.forEach { key, value in
            let string = String(describing: value)
            guard !string.isEmpty else { return }
            items.append(URLQueryItem(name: key, value: string.URLEscaped))
        }
        return items
    }
}

extension PostApiParameter {
    func makeParameterString() -> String {
        let parameter: [String:Any] = self.toDictionary()
        return parameter.enumerated().reduce("?") { (input, tuple) in
            switch tuple.element.value {
            case let string as String:
                guard string.isEmpty else { return "" }
                return input + tuple.element.key + "=" + string
            default:
                return input + tuple.element.key + "=" + String(describing: tuple.element.value)
            }
        }
    }
}

