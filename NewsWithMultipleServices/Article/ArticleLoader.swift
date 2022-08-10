protocol ArticleLoader {
    typealias ArticleLoaderResult = Swift.Result<[Article], Error>
    func load(completion: @escaping (ArticleLoaderResult) -> ())
}
