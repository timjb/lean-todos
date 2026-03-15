import Lean
import Todos.Types

open Lean

/-
initialize todosRef : IO.Ref (Array TodoItem) ← IO.mkRef #[]

def addTodo (item : TodoItem) : IO Unit := do
  todosRef.modify $ fun items =>
    items
      |>.filter (fun i => i.name != item.name)
      |>.push item

def getTodos : IO (Array TodoItem) := do
  todosRef.get
-/

initialize todosExtension :
    SimplePersistentEnvExtension TodoItem (List TodoItem) ←
  registerSimplePersistentEnvExtension {
    addEntryFn := (·.cons)
    addImportedFn := mkStateFromImportedEntries (·.cons) {}
  }

def addTodo {m} [Monad m] [MonadEnv m] (item : TodoItem) : m Unit := do
  modifyEnv fun env => todosExtension.addEntry env item

def getTodos {m} [Monad m] [MonadEnv m] : m (List TodoItem) := do
  pure (todosExtension.getState (← getEnv)).reverse

  -- todosRef.modify $ fun items =>
  --   items
  --     |>.filter (fun i => i.name != item.name)
  --     |>.push item
