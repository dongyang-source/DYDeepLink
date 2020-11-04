//
//  DYDeepLinkTests.swift
//  DYDeepLinkTests
//
//  Created by yangdy on 2020/11/4.
//

import XCTest
@testable import DYDeepLink

class DYDeepLinkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let noPathCallBack: DYDeepLink.DeepLinkCallBack  = { (url, param) in
            print("registerDeepLinkNoPath:\n url = \(url)\n param = \(param)")
        }
        DYDeepLink.registerDeepLink(scheme: "deepLink", host: "content", callBack: noPathCallBack)
        DYDeepLink.registerDeepLink(scheme: "https", host: "openWith", callBack: noPathCallBack)
        
        DYDeepLink.registerDeepLinkDefaultHandler { (url, param) in
            print("DefaultHandler:\n url = \(url)\n param = \(param)")
        }

        let withPathCallBack: DYDeepLink.DeepLinkCallBack  = { (url, param) in
            print("registerDeepLinkWithPath:\n url = \(url)\n param = \(param)")
        }
        DYDeepLink.registerDeepLink(scheme: "deepLink", host: "content", paths: ["path"], callBack: withPathCallBack)
        DYDeepLink.registerDeepLink(scheme: "https", host: "openWith", paths: ["path"], callBack: withPathCallBack)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // deepLink://content?name=lisa&sex=female
        // https://openWith?name=lisa&sex=female
        DYDeepLink.handleOpenURL(url: URL(string: "deepLink://content?name=Lisa&sex=female")!)
        DYDeepLink.handleOpenURL(url: URL(string: "https://openWith?name=Lisa&sex=female")!)
        
        //https://www.google.com/test?name=lisa&sex=female
        DYDeepLink.handleOpenURL(url: URL(string: "https://www.google.com/test?name=Lisa&sex=female")!)
        
        // deepLink://content/path?name=lisa&sex=female
        // https://openWith/path?name=lisa&sex=female
        DYDeepLink.handleOpenURL(url: URL(string: "deepLink://content/path?name=Lisa&sex=female")!)
        DYDeepLink.handleOpenURL(url: URL(string: "https://openWith/path?name=Lisa&sex=female")!)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
