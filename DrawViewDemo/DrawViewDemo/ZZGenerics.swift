//
//  ZZGenerics.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/10/24.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit

class ZZGenerics {
    
}

struct Food {
    
}

struct Product {
    var productName = ""
}

struct Money {
    var moneyValue = 0.0
}

protocol Company {
    func buy<T>(product: T, with money: Money)
    func sell<T>(product: T.Type, for money: Money) -> T?
}

protocol Storage {
  associatedtype Item
//associatedtype Item: StorableItem // Constrained associated type
  var items: [Item] { set get }
  mutating func add(item: Item)
  var size: Int { get }
  mutating func remove() -> Item
  func showCurrentInventory() -> [Item]
}

struct SwiftRestaurantStorage: Storage {
    
    typealias Item = Food // Optional

    var items = [Food]()
    
    func add(item: Food) {
        
    }
    
    var size: Int = 10
    
    func remove() -> Food {
        return Food()
    }
    
    func showCurrentInventory() -> [Food] {
        return [Food]()
    }
}


class StackTest {
    func yqTest() {
        var stackOfStrings = Stack<String>()
        stackOfStrings.push("ssssssssss")
    }
}


// Container 协议
protocol Container {
    associatedtype ItemType
    // 添加一个新元素到容器里
    mutating func append(_ item: ItemType)
    // 获取容器中元素的数
    var count: Int { get }
    // 通过索引值类型为 Int 的下标检索到容器中的每一个元素
    subscript(i: Int) -> ItemType { get }
}


struct Stack<Element>: Container {
    // Stack<Element> 的原始实现部分
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    var count: Int {
        return items.count
    }
    // Container 协议的实现部分
    mutating func append(_ item: Element) {
        push(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
