import Lean
import Todos.Basic

open Lean Widget
open Lean IO

structure GetTodosParams where
  deriving Server.RpcEncodable

open Server RequestM in
@[server_rpc_method]
def getTodosRpc (_params : GetTodosParams) : RequestM (RequestTask (Array TodoItem)) := do
  let todos ← getTodos
  pure <| RequestTask.pure todos

@[widget_module]
def todosWidget : Widget.Module where
  javascript := include_str "todos-widget.mjs"
