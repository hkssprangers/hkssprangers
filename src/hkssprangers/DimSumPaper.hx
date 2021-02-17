package hkssprangers;
using StringTools;
using Lambda;

class DimSumPaper {
    static final headers = {
        var headers = [];
        var col = "A";
        for (i => v in CompileTime.readFile("DimSumPaper.tsv").trim().split("\n")[0].split("\t")) {
            headers.push({
                idx: i,
                col: col,
                val: v,
            });
            col = nextCol(col);
        }
        headers;
    }
    static final productCols = headers.slice(headers.findIndex(h -> h.col == "B"), headers.findIndex(h -> h.col == "AI") + 1);

    static function nextCol(col:String):String {
        var last = col.charCodeAt(col.length - 1);
        return if (last + 1 > "Z".code)
            [for (_ in 0...col.length + 1) "A"].join("");
        else
            col.substr(0, col.length - 1) + String.fromCharCode(last + 1);
    }

    static function price(str:String):Float {
        var r = ~/\$([0-9]+)/;
        if (!r.match(str))
            throw "no price in " + str;
        return Std.parseInt(r.matched(1));
    }

    static function cols(from:String, to:String):Array<String> {
        var a = [];
        var col = from;
        while (true) {
            a.push(col);
            if (col == to)
                break;
            col = nextCol(col);
        }
        return a;
    }

    static function main() {
        var rows = [
            for (p in productCols)
            'IF(ISBLANK(form!${p.col}2), "", form!${p.col}$$1 & " x " & form!${p.col}2 & CHAR(10))'
        ];
        trace("=" + rows.join("&"));

        var prices = productCols.map(p -> price(p.val));
        var pRange = "form!" + productCols[0].col + "2:form!" + productCols[productCols.length-1].col + "2";
        var sum = '=SUMPRODUCT({${prices.join(",")}}, ${pRange})';
        trace(sum);
    }
}