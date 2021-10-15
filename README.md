# js-bexpr

Generic boolean expression evaluation in JavaScript.
Inspired by [go-bexpr](https://github.com/hashicorp/go-bexpr).

js-bexpr is a JavaScript library to provide generic boolean expression
evaluation for JavaScript objects. Under the hood, js-bexpr uses
[json-pointer][json-pointer], meaning that any path within an object that can be
expressed via that library can be used with js-bexpr.

[json-pointer]: https://github.com/manuelstofer/json-pointer

## Usage

```js
const { makeEvaluator } = require('js-bexpr');

const context = {
  foo: {
    x: 5,
    y: 'foo',
    z: true,
    test1: 'yes',
    test2: 'no'
  },
  bar: {
    x: 42,
    y: 'bar',
    z: false,
    test1: 'no',
    test2: 'yes'
  }
};

const expressions = [
  '"/foo/x" == 5',
  '"/bar/y" == "bar"',
  '"/foo/baz" == true',
  // will error in evaluator creation
  '"/bar/test1" != nosuchtoken',
  // will error in evaluator creation
  '"/foo/test2" == nosuchtoken'
];

expressions.forEach((expression) => {
  try {
    const evaluate = makeEvaluator(expression);
    const result = evaluate(context);
    console.log(`Result of expression ${expression} evaluation: ${result}`);
  } catch (e) {
    console.error(`Failed to run evaluation of expression ${expression}: ${e}`);
  }
});
```

This will output:

```
Result of expression "/foo/x" == 5 evaluation: true
Result of expression "/bar/y" == "bar" evaluation: true
Result of expression "/foo/baz" == true evaluation: false
Failed to run evaluation of expression "/bar/hidden" != yes: SyntaxError: Expected boolean, null, number, string, or whitespace but "n" found.
Failed to run evaluation of expression "/foo/unexported" == no: SyntaxError: Expected boolean, null, number, string, or whitespace but "n" found.
```

## Differences from go-bexpr

- Selectors must be quoted strings in JSON pointer format (slashes, not dots).

## Limitations

- The unary `not` operator is not supported.
- Only the following match expressions are currently supported:
  - `==`
  - `!=`
  - `in`
  - `not in`
