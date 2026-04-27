import Lean
import Todos.Types

open Lean

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
