package hkssprangers.server;

import js.npm.google_spreadsheet.GoogleSpreadsheetWorksheet;
import js.lib.Promise;
import js.npm.google_spreadsheet.GoogleSpreadsheet;
import haxe.crypto.Sha256;
import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import haxe.io.Path;
import haxe.Json;
import js.npm.express.*;
import hkssprangers.info.Info;
import hkssprangers.server.ServerMain.*;
using Lambda;
using StringTools;
using hkssprangers.server.ExpressTools;

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
                <div className="text-center">
                    <a href="/"><img id="logo" src=${R("/images/ssprangers4-y.png")} className="rounded-circle" alt="埗兵" /></a>
                </div>
                <div id="AdminView"
                    data-tg-bot-name=${tgBotName}
                    data-user=${Json.stringify(user)}
                />
            </div>
        ');
    }

    static final menuForm = [
        YearsHK => "1Jq1AuOc6pG-EuqsGkRj_DS4TWvFXa-r3pGY9DFMqhGk",
        EightyNine => "1Y-yqDQsYO4UeJa4Jxl2ZtZ56Su84cU58TVrm7QpXTHg",
        DragonJapaneseCuisine => "1xPROSpRRCXbGp-VsLv5p_zUVw0YIu2kLvYiYxVHnx1U",
        LaksaStore => "16Jw8bVcW1N87jndk6VQ99E3mBB_H9hxLckM8eIbGpcY",
        DongDong => "1IpJteF-lZ9wd0tSHPgwsVyUuhuWraAdgKnKisYalFb8",
        BiuKeeLokYuen => "1POh9Yy93iyTbm5An_NhQoVWO2QX7GCDcBrs0nZuehKg",
    ];

    static function getOrders(sheet:GoogleSpreadsheetWorksheet, date:Date, timeSlotType:TimeSlotType) {
        var dateStr = (date.getMonth() + 1) + "月" + date.getDate() + "日";
        function isInTimeSlot(value:String):Bool {
            return value.startsWith(dateStr) && switch (timeSlotType) {
                case Lunch:
                    value.indexOf("午") >= 0;
                case Dinner:
                    value.indexOf("晚") >= 0;
            }
        }
        return sheet.loadCells()
            .then(_ -> {
                var headers = [
                    for (col in 0...sheet.columnCount)
                    (sheet.getCell(0, col).value:Null<String>)
                ];
                [
                    for (row in 1...sheet.rowCount)
                    if (sheet.getCell(row, 0).value != null)
                    if (isInTimeSlot(sheet.getCell(row, headers.findIndex(h -> h == "想幾時收到?")).value))
                    {
                        var order = {
                            content: "",
                            wantTableware: null,
                            time: null,
                            tg: null,
                            tel: null,
                            paymentMethod: null,
                            address: null,
                            pickupMethod: null,
                            note: null,
                        };
                        var orderContent = [];
                        for (col => h in headers)
                        switch [h, (sheet.getCell(row, col).value:String)] {
                            case ["請選擇類別", v = "粉麵" | "撈麵" | "淨食牛腩/牛雜/小食"]:
                                orderContent.push(h + ": " + v);
                            case ["Timestamp" | "時間戳記" | "叫多份?" | "請選擇類別" | null, _]:
                                null;
                            case [_, null | "" | "明白了"]:
                                null;
                            case ["想幾時收到?", v]:
                                order.time = v;
                            case ["你的地址", v]:
                                order.address = v;
                            case ["你的電話號碼", v]:
                                order.tel = v;
                            case ["俾錢方法", v]:
                                order.paymentMethod = v;
                            case ["交收方法", v]:
                                order.pickupMethod = v;
                            case ["需要餐具嗎?", v]:
                                order.wantTableware = v + "餐具";
                            case ["其他備註", v]:
                                order.note = v;
                            case [h, v] if (h.startsWith("你的tg username")):
                                var r = ~/^@?([A-Za-z0-9_]{5,})$/;
                                order.tg = if (r.match(v.trim()))
                                    "https://t.me/" + r.matched(1);
                                else
                                    v;
                            case [h, v = "涼拌青瓜拼木耳" | "郊外油菜"]:
                                orderContent.push(h + ": " + v);
                                orderContent.push("套餐附送絲苗白飯2個");
                            case [h, v]:
                                orderContent.push(h + ": " + v);
                        }
                        order.content = orderContent.join("\n");
                        order;
                    }
                ];
            });
    }

    static public function middleware(req:Request, res:Response) {
        var tg:Null<{
            id:Int,
            username:String,
        }> = if (req.cookies != null && req.cookies.tg != null) try {
            Json.parse(req.cookies.tg);
        } catch(err) {
            res.status(403).end('Error parsing Telegram login response.\n\n' + err.details());
            return;
        } else null;

        var user = if (tg != null) {
            if (!TelegramTools.verifyLoginResponse(Sha256.encode(tgBotToken), cast tg)) {
                res.status(403).end('Invalid Telegram login response.');
                return;
            }
            if (
                ![
                    "andyonthewings",
                    "Arbuuuuuuu",
                ].exists(adminUsername -> adminUsername.toLowerCase() == tg.username.toLowerCase())
            ) {
                res.status(403).end('${tg.username} (${tg.id}) is not one of the admins.');
                return;
            }

            {
                tg: tg,
            }
        } else {
            null;
        }

        if (user != null) {
            var now = Date.now();
            // var now = Date.fromString("2020-08-18");
            var hr = "\n--------------------------------------------------------------------------------\n";
            var errors = [];
            Promise.all([
                for (t in [Lunch, Dinner])
                for (shop => id in menuForm)
                {
                    var doc = new GoogleSpreadsheet(id);
                    doc.useServiceAccountAuth(GoogleServiceAccount.formReaderServiceAccount)
                        .then(_ -> doc.loadInfo())
                        .then(_ -> getOrders(doc.sheetsByIndex[0], now, t))
                        .then(orders -> orders.mapi((i, o) -> {
                            [
                                "單號: " + shop.info().name + " " + (switch (t) {
                                    case Lunch: "L" + '${i+1}'.lpad("0", 2);
                                    case Dinner: "D" + '${i+1}'.lpad("0", 2);
                                }),
                                "",
                                o.content,
                                o.wantTableware,
                                o.note != null ? "*其他備註: " + o.note : null,
                                "",
                                "食物價錢: $",
                                "食物+運費: $",
                                "",
                                "客人交收時段: " + o.time,
                                "tg: " + o.tg,
                                o.tel,
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
                    res.type("text");
                    res.status(500).end(errors.join("\n\n\n\n"));
                    return;
                }
                res.type("text");
                res.end(strs.filter((str:String) -> str.trim() != "").join(hr));
            });
        } else {
            var tgBotInfo = tgBot.telegram.getMe();
            tgBotInfo.then(tgBotInfo ->
                res.sendView(Admin, {
                    tgBotName: tgBotInfo.username,
                    user: user,
                }))
                .catchError(err -> res.status(500).json(err));
        }
    }
}