import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, _ cancelBag: CancelBag) -> Output
}

