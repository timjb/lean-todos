import Lean

open Lean Json

structure TodoItem where
  name : String
  done : Bool
  deriving FromJson, ToJson

initialize todosRef : IO.Ref (Array TodoItem) ← IO.mkRef #[]

def addTodo (item : TodoItem) : IO Unit := do
  todosRef.modify (fun items => items.push item)

def getTodos : IO (Array TodoItem) := do
  todosRef.get
