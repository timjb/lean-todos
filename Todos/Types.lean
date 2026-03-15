import Lean

open Lean Json

structure SourcePos where
  line     : Nat
  column   : Nat
  deriving FromJson, ToJson

instance : Quote SourcePos where
  quote p := Syntax.mkCApp ``SourcePos.mk #[(quote p.line), (quote p.column)]

structure SourceRange where
  fileName : String
  startPos : SourcePos
  endPos   : SourcePos
  deriving FromJson, ToJson

instance : Quote SourceRange where
  quote r := Syntax.mkCApp ``SourceRange.mk #[
    (quote r.fileName),
    (quote r.startPos),
    (quote r.endPos)
  ]

structure TodoItem where
  name : String
  done : Bool
  source : Option SourceRange := none
  deriving FromJson, ToJson

instance : Quote TodoItem where
  quote t := Syntax.mkCApp ``TodoItem.mk #[
    (quote t.name),
    (quote t.done),
    (quote t.source)
  ]
