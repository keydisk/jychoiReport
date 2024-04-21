//
//  jyChoiReportTests.swift
//  jyChoiReportTests
//
//  Created by JuYoung choi on 4/20/24.
//

import XCTest
import Combine
import RxSwift

@testable import jyChoiReport

final class jyChoiReportTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    var cancelationList = Set<AnyCancellable>()
    
    func test알라모파이어로_뉴스요청_정상적으로_되는지_확인() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let expectation = XCTestExpectation(description: "\(#function)")
        
        let api = NewsAPI()
        
        api.requestNewsFromAlamofire().sink(receiveCompletion: {finish in
            
            expectation.fulfill()
        }, receiveValue: {data in
            
            assert(data.count > 0)
            expectation.fulfill()
        }).store(in: &cancelationList)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testURLSession으로_뉴스요청_정상적으로_되는지_확인() {
        
        let expectation = XCTestExpectation(description: "\(#function)")
        
        let api = NewsAPI()
        
        api.requestNewsFromUrlSession().sink(receiveCompletion: {finish in
            
            expectation.fulfill()
        }, receiveValue: {data in
            
            assert(data.count > 0)
            expectation.fulfill()
        }).store(in: &cancelationList)
        
        wait(for: [expectation], timeout: 5)
    }

    var parsingDisposable: Disposable?
    func test정상적으로_결과가_파싱되는지_확인() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let expectation = XCTestExpectation(description: "\(#function)")
        
        let viewModel = NewsViewModel()
        
        self.parsingDisposable = viewModel.newsList.bind(onNext: {list in
            
            guard let list = list else {
                return
            }
            
            assert(list.count > 0)
            expectation.fulfill()
        })
        
        viewModel.requestNewsList()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test뉴스_상세로_이동시_정상적으로_저장되는지_확인() {
        
        let expectation = XCTestExpectation(description: "\(#function)")
        
        let viewModel = NewsViewModel()
        
        MoveApp.removeAllData()
        
        self.parsingDisposable = viewModel.newsList.bind(onNext: {list in
            
            guard let list = list, let model = list.first else {
                return
            }
            
            viewModel.newsDetailProcess(model)
            let coreDataList = MoveApp.getData() ?? []
            assert(coreDataList.first?.urlNews?.absoluteString ==  model.newsUrl)
            
            expectation.fulfill()
        })
        
        viewModel.requestNewsList()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
