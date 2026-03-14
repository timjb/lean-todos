import Todos

[_] "Buy groceries"
[x] "Clean the house"
[_] "Finish homework"

list_todos

#widget todosWidget

def main : IO Unit := do
  let todos ← getTodos
  for item in todos do
    let status := if item.done then "[x]" else "[_]"
    IO.println s!"{status} {item.name}"
