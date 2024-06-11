//
//  main.swift
//  TodoCLI
//
//  Created by Marcello Gonzatto Birkan on 10/06/24.
//

import Foundation

struct Todo: Codable {
  var id = UUID()
  let title: String
  var isCompleted: Bool
  
  init(title: String, isCompleted: Bool = false) {
    self.title = title
    self.isCompleted = isCompleted
  }
}

protocol Cache {
  func save(todos: [Todo]) throws
  func load() -> [Todo]
}

final class JSONFileManagerCache: Cache {
  let fileName: String
  
  init(fileName: String = "todos.json") {
    self.fileName = fileName
  }
  
  private var fileURL: URL {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[0].appendingPathComponent(fileName)
  }
  
  func save(todos: [Todo]) throws {
    let data = try JSONEncoder().encode(todos)
    try data.write(to: fileURL, options: .atomic)
  }
  
  func load() -> [Todo] {
      let fileManager = FileManager.default
      if !fileManager.fileExists(atPath: fileURL.path) {
          return []
      }
      
      do {
          let data = try Data(contentsOf: fileURL)
          return try JSONDecoder().decode([Todo].self, from: data)
      } catch {
          print("Error loading todos: \(error)")
          return []
      }
  }
}

final class InMemoryCache: Cache {
  private var todos: [Todo] = []
  
  func save(todos: [Todo]) {
    self.todos = todos
  }
  
  func load() -> [Todo] {
    return todos
  }
}

final class TodoManager {
  var todos = [Todo]()
  private let cache: Cache
  
  init(cache: Cache) {
    self.cache = cache
    self.todos = cache.load()
  }
  
  func listTodos() {
    if todos.isEmpty {
      print("Empty (try add todos)")
    } else {
      print("\nYour Todos:")
      for (i, todo) in todos.enumerated() {
        print("\(i + 1). \(todo.isCompleted ? "✅" : "❌") \(todo.title)")
      }
    }
  }
  
  func addTodo(with title: String) {
    todos.append(Todo(title: title))
    saveTodos()
  }
  
  func toggleCompletition(forTodoAtIndex index: Int) {
    todos[index].isCompleted.toggle()
  }
  
  func deleteTodo(atIndex index: Int) {
    todos.remove(at: index)
    saveTodos()
  }
  
  private func saveTodos() {
    do {
      try cache.save(todos: todos)
    } catch {
      print("Error saving todos: \(error)")
    }
  }
}

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
    let fileCache = JSONFileManagerCache()
    let initialTodos = fileCache.load()
    let inMemoryCache = InMemoryCache()
    inMemoryCache.save(todos: initialTodos)
    let todoManager = TodoManager(cache: inMemoryCache)
    var running = true
    
    
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
        if !todoManager.todos.isEmpty {
          print("Enter the number of the todo: ", terminator: "")
          if let number = getInput() {
            todoManager.toggleCompletition(forTodoAtIndex: Int(number)! - 1)
            print("🔁 Todo completition status toggled!")
          } else {
            printError()
          }
        }
        
      case .delete:
        todoManager.listTodos()
        if !todoManager.todos.isEmpty {
          print("Enter the number of the todo: ", terminator: "")
          if let number = getInput() {
            todoManager.deleteTodo(atIndex: Int(number)! - 1)
          } else {
            printError()
          }
        }
        
      case .exit:
        do {
          try fileCache.save(todos: todoManager.todos)
          print("Todos saved to disk.")
        } catch {
          print("Error saving todos to disk: \(error)")
        }
        running.toggle()
      case .invalid:
        printError()
      }
    }
  }
}

App().run()
