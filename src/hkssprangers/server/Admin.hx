package hkssprangers.server;

import haxe.ds.ReadOnlyArray;
import js.lib.Promise;
import js.npm.google_spreadsheet.GoogleSpreadsheet;
import js.npm.google_spreadsheet.GoogleSpreadsheetWorksheet;
import haxe.crypto.Sha256;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import haxe.Json;
import js.npm.express.*;
import hkssprangers.info.Info;
import hkssprangers.server.ServerMain.*;
import hkssprangers.ObjectTools.*;
using Lambda;
using StringTools;
using hkssprangers.server.ExpressTools;
using hkssprangers.MathTools;

typedef User = {
    tg: {
        id:Int,
        username:String,
    },
    isAdmin:Bool,
};

class Admin extends View {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var user(get, never):Null<{
        tg: {
            id:Int,
            username:String,
        }
    }>;
    function get_user() return props.user;

    override public function description() return "平台管理";
    override function canonical() return Path.join([domain, "admin"]);
    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <div>
                <div id="AdminView"
                    data-tg-bot-name=${tgBotName}
                    data-user=${Json.stringify(user)}
                />
            </div>
        ');
    }

    static var menuForm(get, null):Map<Shop<Dynamic>, Promise<GoogleSpreadsheet>>;
    static function get_menuForm() return menuForm != null ? menuForm : menuForm = [
        for (shop => sheetId in [
            YearsHK => "1Jq1AuOc6pG-EuqsGkRj_DS4TWvFXa-r3pGY9DFMqhGk",
            EightyNine => "1Y-yqDQsYO4UeJa4Jxl2ZtZ56Su84cU58TVrm7QpXTHg",
            DragonJapaneseCuisine => "1A_dPdhn6jDGZU-iyDXVKkEdme2VsUZxMUgjZZPa3gMc",
            LaksaStore => "16Jw8bVcW1N87jndk6VQ99E3mBB_H9hxLckM8eIbGpcY",
            DongDong => "1IpJteF-lZ9wd0tSHPgwsVyUuhuWraAdgKnKisYalFb8",
            BiuKeeLokYuen => "1POh9Yy93iyTbm5An_NhQoVWO2QX7GCDcBrs0nZuehKg",
            KCZenzero => "1gHslFNSVO8KOoD6IEcV-mglGoGailUaHr4SbQRSzFOo",
            Neighbor => "15Mzv3r9wTbxpIiJEPbPPwF8O7oP4hQGQ5bksyMuKXHY",
            MGY => "1jbZng_nv2nx3WgY7BV6DfpGz_3AuheVH2VYNOxQCQvM",
        ]) {
            var doc = new GoogleSpreadsheet(sheetId);
            shop => doc.useServiceAccountAuth(GoogleServiceAccount.formReaderServiceAccount)
                .then(_ -> doc.loadInfo())
                .then(_ -> doc);
        }
    ];

    static final hr = "\n--------------------------------------------------------------------------------\n";

    static function getGroupOrders() {
        var doc = new GoogleSpreadsheet("1xcwF-OucoIneLjaajM6b6MOf_waeAE9oeCyTOpzoAJA");
        return doc.useServiceAccountAuth(GoogleServiceAccount.formReaderServiceAccount)
            .then(_ -> doc.loadInfo())
            .then(_ -> doc.sheetsByIndex[0])
            .then(sheet -> {
                sheet.loadCells().then(_ -> {
                    var headers = [
                        for (col in 0...sheet.columnCount)
                        (sheet.getCell(0, col).value:Null<String>)
                    ];
                    var orders = [];
                    for (row in 1...sheet.rowCount)
                    if (sheet.getCell(row, 0).value != null)
                    {
                        var order = {
                            creationTime: null,
                            content: "",
                            wantTableware: null,
                            time: null,
                            contactMethod: null,
                            tg: null,
                            tel: null,
                            paymentMethod: null,
                            address: null,
                            pickupMethod: null,
                            note: null,
                        };
                        var orderContent = [];
                        for (col => h in headers)
                            switch [h, (sheet.getCell(row, col).formattedValue:String)] {
                                case [null, _]:
                                    continue;
                                case ["Timestamp" | "時間戳記", v]:
                                    order.creationTime = v;
                                case [_, null | ""]:
                                    continue;
                                case ["你的地址", v]:
                                    order.address = v;
                                case ["你的聯絡方式 (外賣員會和你聯絡同收款)", v]:
                                    order.contactMethod = if (v.toLowerCase().startsWith("telegram")) {
                                        Telegram;
                                    } else if (v.toLowerCase().startsWith("whatsapp")) {
                                        WhatsApp;
                                    } else {
                                        throw 'Unknown contact method: ' + v;
                                    }
                                case ["你的電話號碼" | "你的電話號碼/Whatsapp", v]:
                                    order.tel = "https://wa.me/852" + v;
                                case ["俾錢方法", v]:
                                    order.paymentMethod = v;
                                case ["交收方法", v]:
                                    order.pickupMethod = v;
                                case ["需要餐具嗎?", v]:
                                    order.wantTableware = v + "餐具";
                                case ["其他備註", v]:
                                    order.note = v;
                                case [h, v] if (h.startsWith("你的Telegram username")):
                                    var r = ~/^@?([A-Za-z0-9_]{5,})$/;
                                    order.tg = if (r.match(v.trim()))
                                        "https://t.me/" + r.matched(1);
                                    else
                                        v;
                                case [h, v] if (h.startsWith("想幾時收到?")):
                                    order.time = v;
                                case [h, v]:
                                    orderContent.push(h + ": " + v);
                            }
                        order.content = orderContent.join("\n");
                        orders.push(order);
                    }
                    orders;
                });
            });
    }

    static function getOrders(shop:Shop<Dynamic>, sheet:GoogleSpreadsheetWorksheet, date:Date, timeSlotType:TimeSlotType) {
        var dateStr = (date.getMonth() + 1) + "月" + date.getDate() + "日";
        function isInTimeSlot(value:String):Bool {
            return value.startsWith(dateStr) && switch (timeSlotType) {
                case Lunch:
                    value.indexOf("午") >= 0;
                case Dinner:
                    value.indexOf("晚") >= 0;
            }
        }
        var headers = [
            for (col in 0...sheet.columnCount)
            (sheet.getCell(0, col).value:Null<String>)
        ];
        return [
            for (row in 1...sheet.rowCount)
            if (sheet.getCell(row, 0).value != null)
            if (isInTimeSlot(sheet.getCell(row, headers.findIndex(h -> h == "想幾時收到?")).value))
            {
                var order = {
                    content: "",
                    iceCream: [],
                    wantTableware: null,
                    time: null,
                    contactMethod: null,
                    tg: null,
                    tel: null,
                    paymentMethod: null,
                    address: null,
                    pickupMethod: null,
                    note: null,
                };
                var orderContent = [];
                var extraOrderContent = [];
                for (col => h in headers)
                switch [shop, h, (sheet.getCell(row, col).value:String)] {
                    case [_, "Timestamp" | "時間戳記" | "叫多份?" | "請選擇類別" | null, _]:
                        null;
                    case [_, _, null | "" | "明白了"]:
                        null;
                    case [_, "想幾時收到?", v]:
                        order.time = v;
                    case [_, "你的地址", v]:
                        order.address = v;
                    case [_, "你的聯絡方式 (外賣員會和你聯絡同收款)", v]:
                        order.contactMethod = if (v.toLowerCase().startsWith("telegram")) {
                            Telegram;
                        } else if (v.toLowerCase().startsWith("whatsapp")) {
                            WhatsApp;
                        } else {
                            throw 'Unknown contact method: ' + v;
                        }
                    case [_, "你的電話號碼" | "你的電話號碼/Whatsapp", v]:
                        order.tel = "https://wa.me/852" + v;
                    case [_, "俾錢方法", v]:
                        order.paymentMethod = v;
                    case [_, "交收方法", v]:
                        order.pickupMethod = v;
                    case [_, "需要餐具嗎?", v]:
                        order.wantTableware = v + "餐具";
                    case [_, "其他備註", v]:
                        order.note = v;
                    case [_, h, v] if (h.startsWith("你的tg username") || h.startsWith("你的Telegram username")):
                        var r = ~/^@?([A-Za-z0-9_]{5,})$/;
                        order.tg = if (r.match(v.trim()))
                            "https://t.me/" + r.matched(1);
                        else
                            v;
                    case [_, _, v] if (v.contains("雪糕")):
                        order.iceCream.push(v);
                    case [_, h, v = "涼拌青瓜拼木耳" | "郊外油菜"]:
                        orderContent.push(h + ": " + v);
                        orderContent.push("套餐附送絲苗白飯2個");
                    case [LaksaStore, "湯底選擇", v]:
                        orderContent.push(v);
                    case [LaksaStore, "配料選擇", v]:
                        orderContent[orderContent.length - 1] += " " + v;
                    case [LaksaStore, "麵類選擇", v]:
                        orderContent[orderContent.length - 1] += " " + v + " $50";
                    case [LaksaStore, "餐飲選擇", v]:
                        orderContent.push(v);
                    case [KCZenzero, "車仔粉主食選擇", v]:
                        orderContent.push(h + ": " + v + " $" + switch (v.split(", ").length) {
                            case 0, 1, 2: 48;
                            case n: 48 + (n - 2) * 5;
                        });
                    case [DongDong, "午餐選擇" | "小菜 - $58" | "以下套餐奉送例湯", v]:
                        orderContent.push(h + ": " + v);
                        extraOrderContent.push("外賣盒 (+$1)");
                    case [BiuKeeLokYuen, "雙併配料選擇", "唔加"]:
                        // pass
                    case [BiuKeeLokYuen, h, v] if (h.endsWith("配料選擇")):
                        orderContent.push(h.substr(0, h.length - "配料選擇".length) + ": " + v);
                    case [BiuKeeLokYuen, "請選擇", v]:
                        orderContent.push(v);
                    case [MGY, "小菜 - $53" | "客飯 / 炒粉飯 / 日式冷麵" | "粉麵選擇 - $43", v]:
                        orderContent.push(v);
                        extraOrderContent.push("外賣盒 (+$1)");
                    case [MGY, "小食選擇", v]:
                        orderContent.push(v);
                    case [_, h, v]:
                        orderContent.push(h + ": " + v);
                }
                switch (shop) {
                    case KCZenzero:
                        extraOrderContent.push("外賣盒 (+$2)");
                    case _:
                        //pass
                }
                order.content = orderContent.concat(extraOrderContent).join("\n");
                order;
            }
        ];
    }

    static final admins:ReadOnlyArray<String> = [
        "andyonthewings",
        "Arbuuuuuuu",
    ];

    static public function ensureAdmin(req:Request, res:Response, next) {
        var tg:Null<{
            id:Int,
            username:String,
        }> = if (req.cookies != null && req.cookies.tg != null) try {
            Json.parse(req.cookies.tg);
        } catch(err) {
            res.status(403).end('Error parsing Telegram login response.\n\n' + err.details());
            return;
        } else null;

        if (tg == null) {
            res.redirect("/login?redirectTo=" + req.originalUrl.urlEncode());
            return;
        }

        if (!TelegramTools.verifyLoginResponse(Sha256.encode(tgBotToken), cast tg)) {
            res.status(403).end('Invalid Telegram login response.');
            return;
        }

        if (
            !admins.exists(adminUsername -> adminUsername.toLowerCase() == tg.username.toLowerCase())
        ) {
            res.status(403).end('${tg.username} (${tg.id}) is not one of the admins.');
            return;
        }

        var user:User = {
            tg: tg,
            isAdmin: true,
        }

        res.locals.user = user;
        next();
    }

    static public function middleware(req:Request, res:Response) {
        var user:User = res.locals.user;
        switch (req.query.group:String) {
            case null:
                // pass
            case groupStr:
                switch (req.accepts(["text", "json"])) {
                    case "text":
                        getGroupOrders()
                            .then(orders -> {
                                [
                                    for (i => o in orders)
                                    {
                                        var totalPrice = parseTotalPrice(o.content);
                                        [
                                            "單號: " + '${i+1}'.lpad("0", 2),
                                            "",
                                            o.content,
                                            o.wantTableware,
                                            o.note != null ? "*其他備註: " + o.note : null,
                                            "",
                                            "食物價錢: $" + totalPrice,
                                            "食物+運費: $" + (totalPrice + 15),
                                            "",
                                            "客人交收時段: " + o.time,
                                            (o.contactMethod == Telegram ? "tg (客人首選):" : "tg: ") + o.tg,
                                            (o.contactMethod == WhatsApp ? "wtsapp (客人首選):" : "wtsapp: ") + o.tel,
                                            o.paymentMethod,
                                        ].filter(l -> l != null).join("\n");
                                    }
                                ].join(hr);
                            })
                            .then(orderStr -> {
                                res.type("text");
                                res.end(orderStr);
                            })
                            .catchError(err -> {
                                res.type("text");
                                res.status(500).end(Std.string(err));
                            });
                        return;
                    case "json":
                        getGroupOrders()
                            .then(orders -> res.json(orders));
                        return;
                    case _:
                        res.type("text");
                        res.status(406).send("Can only return text or json");
                        return;
                }
        }
        switch (req.query.date:String) {
            case null:
                // pass
            case dateStr:
                switch (req.accepts(["text", "json"])) {
                    case "text":
                        pullOrders(Date.fromString(dateStr))
                            .then(orderStr -> {
                                res.type("text");
                                res.end(orderStr);
                            })
                            .catchError(err -> {
                                res.type("text");
                                res.status(500).end(Std.string(err));
                            });
                    // case "json":
                    //     getGroupOrders()
                    //         .then(orders -> res.json(orders));
                    //     return;
                    case _:
                        res.type("text");
                        res.status(406).send("Can only return text or json");
                        return;
                }
                return;
        }
        var tgBotInfo = tgBot.telegram.getMe();
        tgBotInfo.then(tgBotInfo ->
            res.sendView(Admin, {
                tgBotName: tgBotInfo.username,
                user: user,
            }))
            .catchError(err -> res.status(500).json(err));
    }

    static public function parsePrice(str:String):Null<Int> {
        var r = ~/\$(\d+)/;
        if (!r.match(str))
            return null;

        return Std.parseInt(r.matched(1));
    }

    static public function parseTotalPrice(orderStr:String):Int {
        var multi = ~/^.+\[.+\]: (\d+)份$/;
        return orderStr.split("\n").map(line -> {
            if (multi.match(line)) {
                var n = Std.parseInt(multi.matched(1));
                var each = parsePrice(line);
                each * n;
            } else {
                line.split(", ").map(parsePrice).sum();
            }
        }).sum();
    }

    static public function pullOrders(?date:Date):Promise<String> {
        var now = switch (date) {
            case null: Date.now();
            case v: v;
        }
        // var now = Date.fromString("2020-08-18");
        var errors = [];
        var sheets = [
            for (shop => doc in menuForm)
            shop => doc
                .then(doc -> doc.sheetsByIndex[0])
                .then(sheet -> sheet.loadCells().then(_ -> sheet))
        ];
        return Promise.all([
            for (t in [Lunch, Dinner])
            for (shop => sheet in sheets)
            {
                sheet
                    .then(sheet -> getOrders(shop, sheet, now, t))
                    .then(orders -> orders.mapi((i, o) -> {
                        merge(o, {
                            code: shop.info().name + " " + (switch (t) {
                                case Lunch: "L" + '${i+1}'.lpad("0", 2);
                                case Dinner: "D" + '${i+1}'.lpad("0", 2);
                            }),
                        });
                    }))
                    .then(orders -> orders.mapi((i, o) -> {
                        var iceCreamPrices = o.iceCream.map(parsePrice);
                        var iceCreamPrice = iceCreamPrices.has(null) ? "" : Std.string(iceCreamPrices.sum());
                        [
                            "單號: " + o.code,
                            "",
                            o.content,
                            o.iceCream.length > 0 ? "\n" + o.iceCream.join("\n") + "\n" : null,
                            o.wantTableware,
                            o.note != null ? "*其他備註: " + o.note : null,
                            "",
                            "食物價錢: $" + parseTotalPrice(o.content),
                            o.iceCream.length > 0 ? "雪糕價錢: $" + iceCreamPrice : null,
                            o.iceCream.length > 0 ? "食物+雪糕+運費: $" : "食物+運費: $",
                            "",
                            "客人交收時段: " + o.time,
                            (o.contactMethod == Telegram ? "tg (客人首選):" : "tg: ") + o.tg,
                            (o.contactMethod == WhatsApp ? "wtsapp (客人首選):" : "wtsapp: ") + o.tel,
                            o.paymentMethod,
                            o.address + " (" + o.pickupMethod + ")",
                        ].filter(l -> l != null).join("\n");
                    }).join(hr))
                    .catchError((err:js.lib.Error) -> {
                        errors.push('Failed to process ${shop.info().name}\'s spreadsheet.\n\n' + err.message);
                    });
            }
        ]).then(strs -> {
            if (errors.length > 0) {
                Promise.reject(errors.join("\n\n\n\n"));
            } else {
                Promise.resolve(strs.filter((str:String) -> str.trim() != "").join(hr));
            }
        });
    }
}