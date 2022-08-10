import XCTest
@testable import NewsWithMultipleServices

struct MainModel: Equatable {    
    let articles: [Article]
    let pictures: [Picture]
    let dailyQuote: String
}

protocol MainLoader {
    typealias Result = Swift.Result<MainModel, Error>
    func load(date: Date, completion: @escaping (Result) -> ())
}

class MainLoaderAdapter: MainLoader {
    
    let articleLoader: ArticleLoader
    let pictureLoader: PictureLoader
    let dailyLoader: DailyLoader
    
    init(articleLoader: ArticleLoader, pictureLoader: PictureLoader, dailyLoader: DailyLoader) {
        self.articleLoader = articleLoader
        self.pictureLoader = pictureLoader
        self.dailyLoader = dailyLoader
    }
    
    func load(date: Date, completion: @escaping (MainLoader.Result) -> ()) {
        articleLoader.load { articleResult in
            self.pictureLoader.load { pictureResult in
                self.dailyLoader.load { dailyResult in
                    completion(
                        .success(
                            MainModel(
                                articles: try! articleResult.get(),
                                pictures: try! pictureResult.get(),
                                dailyQuote: try! dailyResult.get()
                            )
                        )
                    )
                }
            }
        }
    }
}

class MainLoaderAdapterTests: XCTestCase {
    func test() {
        let loader = LoaderStub()
        
        let sut = MainLoaderAdapter(articleLoader: loader, pictureLoader: loader, dailyLoader: loader)
        
        let exp = expectation(description: "waiting for completion")
        var result: MainLoader.Result?
        sut.load(date: Date()) {
            result = $0
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(try result?.get(), loader.stub)
    }
}

extension MainLoaderAdapterTests {
    // MARK: - Helper
    
    private class LoaderStub: ArticleLoader, PictureLoader, DailyLoader {
        
        let stub = MainModel(
            articles: [
                Article(author: "any author", title: "any title", url: "any url", urlToImage: "any image", content: "any content")
            ],
            pictures: [
                Picture(name: "any image name", imageURL: "any image url")
            ],
            dailyQuote: "any quote"
        )
        
        func load(completion: @escaping (ArticleLoaderResult) -> ()) {
            completion(.success(stub.articles))
        }
        
        func load(completion: @escaping (PictureLoaderResult) -> ()) {
            completion(.success(stub.pictures))
        }
        
        func load(completion: @escaping (DailyLoaderResult) -> ()) {
            completion(.success(stub.dailyQuote))
        }
    }
}
