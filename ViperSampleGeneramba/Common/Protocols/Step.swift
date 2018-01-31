import UIKit

// Inputを受け取り、非同期で実行し、結果をOutputにしてコールバックに渡す
protocol Step {
    
    associatedtype Input
    associatedtype Output
    
    func perform(_ input: Input, completion: @escaping (_ output: Output) -> Void)
}

struct StepT<Input, Output>: Step {

    private let _perform: (Input, @escaping (Output) -> Void) -> Void
 
    init<P: Step>(_ step: P) where P.Input == Input, P.Output == Output {
        _perform = step.perform
    }
    
    func perform(_ input: Input, completion: @escaping (Output) -> Void) {
        self._perform(input, completion)
    }
    
}
