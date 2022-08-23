package hkssprangers.info;

import haxe.ds.ReadOnlyArray;
import js.lib.Promise;
using Lambda;
using DateTools;

enum abstract Recipe(String) to String {
    final ThreeCupTofu:Recipe;
    final AloeSoda:Recipe;
    final BasilTomatoMeat:Recipe;
    final BitterMelonVegeEgg:Recipe;
    final CatToast:Recipe;
    final Cauliflower:Recipe;
    final Curry:Recipe;
    final KaleCrisp:Recipe;
    final MelonTomatoSoup:Recipe;
    final MisoEggplant:Recipe;
    final NinePie:Recipe;
    final PotatoCheese:Recipe;
    final SandMiso:Recipe;
    final ShisoTomato:Recipe;
    final Soup:Recipe;
    final SpanichPasta:Recipe;
    final SweetBitterMelon:Recipe;

    
    static public final all:ReadOnlyArray<Recipe> = [
        ThreeCupTofu,
        AloeSoda,
        BasilTomatoMeat,
        BitterMelonVegeEgg,
        CatToast,
        Cauliflower,
        Curry,
        KaleCrisp,
        MelonTomatoSoup,
        MisoEggplant,
        NinePie,
        PotatoCheese,
        SandMiso,
        ShisoTomato,
        Soup,
        SpanichPasta,
        SweetBitterMelon
    ];

    public function info() return switch (cast this:Recipe) {
        case ThreeCupTofu:
            {
                id: ThreeCupTofu,
                name: "三杯豆腐"
            }
        case AloeSoda:
            {
                id: AloeSoda,
                name: "蘆薈檸檬薄荷梳打"
            }
        case BasilTomatoMeat:
            {
                id: BasilTomatoMeat,
                name: "塔香蕃茄肉碎"
            }
        case BitterMelonVegeEgg:
            {
                id: BitterMelonVegeEgg,
                name: "沖繩苦瓜炒素蛋"
            }
        case CatToast:
            {
                id: CatToast,
                name: "桑子果醬貓多士"
            }
        case Cauliflower:
            {
                id: Cauliflower,
                name: "煙燻紅椒粉焗椰菜花"
            }
        case Curry:
            {
                id: Curry,
                name: "葡汁四蔬"
            }
        case KaleCrisp:
            {
                id: KaleCrisp,
                name: "羽衣甘藍脆脆"
            }
        case MelonTomatoSoup:
            {
                id: MelonTomatoSoup,
                name: "冬瓜蕃茄腰果湯"
            }

        case MisoEggplant:
            {
                id: MisoEggplant,
                name: "味噌焗茄子"
            }
        case NinePie:
            {
                id: NinePie,
                name: "韮菜蛋餅"
            }
        case PotatoCheese:
            {
                id: PotatoCheese,
                name: "拉絲芝士薯仔餅"
            }
        case SandMiso:
            {
                id: SandMiso,
                name: "沙葛味噌煮"
            }
        case ShisoTomato:
            {
                id: ShisoTomato,
                name: "紫蘇蕃茄"
            }
        case Soup:
            {
                id: Soup,
                name: "粟米紅菜頭西芹蘋果湯"
            }
        case SpanichPasta:
            {
                id: SpanichPasta,
                name: "白汁菠菜苗煙肉螺絲粉"
            }
        case SweetBitterMelon:
            {
                id: SweetBitterMelon,
                name: "糖醋白苦瓜"
            }
    }


}