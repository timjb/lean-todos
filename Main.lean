import Todos

import Todos.Examples

show_panel_widgets [todosWidget]

[_] "Buy groceries"
[x] "Clean the house"
[_] "Finish homework"

list_todos

def main : IO Unit := do
  IO.println "Hello, Lean!"
  /-
  let todos ← getTodos
  for item in todos do
    let status := if item.done then "[x]" else "[_]"
    IO.println s!"{status} {item.name}"
  -/
