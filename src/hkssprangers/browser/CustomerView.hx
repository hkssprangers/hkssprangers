package hkssprangers.browser;

import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import mui.core.*;
import js.npm.react_telegram_login.TelegramLoginButton;
import hkssprangers.info.*;
import hkssprangers.info.Shop;
import hkssprangers.info.PickupMethod;
import hkssprangers.info.menu.EightyNineItem;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TimeSlotTools;
using Lambda;

class EightyNineItemForm extends ReactComponent {
    public var onChange(get, never):(isValid:Bool) -> Void;
    function get_onChange() return props.onChange;

    public var onRemove(get, never):() -> Void;
    function get_onRemove() return props.onRemove;

    public var item(get, never):{
        id: EightyNineItem,
        data: Dynamic,
    }
    function get_item() return props.item;

    var randomId = Std.random(10000);

    function isValid():Bool {
        return item != null && switch (item.id) {
            case EightyNineSet:
                item.id.info(item.data).isValid;
        }
        return false;
    }

    override function render() {
        var eightyNineSetInfo = EightyNineSet.info({});
        function RadioControl() return jsx('
            <Radio />
        ');
        var mainItems = [
            EightyNineSetMain1,
            EightyNineSetMain2,
            EightyNineSetMain3,
            EightyNineSetMain4,
            EightyNineSetMain5,
        ]
            .map(main -> main.info())
            .map(info -> jsx('
                <MenuItem key=${info.id} value=${info.id}>${info.name + " " + info.priceCents.print()}</MenuItem>
            '));
        var subItems = [
            EightyNineSetSub1,
            EightyNineSetSub2,
        ]
            .map(main -> main.info())
            .map(info -> jsx('
                <MenuItem key=${info.id} value=${info.id}>${info.name}</MenuItem>
            '));

        var cardAction = jsx('
            <Grid container=${true} spacing=${Spacing_0}>
                <Grid item=${true}>
                    <Button size=${Small} onClick=${evt -> onRemove()}>
                        移除
                    </Button>
                </Grid>
            </Grid>
        ');

        return jsx('
            <Card className="is-editing" variant=${Outlined}>
                <CardHeader
                    title=${eightyNineSetInfo.name}
                    subheader=${eightyNineSetInfo.description}
                    action=${cardAction}
                />
                <CardContent>
                    <Grid container=${true}>
                        <Grid item=${true} xs=${12}>
                            <FormControl required=${true}>
                                <InputLabel id=${"select-main-" + randomId}>主菜選擇</InputLabel>
                                <Select
                                    labelId=${"select-main-" + randomId}
                                    value=${item.data.main != null ? item.data.main : ""}
                                    onChange=${(evt:js.html.Event, elm) -> {
                                        item.data.main = (cast evt.target).value;
                                        onChange(isValid());
                                    }}
                                >
                                    ${mainItems}
                                </Select>
                            </FormControl>
                        </Grid>
                        <Grid item=${true} xs=${12}>
                            <FormControl required=${true}>
                                <InputLabel id=${"select-sub-" + randomId}>
                                    配菜選擇
                                </InputLabel>
                                <Select
                                    labelId=${"select-sub-" + randomId}
                                    value=${item.data.sub != null ? item.data.sub : ""}
                                    onChange=${(evt, elm) -> {
                                        item.data.sub = (cast evt.target).value;
                                        onChange(isValid());
                                    }}
                                >
                                    ${subItems}
                                </Select>
                            </FormControl>
                        </Grid>
                        <Grid item=${true} xs=${12}>
                            <Typography>
                                套餐附送 ${EightyNineSetGiven1.info().name}
                            </Typography>
                        </Grid>
                    </Grid>
                </CardContent>
            </Card>
        ');
    }
}

class EightyNineOrderForm extends ReactComponent {
    static public final maxItems = 3;

    public var onChange(get, never):(isValid:Bool) -> Void;
    function get_onChange() return props.onChange;

    public var onPickupTimeSlotChange(get, never):(slot:TimeSlot) -> Void;
    function get_onPickupTimeSlotChange() return props.onPickupTimeSlotChange;

    public var order(get, never):Order<EightyNineItem>;
    function get_order() return props.order;

    public var pickupTimeSlot(get, never):TimeSlot;
    function get_pickupTimeSlot() return props.pickupTimeSlot;

    public var pickupTimeSlotOptions(get, never):Array<TimeSlot & { isOff:Bool }>;
    function get_pickupTimeSlotOptions() return props.pickupTimeSlotOptions;

    public var editing(get, set):Map<{
        id: EightyNineItem,
        data: Dynamic,
    }, Bool>;
    function get_editing() return state.editing;
    function set_editing(v) {
        setState({
            editing: v,
        });
        return v;
    }

    public function new(props):Void {
        super(props);
        state = {
            editing: new Map<{
                id: EightyNineItem,
                data: Dynamic,
            }, Bool>(),
        };
    }

    override function componentDidMount() {
        addItem();
    }

    function isValid():Bool {
        return order.totalCents() > 0 && editing.foreach(v -> !v);
    }

    function addItem() {
        var newItem = {
            id: EightyNineSet,
            data: {
                main: null,
                sub: null,
                given: EightyNineSetGiven1,
            }
        };
        order.items.push(newItem);
        editing[newItem] = true;
        onChange(isValid());
        editing = editing;
    }

    function timeSlotInput() {
        var pickupTimeSlotString = if (pickupTimeSlot != null) {
            pickupTimeSlot.print();
        } else {
            "";
        }

        var slots = pickupTimeSlotOptions.map(slot ->
            jsx('
                <MenuItem
                    key=${slot.start}
                    value=${(!slot.isOff ? slot.print() : "":Dynamic)}
                    className=${slot.isOff ? "Mui-disabled" : ""}
                >
                    ${slot.print()} ${slot.isOff ? "(休息)" : null}
                </MenuItem>
            ')
        );

        return jsx('
            <Grid item=${true} xs=${12}>
                <FormControl required=${true}>
                    <InputLabel id=${"select-timeslot"}>
                        想幾時收到嘢食?
                    </InputLabel>
                    <Select
                        labelId=${"select-timeslot"}
                        value=${pickupTimeSlotString}
                        onChange=${(evt, elm) -> {
                            var value:String = (cast evt.target).value;
                            onPickupTimeSlotChange(pickupTimeSlotOptions.find(slot -> slot.print() == value));
                        }}
                    >
                        ${slots}
                    </Select>
                </FormControl>
            </Grid>
        ');
    }

    override function render() {
        var itemForms = order.items.map(item -> {
            function onChange(isValid:Bool) {
                editing[item] = !isValid;
                editing = editing;
                this.onChange(this.isValid());
            }
            function onRemove() {
                order.items.remove(item);
                editing.remove(item);
                editing = editing;
                this.onChange(this.isValid());
            }
            jsx('
                <Grid key=${item} item=${true} xs=${12}>
                    <EightyNineItemForm
                        item=${item}
                        onChange=${onChange}
                        onRemove=${onRemove}
                    />
                </Grid>
            ');
        });

        var addLabel = if (order.items.length > 0) {
            "叫多份";
        } else {
            "揀食咩";
        }
        var addMore = if (order.items.length < maxItems) {
            jsx('
                <Button size=${Small} color=${Primary} onClick=${evt -> addItem()} disabled=${editing.has(true)}>
                    ${addLabel}
                </Button>
            ');
        } else {
            jsx('
                <Grid container=${true} spacing=${Spacing_1} alignItems=${Center}>
                    <Grid>
                        <Button size=${Small} color=${Primary} onClick=${evt -> addItem()} disabled=${true}>
                            ${addLabel}
                        </Button>
                    </Grid>
                    <Grid>
                        <Typography variant=${Body2}>
                            最多叫 ${maxItems} 份
                        </Typography>
                    </Grid>
                </Grid>
            ');
        }

        return jsx('
            <Grid container=${true} spacing=${Spacing_1}>
                <Grid container=${true} item=${true} xs=${12} justify=${Center}>
                    <Grid item=${true}>
                        <Typography variant=${H2}>${EightyNine.info().name} x 埗兵 外賣預訂</Typography>
                    </Grid>
                </Grid>
                ${timeSlotInput()}
                <Grid className="order-content" container=${true} item=${true} xs=${12}>
                    ${itemForms}
                    <Grid item=${true} xs=${12}>
                        ${addMore}
                    </Grid>
                    <Grid item=${true} xs=${12}>
                        <Typography>
                            食物價錢: ${order.totalCents().print()}
                        </Typography>
                    </Grid>
                </Grid>
            </Grid>
        ');
    }
}

class CustomerView extends ReactComponent {
    public var tgBotName(get, never):String;
    function get_tgBotName() return props.tgBotName;

    public var selectedOrderForm(get, set):Null<Shop<Dynamic>>;
    function get_selectedOrderForm() return state.selectedOrderForm;
    function set_selectedOrderForm(v) {
        setState({
            selectedOrderForm: v,
        });
        return v;
    }

    public var delivery(get, set):Null<Delivery>;
    function get_delivery() return state.delivery;
    function set_delivery(v) {
        setState({
            delivery: v,
        });
        return v;
    }

    public var order(get, set):Null<Order<Dynamic>>;
    function get_order() return delivery.orders[0];
    function set_order(v) {
        delivery.orders[0] = v;
        delivery = delivery;
        return v;
    }

    public var isValid(get, set):Bool;
    function get_isValid() return state.isValid;
    function set_isValid(v) {
        setState({
            isValid: v,
        });
        return v;
    }

    function new(props):Void {
        super(props);
        state = {
            selectedOrderForm: EightyNine,
            delivery: ({
                courier: null,
                orders: [{
                    shop: EightyNine,
                    code: null,
                    timestamp: null,
                    items: [],
                    wantTableware: null,
                    customerNote: null,
                }],
                customer: {
                    tg: null,
                    tel: null,
                },
                paymentMethods: [],
                pickupLocation: null,
                pickupTimeSlot: null,
                pickupMethod: null,
                deliveryFeeCents: null,
                customerNote: null,
            }:Delivery),
            isValid: false,
        };
    }

    function handleTelegramResponse(response) {
        delivery.customer.tg = {
            id: response.id,
            username: response.username,
        };
        delivery = delivery;
    }

    override function render() {
        var orderContent = switch (selectedOrderForm) {
            case null:
                jsx('
                    <Grid container=${true} spacing=${Spacing_1}>
                        <Grid item=${true} xs=${12}>
                            <Typography variant=${H2} align=${Center}>落單</Typography>
                        </Grid>
                        <Grid item=${true} container=${true} xs=${12} spacing=${Spacing_3} justify=${Center}>
                            <Grid item=${true}>
                                <Button
                                    color=${Primary}
                                    href="https://docs.google.com/forms/d/e/1FAIpQLSfKw5JY0no7Tgu7q0hT2LP05rJ23DCMRIcCjxfwyapfSMl-Bg/viewform"
                                >
                                    ${YearsHK.info().name}
                                </Button>
                            </Grid>
                            <Grid item=${true}>
                                <Button
                                    color=${Primary}
                                    onClick=${(evt) -> selectedOrderForm = EightyNine}
                                >
                                    ${EightyNine.info().name}
                                </Button>
                            </Grid>
                            <Grid item=${true}>
                                <Button
                                    color=${Primary}
                                    href="https://docs.google.com/forms/d/e/1FAIpQLSfvb1PDjceErVgyogijVDxkN3pXu0djpBFzc_H59oqrdSH0mQ/viewform"
                                >
                                    ${DragonJapaneseCuisine.info().name}
                                </Button>
                            </Grid>
                            <Grid item=${true}>
                                <Button
                                    color=${Primary}
                                    href="https://docs.google.com/forms/u/1/d/e/1FAIpQLSffligA-KWnAQsNPbshjYFJeE8s00XkKoXP0IbUYd0xZReotg/viewform"
                                >
                                    ${LaksaStore.info().name}
                                </Button>
                            </Grid>
                        </Grid>
                    </Grid>
                ');
            case EightyNine:
                function onChange(isValid:Bool) {
                    this.isValid = isValid;
                    order = order;
                }
                function onPickupTimeSlotChange(slot:TimeSlot) {
                    delivery.pickupTimeSlot = slot;
                    delivery = delivery;
                }
                var pickupTimeSlotOptions = order.shop.nextTimeSlots(Date.now());
                jsx('
                    <EightyNineOrderForm
                        order=${order}
                        pickupTimeSlot=${delivery.pickupTimeSlot}
                        pickupTimeSlotOptions=${pickupTimeSlotOptions}
                        onChange=${onChange}
                        onPickupTimeSlotChange=${onPickupTimeSlotChange}
                    />
                ');
            case DragonJapaneseCuisine:
                null;
            case YearsHK:
                null;
            case LaksaStore:
                null;
            case DongDong:
                null;
            case BiuKeeLokYuen:
                null;
            case KCZenzero:
                null;
            case HanaSoftCream:
                null;
            case Neighbor:
                null;
            case MGY:
                null;
        }
        var dollar = "$";
        function onAddressChange(evt:js.html.Event) {
            delivery.pickupLocation = (cast evt.target).value;
            delivery = delivery;
        }
        var pickupMethodItems = [
            Door,
            Street,
        ]
            .map(v -> v.info())
            .map(info -> jsx('
                <MenuItem key=${info.id} value=${info.id}>${info.name}</MenuItem>
            '));
        function onPickupMethodChange(evt, elm) {
            delivery.pickupMethod = (cast evt.target).value;
            delivery = delivery;
        }
        var customerTg = if (delivery.customer.tg != null) {
            if (delivery.customer.tg.username != null)
                jsx('
                    <Typography>
                        Telegram username: <a href=${"https://t.me/" + delivery.customer.tg.username} target="_blank">@${delivery.customer.tg.username}</a>
                    </Typography>
                ');
            else
                jsx('
                    <Typography>
                        Telegram ID: ${delivery.customer.tg.id}
                    </Typography>
                ');
        } else {
            jsx('
                <TelegramLoginButton
                    botName=${tgBotName}
                    dataOnauth=${handleTelegramResponse}
                />
            ');
        }
        return return jsx('
            <Container maxWidth=${SM}>
                <Grid container=${true}>
                    <Typography>
                        * 必填項目
                    </Typography>
                </Grid>
                <Grid container=${true}>
                    <Grid item=${true} xs=${12}>
                        ${orderContent}
                    </Grid>
                </Grid>
                <Divider variant=${Middle} />
                <Grid container=${true}>
                    <Grid item=${true} xs=${12}>
                        <Typography variant=${H5} gutterBottom=${true}>
                            有關運費
                        </Typography>
                        <Typography paragraph=${true}>
                            設定運費嘅原則:<br/>
                            ${dollar}25 - 步行15分鐘或以內<br/>
                            ${dollar}35 - 步行15至20分鐘<br/>
                            ${dollar}40 - 距離較遠需要車手負責外賣<br/>
                            價格會因應實際情況(如長樓梯)調整。
                        </Typography>
                        <Typography paragraph=${true}>
                            落單後，平台會因應地址及價目表計算運費，外賣員送餐前會經tg同你確認一次價錢。
                        </Typography>
                    </Grid>
                    <Grid item=${true} xs=${12}>
                        <TextField
                            label="交收地址"
                            required=${true}
                            value=${delivery.pickupLocation != null ? delivery.pickupLocation: ""}
                            onChange=${onAddressChange}
                        />
                    </Grid>
                    <Grid item=${true} xs=${12}>
                        <FormControl required=${true}>
                            <InputLabel id="select-pickup-method">
                                交收方法
                            </InputLabel>
                            <Select
                                labelId="select-pickup-method"
                                value=${delivery.pickupMethod != null ? delivery.pickupMethod : ""}
                                onChange=${onPickupMethodChange}
                            >
                                ${pickupMethodItems}
                            </Select>
                        </FormControl>
                    </Grid>
                    <Grid item=${true} xs=${12}>
                        ${customerTg}
                    </Grid>
                </Grid>
            </Container>
        ');
    }
}