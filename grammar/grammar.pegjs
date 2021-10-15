{
  function buildBinaryExpression(operator, left, right) {
    return { operator, left, right };
  }
}

Root
  = _ expression:Expression _ { return expression; }

// =Expressions

Expression
  = BooleanExpression
  / MatchExpression
  / ParentheticalExpression

ParentheticalExpression
  = '(' _ expression:Expression _ ')' {
      return expression;
    }

// =Boolean Expressions
// Boolean Expressions are binary expressions that take two other expressions
// as input.

BooleanExpression
  = AndExpression
  / OrExpression

AndExpression
  = left:(MatchExpression / ParentheticalExpression) _ 'and' _ right:Expression {
      return buildBinaryExpression('and', left, right);
    }

OrExpression
  = left:(MatchExpression / ParentheticalExpression) _ 'or' _ right:Expression {
      return buildBinaryExpression('or', left, right);
    }

// =Match Expressions
// Match expressions are binary expressions that take a string literal and a
// selector as input.

MatchExpression
  = EqualsExpression
  / NotEqualsExpression
  / InExpression
  / NotInExpression

EqualsExpression
  = left:Selector _ '==' _ right:Value {
      return buildBinaryExpression('equals', left, right);
    }

NotEqualsExpression
  = left:Selector _ '!=' _ right:Value {
      return buildBinaryExpression('notEquals', left, right);
    }

InExpression
  = left:Value _ 'in' _ right:Selector {
      return buildBinaryExpression('in', left, right);
    }

NotInExpression
  = left:Value _ 'not in' _ right:Selector {
      return buildBinaryExpression('notIn', left, right);
    }

// =Selectors
// Matches a JSON Pointer selector in the form /part/part/part, except this PEG
// is lazy and treats them as unvalidated strings.  This is fine most of the
// time since selectors are always unambiguous based on their position in an
// expression.  If a selector is malformed, it's a runtime error rather than
// a parse time syntax error.

Selector
  = StringLiteral

// =Values

Value
  = Literal

// =Literals

Literal
  = NullLiteral
  / BooleanLiteral
  / NumberLiteral
  / StringLiteral

BooleanLiteral 'boolean'
  = TrueToken { return true; }
  / FalseToken { return false; }

NullLiteral 'null'
  = NullToken { return null; }

NumberLiteral 'number'
  = literal:DecimalLiteral {
      return literal;
    }

DecimalLiteral
  = DecimalIntegerLiteral '.' DecimalIntegerLiteral {
      return parseFloat(text());
    }
  / '.' DecimalIntegerLiteral {
      return parseFloat(text());
    }
  / DecimalIntegerLiteral {
      return parseFloat(text());
    }

DecimalIntegerLiteral
  = DecimalDigit+
  / SignedInteger

DecimalDigit
  = [0-9]

SignedInteger
  = [+-]? DecimalDigit+

StringLiteral 'string'
  = '"' chars:DoubleStringCharacter* '"' {
      return chars.join('');
    }
  / "'" chars:SingleStringCharacter* "'" {
      return chars.join('');
    }

// =Characters & Sequences

DoubleStringCharacter
  = !('"') SourceCharacter { return text(); }

SingleStringCharacter
  = !("'") SourceCharacter { return text(); }

SourceCharacter
  = .

_
  = WhiteSpace*

WhiteSpace 'whitespace'
  = '\t'
  / '\v'
  / '\f'
  / ' '
  / '\u00A0'
  / '\uFEFF'

// =Tokens

FalseToken      = 'false'
NullToken       = 'null'
TrueToken       = 'true'
