import Lean
import Todos.Types
import Todos.EnvExtension
import Std.Data.Iterators

open Lean Widget
open Lean IO

structure GetTodosParams where
  /-- Position of our widget instance in the Lean file. -/
  pos : Lsp.Position
  deriving Server.RpcEncodable

open Server RequestM in
@[server_rpc_method]
def getTodosRpc (params : GetTodosParams) : RequestM (RequestTask (Array TodoItem)) := do
  let todosTask ← withWaitFindSnapAtPos params.pos fun snap => do
    runTermElabM snap getTodos
  return todosTask.mapCheap (·.map (·.toArray))

@[widget_module]
def todosWidget : Widget.Module where
  javascript := include_str "todos-widget.mjs"
