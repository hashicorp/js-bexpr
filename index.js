/**
 * Copyright (c) HashiCorp, Inc.
 * SPDX-License-Identifier: MPL-2.0
 */

const {
  BooleanExpressionAST,
  BooleanExpressionEvaluator
} = require('./src/ast.js');

function makeEvaluator(source) {
  const ast = new BooleanExpressionAST(source);
  const evaluator = new BooleanExpressionEvaluator();
  return function evaluate(context) {
    return evaluator.evaluate(ast, context);
  }
}

module.exports = {
  BooleanExpressionAST,
  BooleanExpressionEvaluator,
  makeEvaluator
};
