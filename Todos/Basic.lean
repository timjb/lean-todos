import Lean

open Lean Json

structure SourcePos where
  line     : Nat
  column   : Nat
  deriving FromJson, ToJson

structure SourceRange where
  fileName : String
  startPos : SourcePos
  endPos   : SourcePos
  deriving FromJson, ToJson

structure TodoItem where
  name : String
  done : Bool
  source : Option SourceRange := none
  deriving FromJson, ToJson

initialize todosRef : IO.Ref (Array TodoItem) ← IO.mkRef #[]

def addTodo (item : TodoItem) : IO Unit := do
  todosRef.modify $ fun items =>
    items
      |>.filter (fun i => i.name != item.name)
      |>.push item

def getTodos : IO (Array TodoItem) := do
  todosRef.get
