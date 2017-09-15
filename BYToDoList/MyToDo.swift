//
//  MyToDo.swift
//  BYToDoList
//
//  Created by Mac on 2017/9/9.
//  Copyright © 2017年 Mac. All rights reserved.
//

import Foundation

class ToDoItem{
    var title: String
    var time: String
    var done: Bool
    public init(title: String,time: String) {
        self.title = title
        self.done = false
        self.time = time
    }
}
