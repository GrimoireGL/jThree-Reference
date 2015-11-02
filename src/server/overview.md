# title1
## subtitle1-1
## subtitle1-2
## subtitle1-3
## subtitle1-4
## subtitle1-5

# title2
## subtitle2-1
## subtitle2-2
## subtitle2-3
## subtitle2-4
## subtitle2-5
## subtitle2-6
## subtitle2-7

```javascript
var rps = (function () {
    'use strict';

    var Rational = (function () {

        function Rational(n, d) {
            function gcd(x, y) {
                if (y === 0) {
                    return Math.abs(x);
                }
                return gcd(y, x % y);
            }
            var g = gcd(n, d);

            this.n = n / g;
            this.d = d / g;
        }

        Rational.prototype.negative = function () { 
            return new Rational(-this.n, this.d);
        };
        Rational.prototype.inverse = function () {
            return new Rational(this.d, this.n);
        };

        Rational.prototype.plus = function (rational) {
            return new Rational(
                this.n * rational.d + rational.n * this.d,
                this.d * rational.d
            );
        };
        Rational.prototype.minus = function (rational) {
            return this.plus(rational.negative());
        };
        Rational.prototype.multiply = function (rational) {
            return new Rational(
                this.n * rational.n,
                this.d * rational.d
            );
        };
        Rational.prototype.div = function (rational) {
            return this.multiply(rational.inverse());
        };

        Rational.prototype.equals = function (rational) {
            return this.toNumber() === rational.toNumber();
        };

        Rational.prototype.toString = function () {
            return this.n + '/' + this.d;
        };
        Rational.prototype.toNumber = function () {
            return this.n / this.d;
        };

        Rational.zero = new Rational(0, 1);
        Rational.one = new Rational(1, 1);

        return Rational;
    })();

    var Table = (function () {
        function Table() {
            var self = this;
            keys.forEach(function (key) {
                self[key] = Rational.zero;
            });
        }

        Table.prototype.plus = function (table) {
            var self = this, result = new Table();
            keys.forEach(function (key) {
                result[key] = self[key].plus(table[key]);
            });
            return result;
        };
        Table.prototype.sum = function () {
            var self = this, sum = Rational.zero;
            keys.forEach(function (key) {
                sum = sum.plus(self[key]);
            });
            return sum;
        };
        Table.prototype.normalize = function () {
            var self = this, sum = self.sum();
            if (sum.equals(Rational.zero)) { return self; }
            keys.forEach(function (key) {
                self[key] = self[key].div(sum);
            });
            return self;
        };

        Table.prototype.toString = function () {
            var self = this, result = '';
            keys.forEach(function (key) {
                result += key + ': ' + self[key] + ', ';
            });
            return result.slice(0, -2);
        };

        return Table;
    })();

    var keys = ['rock', 'paper', 'scissors'],
        history, counter;

    function last(n) {
        if (n === 0) { return ''; }
        return history.slice(-n);
    }
    function count(str) {
        if (str === '') { return 0; }
        return history.split(str).length - 1;
    }

    function esc(table) {
        var result = new Table(), hlen = keys.length,
            len = history.length, count = 0, p;
        table.normalize();

        keys.forEach(function (key) {
            if (!counter[key].equals(Rational.zero)) { count++; }
        });
        if (count === hlen) { return table; }

        p = new Rational(count + 2, 2 * (len + 1));
        keys.forEach(function (key) {
            if (!table[key].equals(Rational.zero)) {
                result[key] = table[key].multiply(Rational.one.minus(p));
            } else {
                result[key] = p.multiply(new Rational(1, hlen - count));
            }
        });
        return result;
    }
    function predict(order) {
        var result = new Table(), table = new Table(), i;
        if (order === 0) { order = Infinity; }
        else if (!order) { order = 4; }

        for (i = 0; i < order; i++) {
            keys.forEach(function (key) {
                table[key] = new Rational(count(last(i) + key[0]), 1);
            });

            if (table.sum().equals(Rational.zero)) { break; }
            result = result.plus(table.normalize());
        }

        return esc(result);
    }

    function toString(order) {
        return '"' + history + '"\n' + predict(order);
    }
    function log() {
        print(toString());
    }
    function push(key) {
        if (key in counter) {
            history += key[0];
            counter[key] = counter[key].plus(Rational.one);
        }
        log();
    }

    function init() {
        history = '';
        counter = new Table();
        log();
    }
    init();

    return (function (rps) {
        rps.predict = function () { return predict(); };
        rps.toString = function () { return toString(); };

        Object.defineProperty(rps, 'init', {
            get: function () {
                init();
                return rps;
            },
            enumerable: true
        });

        keys.forEach(function (key) {
            Object.defineProperty(rps, key, {
                get: function () {
                    push(key);
                    return rps;
                },
                enumerable: true
            });
        });

        return rps;
    })(function rps() { return rps; });

})();

// グー, パー, グー の次まで予測
rps.rock().paper().rock();

// 初期化
rps.init();

// 括弧要らない
rps.rock.paper.rock;
```

# title3
## subtitle3-1
## subtitle3-2
## subtitle3-3

# title4
## subtitle4-1
## subtitle4-2
## subtitle4-3
## subtitle4-4
## subtitle4-5

# title5
## subtitle5-1
## subtitle5-2
## subtitle5-3
## subtitle5-4
## subtitle5-5

# title6
## subtitle6-1
## subtitle6-2
## subtitle6-3
## subtitle6-4
## subtitle6-5

# title7
## subtitle7-1
## subtitle7-2
## subtitle7-3
## subtitle7-4
## subtitle7-5
