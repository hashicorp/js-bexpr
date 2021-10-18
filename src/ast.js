const pointer = require('json-pointer');
const parse = require('./grammar.js').parse;

class BooleanExpressionAST {
  // =methods

  /**
   * Takes a raw boolean expression string and parses it into an AST.
   */
  constructor(source) {
    this.root = parse(source);
  }
}

class BooleanExpressionEvaluator {
  // =methods

  /**
   * Evalutes an AST against the given context and returns true/false.
   * @param {BooleanExpressionAST} ast
   * @param {object} context
   * @return {boolean}
   */
  evaluate(ast, context) {
    return this.evaluateNode(ast.root, context);
  }

  /**
   * Evaluates a binary expression node.
   * @param {object} node
   * @param {string} node.operator - name of operator (e.g. "equals", "and")
   * @param node.left
   * @param node.right
   * @return {boolean}
   */
  evaluateNode({ operator, left, right }, context) {
    return this[operator](left, right, context);
  }

  /**
   * @param {object} left - binary expression node
   * @param {object} right - binary expression node
   * @param context
   * @return {boolean}
   */
  and(left, right, context) {
    const leftResult = this.evaluateNode(left, context);
    const rightResult = this.evaluateNode(right, context);
    return leftResult && rightResult;
  }

  /**
   * @param {object} left - binary expression node
   * @param {object} right - binary expression node
   * @param context
   * @return {boolean}
   */
  or(left, right, context) {
    const leftResult = this.evaluateNode(left, context);
    const rightResult = this.evaluateNode(right, context);
    return leftResult || rightResult;
  }

  /**
   * @param {string} selector
   * @param {string} value
   * @param context
   * @return {boolean}
   */
  equals(selector, value, context) {
    const realValue = this.lookup(context, selector);
    return realValue == value;
  }

  /**
   * @param {string} selector
   * @param {string} value
   * @param context
   * @return {boolean}
   */
  notEquals(selector, value, context) {
    return !this.equals(...arguments);
  }

  /**
   * @param {string} value
   * @param {string} selector
   * @param context
   * @return {boolean}
   */
  in(value, selector, context) {
    const realValue = this.lookup(context, selector);
    return value?.includes(realValue);
  }

  /**
   * @param {string} value
   * @param {string} selector
   * @param context
   * @return {boolean}
   */
  notIn(value, selector, context) {
    return !this.in(...arguments);
  }

  /**
   * Returns the value in a context found by the given selector.
   * If not found, returns undefined.
   * @param {object} context
   * @param {string} selector
   */
  lookup(context, selector) {
    if (pointer.has(context, selector)) return pointer.get(context, selector);
  }
}

module.exports = {
  BooleanExpressionAST,
  BooleanExpressionEvaluator
};
