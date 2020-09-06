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

class LogIn extends View {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var user(get, never):Null<{
        tg: {
            id:Int,
            username:String,
        }
    }>;
    function get_user() return props.user;

    override public function description() return "登入";
    override function canonical() return Path.join([domain, "login"]);
    override public function render() {
        return super.render();
    }

    override function bodyContent() {
        return jsx('
            <div>
                <div className="text-center">
                    <a href="/"><img id="logo" src=${R("/images/ssprangers4-y.png")} className="rounded-circle" alt="埗兵" /></a>
                </div>
                <div id="LogInView"
                    data-tg-bot-name=${tgBotName}
                    data-user=${Json.stringify(user)}
                />
            </div>
        ');
    }

    static final menuForm = [
        for (shop => sheetId in [
            YearsHK => "1Jq1AuOc6pG-EuqsGkRj_DS4TWvFXa-r3pGY9DFMqhGk",
            EightyNine => "1Y-yqDQsYO4UeJa4Jxl2ZtZ56Su84cU58TVrm7QpXTHg",
            DragonJapaneseCuisine => "1A_dPdhn6jDGZU-iyDXVKkEdme2VsUZxMUgjZZPa3gMc",
            LaksaStore => "16Jw8bVcW1N87jndk6VQ99E3mBB_H9hxLckM8eIbGpcY",
            DongDong => "1IpJteF-lZ9wd0tSHPgwsVyUuhuWraAdgKnKisYalFb8",
            BiuKeeLokYuen => "1POh9Yy93iyTbm5An_NhQoVWO2QX7GCDcBrs0nZuehKg",
            KCZenzero => "1gHslFNSVO8KOoD6IEcV-mglGoGailUaHr4SbQRSzFOo",
        ]) {
            var doc = new GoogleSpreadsheet(sheetId);
            shop => doc.useServiceAccountAuth(GoogleServiceAccount.formReaderServiceAccount)
                .then(_ -> doc.loadInfo())
                .then(_ -> doc);
        }
    ];

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
                    tg: null,
                    tel: null,
                    paymentMethod: null,
                    address: null,
                    pickupMethod: null,
                    note: null,
                };
                var orderContent = [];
                for (col => h in headers)
                switch [shop, h, (sheet.getCell(row, col).value:String)] {
                    case [_, "請選擇類別", v = "粉麵" | "撈麵" | "淨食牛腩/牛雜/小食"]:
                        orderContent.push(h + ": " + v);
                    case [_, "Timestamp" | "時間戳記" | "叫多份?" | "請選擇類別" | null, _]:
                        null;
                    case [_, _, null | "" | "明白了"]:
                        null;
                    case [_, "想幾時收到?", v]:
                        order.time = v;
                    case [_, "你的地址", v]:
                        order.address = v;
                    case [_, "你的電話號碼", v]:
                        order.tel = v;
                    case [_, "俾錢方法", v]:
                        order.paymentMethod = v;
                    case [_, "交收方法", v]:
                        order.pickupMethod = v;
                    case [_, "需要餐具嗎?", v]:
                        order.wantTableware = v + "餐具";
                    case [_, "其他備註", v]:
                        order.note = v;
                    case [_, h, v] if (h.startsWith("你的tg username")):
                        var r = ~/^@?([A-Za-z0-9_]{5,})$/;
                        order.tg = if (r.match(v.trim()))
                            "https://t.me/" + r.matched(1);
                        else
                            v;
                    case [_, h, v] if (h.contains("雪糕")):
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
                    case [_, h, v]:
                        orderContent.push(h + ": " + v);
                }
                order.content = orderContent.join("\n");
                order;
            }
        ];
    }

    static public function middleware(req:Request, res:Response) {
        var tgBotInfo = tgBot.telegram.getMe();
        tgBotInfo.then(tgBotInfo ->
            res.sendView(LogIn, {
                tgBotName: tgBotInfo.username,
                user: null,
            }))
            .catchError(err -> res.status(500).json(err));
    }
}