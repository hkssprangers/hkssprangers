package hkssprangers.info;

import haxe.ds.*;

enum abstract ShopCluster(String) to String {
    final DragonCentreCluster;
    final PeiHoStreetMarketCluster;
    final CLPCluster;
    final GoldenCluster;
    final SmilingPlazaCluster;
    final ParkCluster;
    final PakTinCluster;
    final TungChauStreetParkCluster;

    static public final all:ReadOnlyArray<ShopCluster> = [
        DragonCentreCluster,
        PeiHoStreetMarketCluster,
        CLPCluster,
        GoldenCluster,
        SmilingPlazaCluster,
        ParkCluster,
        PakTinCluster,
        TungChauStreetParkCluster,
    ];

    static public function classify(shop:Shop):Null<ShopCluster> {
        return switch shop {
            case EightyNine: DragonCentreCluster;
            case DragonJapaneseCuisine: DragonCentreCluster;
            case YearsHK: CLPCluster;
            case TheParkByYears: ParkCluster;
            case LaksaStore: DragonCentreCluster;
            case DongDong: CLPCluster;
            case BiuKeeLokYuen: GoldenCluster;
            case KCZenzero: DragonCentreCluster;
            case HanaSoftCream: DragonCentreCluster;
            case Neighbor: SmilingPlazaCluster;
            case MGY: ParkCluster;
            case FastTasteSSP: GoldenCluster;
            case BlaBlaBla: GoldenCluster;
            case ZeppelinHotDogSKM: PakTinCluster;
            case MyRoomRoom: null;
            case ThaiYummy: SmilingPlazaCluster;
            case Toolss: PakTinCluster;
            case KeiHing: TungChauStreetParkCluster;
            case PokeGo: ParkCluster;
            case WoStreet: DragonCentreCluster;
            case Minimal: ParkCluster;
            case CafeGolden: PakTinCluster;
            case BlackWindow: GoldenCluster;
            case LonelyPaisley: CLPCluster;
            case FishFranSSP: PeiHoStreetMarketCluster;
            case AuLawFarm: null;
            case MxMWorkshop: null;
            case HowDrunk: PakTinCluster;
        }
    }

    public function info() return switch (cast this:ShopCluster) {
        case DragonCentreCluster:
            {
                id: DragonCentreCluster,
                name: "西九龍中心範圍",
            }
        case CLPCluster:
            {
                id: CLPCluster,
                name: "中電範圍",
            }
        case GoldenCluster:
            {
                id: GoldenCluster,
                name: "黃金商場範圍",
            }
        case SmilingPlazaCluster:
            {
                id: SmilingPlazaCluster,
                name: "天悅廣場範圍",
            }
        case ParkCluster:
            {
                id: ParkCluster,
                name: "石硤尾街休憩花園範圍",
            }
        case PakTinCluster:
            {
                id: PakTinCluster,
                name: "白田範圍",
            }
        case TungChauStreetParkCluster:
            {
                id: TungChauStreetParkCluster,
                name: "通州街公園範圍",
            }
        case PeiHoStreetMarketCluster:
            {
                id: PeiHoStreetMarketCluster,
                name: "北河街街市範圍",
            }
    }

    static public final clusterStyle = [
        DragonCentreCluster => {
            borderClasses: ["border-red-500"],
            headerClasses: ["bg-pt2-red-500"],
            boxClasses: ["bg-slash-red-500"],
            textClasses: ["text-red-500"]
        },
        CLPCluster => {
            borderClasses: ["border-green-400"],
            headerClasses: ["bg-pt2-green-400"],
            boxClasses: [],
            textClasses: ["text-green-500"]
        },
        GoldenCluster => {
            borderClasses: ["border-pink-500"],
            headerClasses: ["bg-pt2-pink-500"],
            boxClasses: ["bg-slash-pink-500"],
            textClasses: ["text-pink-500"]
        },
        PeiHoStreetMarketCluster => {
            borderClasses: ["border-amber-600"],
            headerClasses: ["bg-pt-amber-600"],
            boxClasses: [],
            textClasses: ["text-amber-600"]
        },
        SmilingPlazaCluster => {
            borderClasses: ["border-yellow-500"],
            headerClasses: ["bg-pt2-yellow-500"],
            boxClasses: ["bg-slash-yellow-500"],
            textClasses: ["text-yellow-500"]
        },
        ParkCluster => {
            borderClasses: ["border-green-600"],
            headerClasses: ["bg-pt2-green-600"],
            boxClasses: [],
            textClasses: ["text-green-600"]
        },
        PakTinCluster => {
            borderClasses: ["border-blue-500"],
            headerClasses: ["bg-pt2-blue-500"],
            boxClasses: [],
            textClasses: ["text-blue-500"]
        },
        TungChauStreetParkCluster => {
            borderClasses: ["border-indigo-500"],
            headerClasses: ["bg-pt2-indigo-500"],
            boxClasses: [],
            textClasses: ["text-indigo-500"]
        }
    ];
}