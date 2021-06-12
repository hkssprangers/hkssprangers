package hkssprangers.info;

enum abstract ShopCluster(String) {
    final DragonCentreCluster;
    final CLPCluster;
    final GoldenCluster;
    final SmilingPlazaCluster;
    final ParkCluster;
    final PakTinCluster;
    final MyRoomRoomCluster;

    static public function classify(shop:Shop):ShopCluster {
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
            case MyRoomRoom: MyRoomRoomCluster;
            case ThaiYummy: SmilingPlazaCluster;
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
        case MyRoomRoomCluster:
            {
                id: MyRoomRoomCluster,
                name: "浮島範圍",
            }
    }
}