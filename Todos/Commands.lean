import Lean
import Todos.Basic

open Lean Elab Command

syntax (name := addUndoneTodoCmd) "[_] " str : command

syntax (name := addDoneTodoCmd) "[x] " str : command

elab_rules : command
  | `([_] $name) => do
    let item := { name := name.getString, done := false }
    todosRef.modify (fun items => items.push item)
    logInfo s!"Added todo: {item.name}"
  | `([x] $name) => do
    let item := { name := name.getString, done := true }
    todosRef.modify (fun items => items.push item)
    logInfo s!"Added done todo: {item.name}"

syntax (name := listTodosCmd) "list_todos" : command

elab_rules : command
  | `(list_todos) => do
    let todos ← getTodos
    if todos.isEmpty then
      logInfo "No todos found."
    else
      logInfo "Todo List:"
      for item in todos do
        let status := if item.done then "[x]" else "[_]"
        logInfo s!"{status} {item.name}"
      -- for (i, item) in todos.indexed do
      --   let status := if item.done then "[x]" else "[_]"
      --   logInfo s!"{i + 1}. {status} {item.name}"


/-
syntax (name := myCmd) "greet " str : command

elab_rules : command
  | `(greet $name) => do
    logInfo s!"Hello, {name.getString}!"
-/
