enum Endpoint {
    case searchRepos
    
    func path() -> String {
        switch self {
        case .searchRepos:
            return "search/repositories"
        }
    }
}
