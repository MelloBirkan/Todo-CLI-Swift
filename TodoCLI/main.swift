//
//  main.swift
//  TodoCLI
//
//  Created by Marcello Gonzatto Birkan on 10/06/24.
//

import Foundation

// * Create the `Todo` struct.
// * Ensure it has properties: id (UUID), title (String), and isCompleted (Bool).
struct Todo {
  let id = UUID()
  let title: String
  var isCompleted: Bool
  
  init(title: String, isCompleted: Bool = false) {
    self.title = title
    self.isCompleted = isCompleted
  }
}

// Create the `Cache` protocol that defines the following method signatures:
//  `func save(todos: [Todo])`: Persists the given todos.
//  `func load() -> [Todo]?`: Retrieves and returns the saved todos, or nil if none exist.
protocol Cache {
  func save(todos: [Todo])
  func load() -> [Todo]
}

// `FileSystemCache`: This implementation should utilize the file system
// to persist and retrieve the list of todos.
// Utilize Swift's `FileManager` to handle file operations.
//final class JSONFileManagerCache: Cache {
//  
//}
//
//// `InMemoryCache`: : Keeps todos in an array or similar structure during the session.
//// This won't retain todos across different app launches,
//// but serves as a quick in-session cache.
//final class InMemoryCache: Cache {
//  
//}

// The `TodosManager` class should have:
// * A function `func listTodos()` to display all todos.
// * A function named `func addTodo(with title: String)` to insert a new todo.
// * A function named `func toggleCompletion(forTodoAtIndex index: Int)`
//   to alter the completion status of a specific todo using its index.
// * A function named `func deleteTodo(atIndex index: Int)` to remove a todo using its index.
final class TodoManager {
  var todos = [Todo]()
  
  func listTodos() {
    if todos.isEmpty {
      print("Empty (try add todos)")
    }
    print("\nYour Todos:")
    for (i, todo) in todos.enumerated() {
      print("\(i + 1). \(todo.isCompleted ? "✅" : "❌") \(todo.title)")
    }
  }
  
  func addTodo(with title: String) {
    todos.append(Todo(title: title))
  }
  
  func toggleCompletition(forTodoAtIndex index: Int) {
    todos[index].isCompleted.toggle()
  }
  
  func deleteTodo(atIndex index: Int) {
    todos.remove(at: index)
  }
}


// * The `App` class should have a `func run()` method, this method should perpetually
//   await user input and execute commands.
//  * Implement a `Command` enum to specify user commands. Include cases
//    such as `add`, `list`, `toggle`, `delete`, and `exit`.
//  * The enum should be nested inside the definition of the `App` class
final class App {
  enum Command: String {
    case add, list, toggle, delete, exit, invalid
    
    init(_ rawValue: String) {
      switch rawValue {
      case "add": self = .add
      case "list": self = .list
      case "toggle": self = .toggle
      case "delete": self = .delete
      case "exit": self = .exit
      default: self = .invalid
      }
    }
  }
  
  func printMenu() {
    print("What would you like to do? (add, list, toggle, delete, exit): ", terminator: "")
  }
  
  func getInput() -> String? {
    return readLine()
  }
  
  func printError() {
    print("Invalid input. Please try again.")
  }
  
  func run() {
    var running = true
    var todoManager = TodoManager()
    
    while running {
      printMenu()
      guard let choice = getInput() else {
        printError()
        continue
      }
      
      let menuOption = Command(choice)
      
      switch menuOption {
      case .add:
        print("Enter todo title: ", terminator: "")
        if let title = getInput() {
          todoManager.addTodo(with: title)
        } else {
          printError()
        }
      case .list:
        todoManager.listTodos()
      case .toggle:
        todoManager.listTodos()
        print("Enter the number of the todo: ", terminator: "")
        if let number = getInput() {
          todoManager.toggleCompletition(forTodoAtIndex: Int(number)! - 1)
          
        } else {
          printError()
        }
        
      case .delete:
        todoManager.listTodos()
        print("Enter the number of the todo: ", terminator: "")
        if let number = getInput() {
          todoManager.deleteTodo(atIndex: Int(number)! - 1)
        } else {
          printError()
        }
      case .exit:
        running.toggle()
      case .invalid:
        printError()
      }
    }
  }
  
}


// TODO: Write code to set up and run the app.
App().run()
