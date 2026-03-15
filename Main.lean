import Lean
import Todos

import Todos.Examples

open Lean

show_panel_widgets [todosWidget]

[_] "Buy groceries"
[x] "Clean the house"
[_] "Finish homework"

list_todos

def main : IO Unit := do
  for item in current_todos do
    let status := if item.done then "[x]" else "[_]"
    IO.println s!"{status} {item.name}"

#eval main
