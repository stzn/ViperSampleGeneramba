import Foundation

public final class Task<Response, Error> {
    
    public typealias Initializer = (_: @escaping (APIResult<Response>) -> Void) -> Void
    
    private let maximumRetryCount: Int = 10
    
    private let maximumIntervalTime: Double = 100000.0
    
    private var response: ((APIResult<Response>) -> Void)?
    
    private var initializer: Initializer?
    
    private lazy var retry: Int = 0
    
    private lazy var interval: Double = 0.0

    @discardableResult
    public func response(_ handler: @escaping (APIResult<Response>) -> Void) -> Self {
        response = handler
        return self
    }
    
    public func retry(max times: Int) -> Self {
        retry = times
        return self
    }
    
    public func interval(milliseconds ms: Double) -> Self {
        interval = ms
        return self
    }
    
    public init(initClosure: @escaping Initializer) {
        initializer = initClosure
        executeRequest()
    }
    
    private func executeRequest() {
        initializer?({ result in
            
            switch result {
            case let .response(data):
                self.response?(APIResult.response(data))
            case let .error(data):
                self.response?(APIResult.error(data))
                //self.doRetry()
            }
        })
    }
    
    private func doRetry() {
        if retry > maximumRetryCount {
            fatalError("The retry count is too many.")
        }
        
        if retry > 0 {
            retry = -1
            if interval > maximumIntervalTime {
                fatalError("The interval time is too much.")
            }
            let delayTime = DispatchTime.now() + Double(Int64(interval / 1000.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.executeRequest()
            }
        }
    }
}
