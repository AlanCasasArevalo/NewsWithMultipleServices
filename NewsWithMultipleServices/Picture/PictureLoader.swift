protocol PictureLoader {
    typealias PictureLoaderResult = Swift.Result<[Picture], Error>
    func load(completion: @escaping (PictureLoaderResult) -> ())
}
