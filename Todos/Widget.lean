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
  javascript := "
import * as React from 'react';
const e = React.createElement;
import { useRpcSession, InteractiveCode, useAsync, mapRpcError } from '@leanprover/infoview';

function TodosList(props) {
  const todos = props.todos || [];
  return e('ul', null, todos.map((item, index) =>
    e('li', { key: index },
      e('input', { type: 'checkbox', checked: item.done, readOnly: true }),
      ' ',
      item.name)
  ));
}

export default function(props) {
  const rs = useRpcSession();

  const st = useAsync(() => rs.call('getTodosRpc', {}), []);

  return st.state === 'resolved' ? st.value && e(TodosList, {todos: st.value})
    : st.state === 'rejected' ? e('p', null, mapRpcError(st.error).message)
    : e('p', null, 'Loading...');
}
"
