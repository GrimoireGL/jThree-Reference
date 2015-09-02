# Questions  
## 問1 - 型と変数と演算子 -  

  * 次の実行結果を理由をつけて答えよ：  

  ```javascript  
    console.log('hello' + " world"); // (i)  
    console.log(1 + 2 + "3" + 4); // (ii)  
    console.log(1 + 2 == 3);      // (iii)  
    console.log(1 + "2" == "12"); // (v)  
    console.log(1 + "2" == 12);   // (vi)  
    console.log(1 + "2" === 12);  // (v)  
    console.log(true === 1 + 2 * 8 < 6 / 3 / 2 + 2 * 2 * 4); // (vii)  
    var x = 0;  
    var y = 4;  
    console.log(x == 2 || y == 4);// (viii)  
    console.log(x == 0 && false); // (ix)  
    console.log(x == y);          // (x)  
    console.log(x = y = 8);       // (xi)  
    x = 0;  
    console.log(1 < x < 9);       // (xii)  
    console.log(z);               // (xiii)  
  ```  

## 問2 - 配列とfunction式 -  

  * 次の実行結果を理由をつけて答えよ：  

  ```javascript  
    var ary = [ 1,4,2,1,6,8,4 ];  
    console.log(ary[3]);         // (i)  
    console.log(ary.length);     // (ii)  
    ary[71] = 789;  
    console.log(ary.length);     // (iii)  

    function add7(num) {  
        return num + 7;  
    }  
    var square = function(x) {  
        return x * x;  
    };  
    console.log(square(add7(3))); // (iv)  

    function minus(a) {  
        return function (b) {  
            return a - b;  
        };  
    }  
    console.log(minus(3)(7));     // (v)  
    
    (function () {  
        var x = 3;  
    }());  
    console.log(x);               // (vi)  
  ```  

## 問3 - 制御構文 -  

  1. 1,2,...,50 の数値に対して、"3の倍数" または "3のつく数字" の時だけアホになって出力するプログラムを作りなさい。  
  1. n!(=n*(n-1)*...*2*1)を求めるプログラムを、(i)for文で (ii)再帰的定義で 作成しなさい  
  1. [ 4,7,2,4,9,0,3 ] のような配列を、値の小さい順に並び変えるプログラムを作成しなさい  
  1. 上の問題で作成したある1文を変えることによって、ランダムな順序の配列を返すプログラムを作成しなさい  
  1. 以下のアルゴリズムで小さい順にソートをするクソプログラムを作成しなさい：  
    I. ある配列が小さい順になってるかどうか確認する  
    II. 小さい順になっていたら処理終了、なっていなかったらその配列をランダムにして I. へ戻る  
  1. for文を用いて、以下のように出力するようなプログラムを作成しなさい：  

    i.  
    
      ```  
      1 1 1 1 0 0 0 0  
      1 1 1 1 0 0 0 0  
      1 1 1 1 0 0 0 0  
      1 1 1 1 0 0 0 0  
      0 0 0 0 1 1 1 1  
      0 0 0 0 1 1 1 1  
      0 0 0 0 1 1 1 1  
      0 0 0 0 1 1 1 1  
      ```  
    ii.  
    
      ```  
      1 1 0 0 0 0 0 0  
      1 1 1 0 0 0 0 0  
      0 1 1 1 0 0 0 0  
      0 0 1 1 1 0 0 0  
      0 0 0 1 1 1 0 0  
      0 0 0 0 1 1 1 0  
      0 0 0 0 0 1 1 1  
      0 0 0 0 0 0 1 1  
      ```  
    iii.  
    
      ```  
      1 0 1 0 1 0 1 0  
      0 1 0 1 0 1 0 1  
      1 0 1 0 1 0 1 0  
      0 1 0 1 0 1 0 1  
      1 0 1 0 1 0 1 0  
      0 1 0 1 0 1 0 1  
      1 0 1 0 1 0 1 0  
      0 1 0 1 0 1 0 1  
      ```  
      
    iv.  
    
      ```  
      1 1 1 1 1 1 1 1  
      0 0 0 0 0 0 0 1  
      1 1 1 1 1 1 0 1  
      1 0 0 0 0 1 0 1  
      1 0 1 1 0 1 0 1  
      1 0 1 1 1 1 0 1  
      1 0 0 0 0 0 0 1  
      1 1 1 1 1 1 1 1  
      ```  

## 問4 - 単純な関数の作成練習 -  
  お前らちゃんとreturnしてくれよー  

  1. 以下を仕様とする関数を作りなさい  

    仕様▼  
    関数名:printSubtraction  
    引数:num1,num2  
    返り値:無し  
    説明:num1とnum2の引き算した値を表示する関数  

  1. 以下を仕様とする関数を作りなさい  

    仕様▼  
    関数名:nthTableOfMultiplication  
    引数:整数n (表示させる段の番号)  
    返り値:配列table  
    説明:掛け算の表のうち、n段目のものを配列で返す関数  

  1. 以下を仕様とする関数を作りなさい  

    仕様▼  
    関数名:f  
    引数:実数x  
    返り値:実数fx  
    説明: `fx = x*x*x - 3*x`とし、計算してfxを返す関数  

  1. 以下を仕様とする関数を作りなさい  

    仕様▼  
    関数名:isEven  
    引数:整数num  
    返り値:true/false  
    説明:numが偶数かを判定し、偶数ならtrueを、奇数ならfalseを返す関数  
    

## 問5 - オブジェクト -  

  以下のコードは『分数を表すオブジェクト』を、分子分母を引数として生成する関数である。

  1. 実行結果を答えよ

  ```javascript  
    function fraction(child, mother) {  
        // ①  
        return {  
            child: child,  
            mother: mother,  
            plus: function (other) { return fraction(other.child*this.mother + this.child*other.mother, this.mother*other.mother); },  
            minus: function (other) { return this.plus(other.flipSign()); },  
            flipSign: function () { return fraction(-child, mother); }  
        };  
    }  
    function printFraction(frac) {  
        console.log(frac.child + " / " + frac.mother);  
    }  

    var a = fraction(1, 2);  
    var b = fraction(3, 4);  
    printFraction(a.minus(b));    // 表示されるものを答えよ  
  ```  

  1. 上のコードに、以下のメソッド(オブジェクトが持つ関数のこと)を追加せよ:  

    i. * (.multiply(other))  
    ii. 逆数を求めるメソッド (.flipFracVal())  
    iii. / (.divide(other))  
    iv. 分子と分母の最大公約数を求める関数 (gcd(child, mother))  
      ただし、この関数は上の①の位置に書きなさい。  
      可能なら、ユークリッドの互除法を使いなさい (p = mq + r のpとqの最大公約数 == qとrの最大公約数 (両辺をqで割ったとき、p/qとmが整数だからr/qも整数だよね？って原理))  
    v. 約分を行うメソッド (.reduction())  

## 問6 - ゲーム制作 -  

  * 12*2枚で行う神経衰弱を作ろう。以下のものを作れば多分完成する：  

    1. 24枚のカードを格納する配列をランダムで自動生成する関数をつくる (例:[2,1,12,5,5,10,8,6,9,10,11,4,1,2,6,3,3,9,12,7,8,4,7,11])  
    
    1. プレイヤーのターンについて記述する。一つ目に引いた数と二つ目のが一致してるか確認したり、選んだカードを表示させたりする。  ただし、神経衰弱のカードを全て表示するときは、以下のように表示すること：  
    
    ```  
      全て見えてるとき：  
      2  1  12 5  5  10 8  6  
      9  10 11 4  1  2  6  3  
      3  9  12 7  8  4  7  11  
      
      全て隠しているとき：  
      *  *  *  *  *  *  *  *  
      *  *  *  *  *  *  *  *  
      *  *  *  *  *  *  *  *  
    ```  
    
    1. 最終的に自分のカードが多い者の勝利とする  