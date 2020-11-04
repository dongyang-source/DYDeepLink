//
//  DYDeepLink.swift
//  DYDeepLink
//
//  Created by yangdy on 2020/11/4.
//

import Foundation
class DYDeepLink {
    typealias DeepLinkCallBack = (URL,[String : String]) -> Void
    
    struct HostItem {
        var paths = [String : DeepLinkCallBack]()
        var callBack: DeepLinkCallBack?
    }
    
    static private var schemeItems = [String : [String : HostItem]]()
    static private var callBack: DeepLinkCallBack?
    
//    MARK: - register
    static func registerDeepLinkDefaultHandler(callBack: @escaping DeepLinkCallBack) {
        self.callBack = callBack
    }
    static func registerDeepLink(scheme: String,host: String,paths: [String]? = nil,callBack: @escaping DeepLinkCallBack ) {
        var schemeItem = schemeItems[scheme] ?? [String : HostItem]()
        var hostItem = schemeItem[host] ?? HostItem()
        if paths?.first == nil {
            hostItem.callBack = callBack
        }else {
            paths?.forEach { hostItem.paths[$0] = callBack }
        }
        schemeItem[host] = hostItem
        schemeItems[scheme] = schemeItem
    }
//    MARK: - handle
    static func handleOpenUniversalLink(userActivity: NSUserActivity) {
        guard let webpageURL = userActivity.webpageURL  else {
            return
        }
        DispatchQueue.main.async {
            self.handleOpenURL(url: webpageURL)
        }
    }
    static func handleOpenURL(url: URL) {
        let components =  NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        let scheme = components?.scheme ?? ""
        let host = components?.host ?? ""
        var params = [String : String]()
        components?.queryItems?.forEach { params[$0.name] = $0.value }
        
        var callBack: DeepLinkCallBack?
        if let hostItem = schemeItems[scheme]?[host]  {
            if let path = components?.path , !path.isEmpty {
                callBack = hostItem.paths[path]
            }
            callBack = callBack ?? hostItem.callBack
        }
        callBack = callBack ?? self.callBack
        callBack?(url,params)
    }
}
