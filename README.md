# TodoCLI - Aplicativo de Lista de Tarefas em Swift

Este é um aplicativo de linha de comando (CLI) para gerenciamento de tarefas, desenvolvido em Swift. O projeto demonstra conceitos importantes de programação como estruturas de dados, protocolos, gerenciamento de arquivos e padrões de design.

## 📚 Como o App Foi Construído

### 1. Estrutura de Dados Base

```swift
struct Todo: Codable {
    var id = UUID()
    let title: String
    var isCompleted: Bool
}
```

Esta estrutura representa uma tarefa individual com:
- Um identificador único (UUID)
- Um título
- Um status de conclusão

### 2. Sistema de Cache

Implementamos dois tipos de cache usando o protocolo `Cache`:

```swift
protocol Cache {
    func save(todos: [Todo]) throws
    func load() -> [Todo]
}
```

#### a) JSONFileManagerCache
- Salva as tarefas em um arquivo JSON no sistema de arquivos
- Persiste os dados entre execuções do aplicativo
- Utiliza `FileManager` para gerenciar o armazenamento

#### b) InMemoryCache
- Mantém as tarefas na memória durante a execução
- Mais rápido para operações frequentes
- Os dados são perdidos quando o aplicativo é fechado

### 3. Gerenciador de Tarefas

O `TodoManager` é responsável por:
- Manter a lista de tarefas
- Executar operações (adicionar, listar, alternar status, deletar)
- Interagir com o sistema de cache

### 4. Interface do Usuário

A classe `App` gerencia:
- O loop principal do programa
- Processamento de comandos do usuário
- Exibição do menu e mensagens
- Integração com o TodoManager

## 🚀 Como Usar o App

### Comandos Disponíveis:

1. **add**: Adiciona uma nova tarefa
   ```bash
   > add
   Enter todo title: Comprar leite
   ```

2. **list**: Mostra todas as tarefas
   ```bash
   > list
   Your Todos:
   1. ❌ Comprar leite
   2. ✅ Fazer exercícios
   ```

3. **toggle**: Alterna o status de uma tarefa
   ```bash
   > toggle
   [lista de tarefas aparece]
   Enter the number of the todo: 1
   ```

4. **delete**: Remove uma tarefa
   ```bash
   > delete
   [lista de tarefas aparece]
   Enter the number of the todo: 1
   ```

5. **exit**: Salva e fecha o aplicativo

### Símbolos:
- ❌ : Tarefa não concluída
- ✅ : Tarefa concluída

## 💻 Como Executar

1. Certifique-se de ter o Swift instalado em seu sistema
2. Clone este repositório
3. No terminal, navegue até a pasta do projeto
4. Execute o comando:
   ```bash
   swift run
   ```

## 🔧 Requisitos do Sistema

- macOS com Swift instalado
- Xcode (opcional, para desenvolvimento)

## 📝 Notas

- As tarefas são salvas automaticamente após cada operação
- Ao sair do programa usando o comando `exit`, todas as tarefas são persistidas no arquivo JSON
- Em caso de erro ao carregar o arquivo, o programa iniciará com uma lista vazia 