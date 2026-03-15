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
