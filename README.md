# lean-todos

This is a toy project which demonstrates Lean's metaprogramming and editor integration features, in particular

| Feature               | used for  |
|-----------------------|-----------|
| environment extension | keeping track of todo items across files |
| extensible syntax     | custom syntax for declaring todo items |
| elaborators           | adding todo items to environment extension and recording source position |
| user widgets          | displaying list of all todo items (up to current cursor) with interactive check boxes |