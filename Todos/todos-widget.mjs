import * as React from "react";
import {
  useRpcSession,
  useAsync,
  mapRpcError,
  EditorContext,
} from "@leanprover/infoview";

const e = React.createElement;

function jumpToSource(editorCtx, source) {
  editorCtx.api.showDocument({
    uri: "file://" + source.fileName,
    selection: {
      start: {
        line: source.startPos.line - 1,
        character: source.startPos.column,
      },
      end: { line: source.endPos.line - 1, character: source.endPos.column },
    },
  });
}

function toggleItem(editorCtx, item) {
  const uri = "file://" + item.source.fileName;
  editorCtx.api.applyEdit({
    changes: {
      [uri]: [
        {
          range: {
            start: {
              line: item.source.startPos.line - 1,
              character: item.source.startPos.column,
            },
            end: {
              line: item.source.startPos.line - 1,
              character: item.source.startPos.column + 4,
            },
          },
          newText: item.done ? "[_] " : "[x] ",
        },
      ],
    },
  });
}

function TodoItem({ item }) {
  const editorCtx = React.useContext(EditorContext);

  if (!editorCtx || !item.source) {
    return e(
      "li",
      null,
      e("input", { type: "checkbox", checked: item.done, readOnly: true }),
      " ",
      item.name,
    );
  }

  return e(
    "li",
    null,
    e("input", {
      type: "checkbox",
      checked: item.done,
      onClick: () => toggleItem(editorCtx, item),
    }),
    " ",
    e(
      "span",
      {
        onClick: () => jumpToSource(editorCtx, item.source),
        style: { cursor: "pointer", fontWeight: "normal" },
      },
      item.name,
    ),
  );
}

function TodosList({ todos }) {
  return e(
    "ul",
    null,
    todos.map((item, index) => e(TodoItem, { key: index, item })),
  );
}

export default function (props) {
  const rs = useRpcSession();
  const st = useAsync(() => rs.call("getTodosRpc", {}), []);

  return st.state === "resolved"
    ? st.value && e(TodosList, { todos: st.value })
    : st.state === "rejected"
      ? e("p", null, mapRpcError(st.error).message)
      : e("p", null, "Loading...");
}
