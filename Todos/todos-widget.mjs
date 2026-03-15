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

async function toggleItem(editorCtx, item) {
  const uri = "file://" + item.source.fileName;
  await editorCtx.api.applyEdit({
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
              character: item.source.startPos.column + 3,
            },
          },
          newText: item.done ? "[_]" : "[x]",
        },
      ],
    },
  });
}

function TodoItem({ item, onChange }) {
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
      onClick: async () => {
        await toggleItem(editorCtx, item);
        onChange();
      },
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

function TodosList({ todos, onChange }) {
  return e(
    "ul",
    null,
    todos.map((item, index) => e(TodoItem, { key: index, item, onChange })),
  );
}

export default function (props) {
  const rs = useRpcSession();
  const [refreshIndex, setRefreshIndex] = React.useState(0);
  const st = useAsync(
    () => rs.call("getTodosRpc", { pos: props.pos }),
    [props.pos, refreshIndex],
  );

  const onChange = () => {
    setRefreshIndex((i) => i + 1);
  };

  return st.state === "resolved"
    ? st.value && e(TodosList, { todos: st.value, onChange })
    : st.state === "rejected"
      ? e("p", null, mapRpcError(st.error).message)
      : e("p", null, "Loading...");
}
