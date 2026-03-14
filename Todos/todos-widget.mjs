import * as React from 'react';
import { useRpcSession, useAsync, mapRpcError, EditorContext } from '@leanprover/infoview';

const e = React.createElement;

function TodosList({ todos }) {
  const editorCtx = React.useContext(EditorContext);
  return e('ul', null, todos.map((item, index) => {
    const jumpToSource = item.source && editorCtx
      ? () => editorCtx.api.showDocument({
          uri: 'file://' + item.source.fileName,
          selection: {
            start: { line: item.source.startPos.line - 1, character: item.source.startPos.column },
            end:   { line: item.source.endPos.line - 1, character: item.source.endPos.column }
          }
        })
      : null;
    return e('li', { key: index },
      e('input', { type: 'checkbox', checked: item.done, readOnly: true }),
      ' ',
      jumpToSource
        ? e('span', { onClick: jumpToSource, style: { cursor: 'pointer', textDecoration: 'underline' } }, item.name)
        : item.name
    );
  }));
}

export default function(props) {
  const rs = useRpcSession();
  const st = useAsync(() => rs.call('getTodosRpc', {}), []);

  return st.state === 'resolved' ? st.value && e(TodosList, { todos: st.value })
    : st.state === 'rejected' ? e('p', null, mapRpcError(st.error).message)
    : e('p', null, 'Loading...');
}