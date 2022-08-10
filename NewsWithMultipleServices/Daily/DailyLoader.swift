protocol DailyLoader {
    typealias DailyLoaderResult = Swift.Result<String, Error>
    func load(completion: @escaping (DailyLoaderResult) -> ())
}
