import Todos.Types
import Todos.EnvExtension

open Lean

syntax (name := getCurrentTodos) "current_todos" : term

open Lean Elab Term in
elab_rules : term
  | `(current_todos) => do
    let todos ← getTodos
    let todosSyntax ← `(term|$(quote todos.toArray))
    elabTerm todosSyntax none
