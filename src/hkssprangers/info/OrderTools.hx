package hkssprangers.info;

import hkssprangers.info.menu.EightyNineItem;

class OrderTools {
    static public function totalCents<T>(order:Order<T>):Cents {
        var total:Cents = 0;

        for (item in order.items) {
            switch (order.shop) {
                case EightyNine:
                    switch (item.id:EightyNineItem) {
                        case itemId = EightyNineSet:
                            var info = itemId.info(item.data);
                            total += info.priceCents;
                    }
                case DragonJapaneseCuisine:

                case YearsHK:

                case LaksaStore:

                case DongDong:

                case BiuKeeLokYuen:

                case KCZenzero:

                case HanaSoftCream:

                case Neighbor:

                case MGY:
            }
        }

        return total;
    }

    static public function print<T>(order:Order<T>):String {
        var buf = new StringBuf();

        buf.add("📃 " + order.shop.info().name + " " + order.code + " (" + totalCents(order).print() + ")\n");

        for (item in order.items) {
            switch (order.shop) {
                case EightyNine:
                    switch (item.id:EightyNineItem) {
                        case itemId = EightyNineSet:
                            var info = itemId.info(item.data);
                            buf.add(info.detail);
                    }
                case DragonJapaneseCuisine:

                case YearsHK:

                case LaksaStore:

                case DongDong:

                case BiuKeeLokYuen:

                case KCZenzero:

                case HanaSoftCream:

                case Neighbor:

                case MGY:

            }
        }

        buf.add(order.wantTableware ? "要餐具\n" : "唔要餐具\n");

        return buf.toString();
    }
}