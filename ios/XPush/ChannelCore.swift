//
//  ChannelCore.swift
//  SampleApp
//
//  Created by James Jung on 2016. 5. 29..
//  Copyright © 2016년 Facebook. All rights reserved.
//

import Foundation
//
//  ChannelCore.swift
//
//
//  Created by James Jung on 2016. 5. 29..
//
//

import Foundation

class ChannelCore: NSObject {
  var socket: SocketIOClient!
  
  var mAppId: String?;
  var mUserId: String?;
  var mDeviceId: String?;
  
  var mChannelId: String?;
  var mServerUrl: String?;
  var mServerName: String?;
  var connectionSuccessCallback: RCTResponseSenderBlock!;
  
  /// Type safe way to create a new SocketIOClient. opts can be omitted
  internal init(mAppId: String, mUserId: String, mDeviceId: String, mChannelId: String, mServerUrl: String, mServerName: String) {
    self.mAppId = mAppId;
    self.mUserId = mUserId;
    self.mDeviceId = mDeviceId;
    self.mChannelId = mChannelId;
    self.mServerUrl = mServerUrl;
    self.mServerName = mServerName;
  };
  
  internal func connect(callback: RCTResponseSenderBlock){
    let url = self.mServerUrl!;
    
    var params:[String:AnyObject] = [String:AnyObject]();
    params["A"] = self.mAppId;
    params["C"] = self.mChannelId;
    params["S"] = self.mServerName;
    params["D"] = self.mDeviceId;
    params["U"] = self.mUserId;
    self.connectionSuccessCallback = callback;
    
    socket = SocketIOClient(socketURL: NSURL(string:url)!, options:[.Log(true), .ForceNew(true), .ConnectParams(params), .Nsp("/channel")] );
    
    socket!.on("connect") {[weak self] data, ack in
      print("socket connected", terminator: "")
      self!.connectionSuccessCallback!(["success"]);
    }
    
    socket!.on("disconnect") { data, ack in
      print("socket disconnected", terminator: "");
      self.connectionSuccessCallback!(["error"]);
    }
    
    socket?.on("message") {[weak self] data, ack in
      if let dt = data[0] as? [String:AnyObject] {
        print(dt);
      }
    }
    
    self.socket.connect();
  };
  
  internal func send(message:String){
    var json:[String:AnyObject] = [String:AnyObject]();
    var data:[String:AnyObject] = [String:AnyObject]();
    var user:[String:AnyObject] = [String:AnyObject]();
    
    user["U"] = self.mUserId;
    data["UO"] = user;
    data["MG"] = message;
    
    json["DT"] = data;
    json["NM"] = "message";
    
    self.socket.emit("send", json );
  }
}