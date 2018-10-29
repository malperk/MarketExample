//
//  MoyaHudPlugin.swift
//  StoreExample
//
//  Created by Alper KARATAS on 10/23/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

import Foundation
import Result
import Moya

/// Notify a request's network activity changes (request begins or ends).
public final class MoyaHudPlugin: PluginType {
    // MARK: Plugin
    /// Called by the provider as soon as the request is about to start
    public func willSend(_ request: RequestType, target: TargetType) {
        HUD.shared.show(animate: true)
    }
    
    /// Called by the provider as soon as a response arrives, even if the request is canceled.
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        HUD.shared.dismiss(animate: true)
    }
}

