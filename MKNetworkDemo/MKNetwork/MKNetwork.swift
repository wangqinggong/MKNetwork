//
//  SimpleNetwork.swift
//  SimpleNetwork
//
//  Created by wangqinggong on 15/3/7.
//  Copyright (c) 2015年 Michael King. All rights reserved.
//

import Foundation

// 常用的网络访问方法
public enum HTTPMethod:String{
    case GET = "GET"
    case POST = "POST"
}

public class MKNetwork{
    
   public init(){}
    
    
    // 生成查询字符串
    func creatQueryString(params:[String:String]?)->String?{
        
        // 0.判断字典是否为空
        if params == nil
        {
            return nil
        }
        
        // 1.遍历字典
        // 创建一个数组
        var array = [String]()
        for (k,v) in params!
        {
            let str = k + "=" + v.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            // 添加到数组
            array.append(str)
        }
        return join("&",array)
    }
    
    // 生成网络请求
    func request(method:HTTPMethod,_ urlString:String, _ params:[String:String]?)->NSURLRequest?{
        
       
        
        if urlString.isEmpty
        {
            return nil
        }
        
        var str = urlString
        var r :NSMutableURLRequest?
        
        if method == .GET
        {
            // 获得查询参数
            var queryStr = creatQueryString(params)
            // 拼接成url
            if queryStr != nil
            {
                str += "?" + queryStr!
                
            }
            
            r =  NSMutableURLRequest(URL: NSURL(string: str)!)
        }else
        {
            // 必须要有请求体
            if let body = creatQueryString(params)
            {
                r = NSMutableURLRequest(URL: NSURL(string: str)!)
                r!.HTTPMethod = "POST"
                r!.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            }
        }
        
        return r
    }
    
    //  全局session
    lazy var session:NSURLSession? =
    {
       return  NSURLSession.sharedSession()
    
    }()
    
   // 做网络请求
    // 定义闭包
    public typealias Completion = (result:AnyObject?,error:NSError?)->()
    
   public func requestJSON(method:HTTPMethod, _ urlString:String,_ params: [String:String]?,completion:Completion){
        
        // 实例化网络请求
        if let request = request(method, urlString, params)
        {
            // 从网络上获取数据
            session!.dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
                
                // 如果有错误直接回调
                if error != nil
                {
                completion(result:nil,error:error)
                    return
                }
                
                // 进行数据的反序列化
                let json :AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
                
                // 判断反序列化是否成功
                if (json == nil)
                {
                    let error = NSError(domain: MKNetwork.errorDomain, code: -2, userInfo: ["error":"数据反序列化失败"])
                    completion(result:nil,error:error)
                }else // 有结果
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(result: json, error: nil)
                    })
                }
            }).resume()
            
        }
        
        // 如果请求实例化失败，需要返回错误
        let error = NSError(domain:MKNetwork.errorDomain, code: -1, userInfo: ["error":"网络请求建立失败"])
//        completion(result:nil,error:error)
        
        
    }
    
    static let errorDomain = "cn.baidu.error"

}