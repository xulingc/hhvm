<?hh

class A {}

// ERROR
<<__Rx>>
function f(Mutable<a> $a): void {
}