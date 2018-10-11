//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    public func convert(_ to: String) -> Money {
        switch currency{
        case "USD":
            switch to{
            case "GBP":
                return Money(amount: amount/2, currency: "GBP")
            case "EUR":
                return Money(amount: Int(Double(amount)*1.5), currency: "EUR")
            case "CAN":
                return Money(amount: Int(Double(amount)*1.25), currency: "CAN")
            default:
                return Money(amount: amount, currency: currency)
            }
        case "GBP":
            switch to{
            case "USD":
                return Money(amount: amount*2, currency: "USD")
            case "EUR":
                return Money(amount: Int(Double(amount*2)*1.5), currency: "EUR")
            case "CAN":
                return Money(amount: Int(Double(amount*2)*1.25), currency: "CAN")
            default:
                return Money(amount: amount, currency: currency)
            }
        case "EUR":
            switch to{
            case "USD":
                return Money(amount: Int(Double(amount)/1.5), currency: "USD")
            case "GBP":
                return Money(amount: Int(Double(amount)/1.5)/2, currency: "GBP")
            case "CAN":
                return Money(amount: Int((Double(amount)/1.5)*1.25), currency: "CAN")
            default:
                return Money(amount: amount, currency: currency)
            }
        case "CAN":
            switch to{
            case "USD":
                return Money(amount: Int(Double(amount)/1.25), currency: "USD")
            case "GBP":
                return Money(amount: Int(Double(amount)/1.25)/2, currency: "GBP")
            case "EUR":
                return Money(amount: Int((Double(amount)/1.25)*1.5), currency: "EUR")
            default:
                return Money(amount: amount, currency: currency)
            }
        default:
            return Money(amount: amount, currency: currency)
        }
        
    }
  
    public func add(_ to: Money) -> Money {
        var sum = self.amount + to.amount;
        
        if(self.currency != to.currency){
            let converted = self.convert(to.currency)
            sum = converted.amount + to.amount
        }
        
        return Money(amount: sum, currency:to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        var sum = from.amount - self.amount;
        
        if(self.currency != from.currency){
            let converted = self.convert(from.currency)
            sum = from.amount - converted.amount
        }
        
        return Money(amount: sum, currency:from.currency)
    }
}



////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title;
    self.type = type;
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    
    switch self.type{
    case .Salary(let num):
        return num;
    case .Hourly(let num):
        return Int(num * Double(hours));
    }
    
  }
  
  open func raise(_ amt : Double) {
    switch self.type{
    case .Salary(let num):
        print(Int(Double(num)*amt))
        self.type = Job.JobType.Salary(Int(Double(num)+amt));
    case .Hourly(let num):
        self.type = Job.JobType.Hourly(Double(num)+amt);
    }
  }
}


////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return _job
    }
    set(value) {
        if(self.age >= 16){
            _job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if(self.age >= 18){
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(_job) spouse:\(_spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if(spouse1.spouse == nil && spouse2.spouse == nil){
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if(members[0].age >= 21 || members[1].age >= 21){
        members.append(child)
        return true
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var houseIncome = 0;
    
    for member in members{
        houseIncome += member._job?.calculateIncome(2000) ?? 0
    }
    
    return houseIncome
  }
}

