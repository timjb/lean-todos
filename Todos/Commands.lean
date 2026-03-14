import Lean
import Todos.Basic

open Lean Elab Command

syntax (name := addTodoCmd) ("[_] " <|> "[x] ") str : command

def elabTodo (name : String) (done : Bool) : CommandElabM Unit := do
  let fileName ← getFileName
  let stx ← getRef
  let fileMap ← getFileMap
  let rawPosToSourcePos (rawPos : String.Pos.Raw) : SourcePos :=
    let p := fileMap.toPosition rawPos
    { line := p.line, column := p.column }
  let source : Option SourceRange := do
    pure $ {
      fileName := fileName,
      startPos := rawPosToSourcePos (← stx.getPos?),
      endPos   := rawPosToSourcePos (← stx.getTailPos?)
    }
  addTodo ({ name, done, source })

elab_rules : command
  | `([_] $name) => elabTodo name.getString (done := false)
  | `([x] $name) => elabTodo name.getString (done := true)

syntax (name := listTodosCmd) "list_todos" : command

elab_rules : command
  | `(list_todos) => do
    let todos ← getTodos
    if todos.isEmpty then
      logInfo "No todos found."
    else
      let mut msg := "Todo List:\n"
      for item in todos do
        let status := if item.done then "[x]" else "[_]"
        msg := msg ++ s!"\n{status} {item.name}"
      logInfo msg
