//
//  SimpleNetworkTests.swift
//  SimpleNetworkTests
//
//  Created by wangqinggong on 15/3/7.
//  Copyright (c) 2015年 Michael King. All rights reserved.
//

import UIKit
import XCTest

class SimpleNetworkTests: XCTestCase {
    
     let net = SimpleNetwork()
     let urlString:String = "http://httpbin.org/get"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testCreatQueryString(){
        let net = SimpleNetwork()
        XCTAssertNil(net.creatQueryString(nil), "查询字符串应该为空")
        XCTAssert(net.creatQueryString(["name":"Michael"])! == "name=Michael", "当查询参数只有一个出错")
        println(net.creatQueryString(["name":"Michael"])!)
    XCTAssert(net.creatQueryString(["title":"boss","name":"Michael"])! == "title=boss&name=Michael", "当查询参数有两个时出错")
        println(net.creatQueryString(["name":"Michael","title":"boss"])!)
    XCTAssert(net.creatQueryString(["book":" iosdevelopment","name":"Michael"])! == "book=%20iosdevelopment&name=Michael", "当有转义字符时出错")
        println(net.creatQueryString(["book":" iosdevelopment","name":"Michael"])!)
    }
    
    func testGetRequest()
    {
       
        let net = SimpleNetwork()
        var r = net.request(.GET, "", nil)
        XCTAssertNil(r, "请求应该为空")
        r = net.request(.POST, "", nil)
        XCTAssertNil(r, "请求应该为空")
        
        
        r = net.request(.GET, urlString, nil)
        println(r)
        XCTAssertNotNil(r, "请求应该被建立")
        
       // XCTAssert(r!.URL!.absoluteString == urlString,"返回的URL不正确")
        r = net.request(.GET, urlString,["name":"Michael"])
        println(r)
        XCTAssert(r!.URL!.absoluteString == urlString + "?name=Michael", "返回的URL不正确")
        
    }
    
    // 测试post请求
    func testPostRequest(){
        let net = SimpleNetwork()
        var r = net.request(.POST, urlString, nil)
        XCTAssertNil(r, "请求应该为空")
        
        r = net.request(.POST, urlString, ["name":"Michael"])
        XCTAssert(r!.HTTPMethod == "POST", "请求不是POST")
        XCTAssert(r!.HTTPBody == "name=Michael".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), "数据体不正确")
        
        
    }
    // 测试实例化失败
    func testRequestError(){
        let net = SimpleNetwork()
        net.requestJSON(.GET, urlString, nil) { (result, error) -> () in
            println(error)
        XCTAssertNotNil(error, "必须返回错误")
        }
        
    }
    
    // 测试请求网络数据方法
    func testRequestJSON()
    {
        // 1.定义一个期望
        let expectation = expectationWithDescription(urlString)
        let net = SimpleNetwork()
        net.requestJSON(.GET, urlString, nil) { (result, error) -> () in
            println(result)
            // 2.期望达成
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10.0, handler: { (error) -> Void in
            XCTAssertNil(error, "应该获得数据的")
        })
    }
    
}
