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
    
    func testRequest() throws {
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
    
    func testUrlSession() throws {
        
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
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
