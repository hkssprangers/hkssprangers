package hkssprangers.browser;

import mui.core.*;
import js.npm.react_telegram_login.TelegramLoginButton;
import hkssprangers.info.*;
import hkssprangers.info.Order;
import hkssprangers.info.Shop;
import hkssprangers.info.PickupMethod;
import hkssprangers.info.menu.EightyNineItem;
using hkssprangers.info.OrderTools;
using hkssprangers.info.TimeSlotTools;
using hkssprangers.ObjectTools;
using hkssprangers.MathTools;
using Lambda;

typedef EightyNineItemFormProps = {
    var onChange:(isValid:Bool) -> Void;
    var onRemove:() -> Void;
    var item:{
        id: EightyNineItem,
        data: Dynamic,
    };
}

class EightyNineItemForm extends ReactComponentOfProps<EightyNineItemFormProps> {
    var randomId = Std.random(10000);

    function isValid():Bool {
        return props.item != null && switch (props.item.id) {
            case EightyNineSet:
                props.item.id.info(props.item.data).isValid;
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
                <MenuItem key=${info.id} value=${info.id}>${info.name + " $" + info.price}</MenuItem>
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
            <Grid container spacing=${Spacing_0}>
                <Grid item>
                    <Button size=${Small} onClick=${evt -> props.onRemove()}>
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
                    <Grid container>
                        <Grid item xs=${12}>
                            <FormControl required>
                                <InputLabel id=${"select-main-" + randomId}>主菜選擇</InputLabel>
                                <Select
                                    labelId=${"select-main-" + randomId}
                                    value=${props.item.data.main != null ? props.item.data.main : ""}
                                    onChange=${(evt:js.html.Event, elm) -> {
                                        props.item.data.main = (cast evt.target).value;
                                        props.onChange(isValid());
                                    }}
                                >
                                    ${mainItems}
                                </Select>
                            </FormControl>
                        </Grid>
                        <Grid item xs=${12}>
                            <FormControl required>
                                <InputLabel id=${"select-sub-" + randomId}>
                                    配菜選擇
                                </InputLabel>
                                <Select
                                    labelId=${"select-sub-" + randomId}
                                    value=${props.item.data.sub != null ? props.item.data.sub : ""}
                                    onChange=${(evt, elm) -> {
                                        props.item.data.sub = (cast evt.target).value;
                                        props.onChange(isValid());
                                    }}
                                >
                                    ${subItems}
                                </Select>
                            </FormControl>
                        </Grid>
                        <Grid item xs=${12}>
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

typedef EightyNineOrderFormProps = {
    var onChange:(isValid:Bool) -> Void;
    var onPickupTimeSlotChange:(slot:TimeSlot) -> Void;
    var order:OrderMeta;
    var items:Array<{
        id:EightyNineItem,
        data:Dynamic,
    }>;
    var pickupTimeSlot:TimeSlot;
    var pickupTimeSlotOptions:Array<TimeSlot & { isOff:Bool }>;
}

typedef EightyNineOrderFormState = {
    var editing:Map<{
        id: EightyNineItem,
        data: Dynamic,
    }, Bool>;
}

class EightyNineOrderForm extends ReactComponentOf<EightyNineOrderFormProps, EightyNineOrderFormState> {
    static public final maxItems = 3;
    inline static final dollar = "$";

    public function new(props):Void {
        super(props);
        state = {
            editing: new Map(),
        };
    }

    override function componentDidMount() {
        addItem();
    }

    function isValid():Bool {
        return orderPrice() > 0 && state.editing.foreach(v -> !v);
    }

    function orderPrice() {
        return props.items.map(item -> item.id.info(item.data).price).sum();
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
        props.items.push(newItem);
        state.editing[newItem] = true;
        props.onChange(isValid());
        setState({ editing: state.editing });
    }

    function timeSlotInput() {
        var pickupTimeSlotString = if (props.pickupTimeSlot != null) {
            props.pickupTimeSlot.print();
        } else {
            "";
        }

        var slots = props.pickupTimeSlotOptions.map(slot ->
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
            <Grid item xs=${12}>
                <FormControl required>
                    <InputLabel id=${"select-timeslot"}>
                        想幾時收到嘢食?
                    </InputLabel>
                    <Select
                        labelId=${"select-timeslot"}
                        value=${pickupTimeSlotString}
                        onChange=${(evt, elm) -> {
                            var value:String = (cast evt.target).value;
                            props.onPickupTimeSlotChange(props.pickupTimeSlotOptions.find(slot -> slot.print() == value));
                        }}
                    >
                        ${slots}
                    </Select>
                </FormControl>
            </Grid>
        ');
    }

    override function render() {
        var itemForms = props.items.map(item -> {
            function onChange(isValid:Bool) {
                state.editing[item] = !isValid;
                setState({ editing: state.editing });
                props.onChange(this.isValid());
            }
            function onRemove() {
                props.items.remove(item);
                state.editing.remove(item);
                setState({ editing: state.editing });
                props.onChange(this.isValid());
            }
            jsx('
                <Grid key=${item} item xs=${12}>
                    <EightyNineItemForm
                        item=${item}
                        onChange=${onChange}
                        onRemove=${onRemove}
                    />
                </Grid>
            ');
        });

        var addLabel = if (props.items.length > 0) {
            "叫多份";
        } else {
            "揀食咩";
        }
        var addMore = if (props.items.length < maxItems) {
            jsx('
                <Button size=${Small} color=${Primary} onClick=${evt -> addItem()} disabled=${state.editing.has(true)}>
                    ${addLabel}
                </Button>
            ');
        } else {
            jsx('
                <Grid container spacing=${Spacing_1} alignItems=${Center}>
                    <Grid>
                        <Button size=${Small} color=${Primary} onClick=${evt -> addItem()} disabled>
                            ${addLabel}
                        </Button>
                    </Grid>
                    <Grid>
                        <Typography variant=${Body2}>
                            最多叫 ${Std.string(maxItems)} 份
                        </Typography>
                    </Grid>
                </Grid>
            ');
        }

        return jsx('
            <Grid container spacing=${Spacing_1}>
                <Grid container item xs=${12} justify=${Center}>
                    <Grid item>
                        <Typography variant=${H2}>${EightyNine.info().name} x 埗兵 外賣預訂</Typography>
                    </Grid>
                </Grid>
                ${timeSlotInput()}
                <Grid className="order-content" container item xs=${12}>
                    ${itemForms}
                    <Grid item xs=${12}>
                        ${addMore}
                    </Grid>
                    <Grid item xs=${12}>
                        <Typography>
                            食物價錢: ${dollar}${Std.string(orderPrice())}
                        </Typography>
                    </Grid>
                </Grid>
            </Grid>
        ');
    }
}

typedef CustomerViewProps = {
    var tgBotName:String;
}

typedef CustomerViewState = {
    var selectedOrderForm:Null<Shop>;
    var delivery:Null<Delivery>;
    var items:Array<{
        id:EightyNineItem,
        data:Dynamic,
    }>;
    var isValid:Bool;
}

class CustomerView extends ReactComponentOf<CustomerViewProps, CustomerViewState> {
    function new(props):Void {
        super(props);
        state = {
            selectedOrderForm: EightyNine,
            delivery: ({
                creationTime: null,
                deliveryCode: null,
                couriers: null,
                orders: [{
                    creationTime: null,
                    orderCode: null,
                    shop: EightyNine,
                    orderDetails: null,
                    orderPrice: 0.0,
                    platformServiceCharge: 0.0,
                    wantTableware: null,
                    customerNote: null,
                }],
                customer: {
                    tg: null,
                    tel: null,
                },
                customerPreferredContactMethod: null,
                paymentMethods: [],
                pickupLocation: null,
                pickupTimeSlot: null,
                pickupMethod: null,
                deliveryFee: null,
                customerNote: null,
            }:Delivery),
            items: [],
            isValid: false,
        };
    }

    function handleTelegramResponse(response) {
        setState({
            delivery: state.delivery.with({
                customer: state.delivery.customer.with({
                    tg: state.delivery.customer.tg.with({
                        id: response.id,
                        username: response.username,
                    })
                }),
            }),
        });
    }

    inline static final dollar = "$";

    override function render() {
        var orderContent = switch (state.selectedOrderForm) {
            case null:
                jsx('
                    <Grid container spacing=${Spacing_1}>
                        <Grid item xs=${12}>
                            <Typography variant=${H2} align=${Center}>落單</Typography>
                        </Grid>
                        <Grid item container xs=${12} spacing=${Spacing_3} justify=${Center}>
                            <Grid item>
                                <Button
                                    color=${Primary}
                                    href="https://docs.google.com/forms/d/e/1FAIpQLSfKw5JY0no7Tgu7q0hT2LP05rJ23DCMRIcCjxfwyapfSMl-Bg/viewform"
                                >
                                    ${YearsHK.info().name}
                                </Button>
                            </Grid>
                            <Grid item>
                                <Button
                                    color=${Primary}
                                    onClick=${(evt) -> state.selectedOrderForm = EightyNine}
                                >
                                    ${EightyNine.info().name}
                                </Button>
                            </Grid>
                            <Grid item>
                                <Button
                                    color=${Primary}
                                    href="https://docs.google.com/forms/d/e/1FAIpQLSfvb1PDjceErVgyogijVDxkN3pXu0djpBFzc_H59oqrdSH0mQ/viewform"
                                >
                                    ${DragonJapaneseCuisine.info().name}
                                </Button>
                            </Grid>
                            <Grid item>
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
                    setState({
                        isValid: isValid,
                        delivery: state.delivery,
                    });
                }
                function onPickupTimeSlotChange(slot:TimeSlot) {
                    setState({
                        delivery: state.delivery.with({
                            pickupTimeSlot: slot,
                        }),
                    });
                }
                var pickupTimeSlotOptions = state.delivery.orders[0].shop.nextTimeSlots(Date.now());
                jsx('
                    <EightyNineOrderForm
                        order=${state.delivery.orders[0]}
                        items=${state.items}
                        pickupTimeSlot=${state.delivery.pickupTimeSlot}
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
            case FastTasteSSP:
                null;
        }
        function onAddressChange(evt:js.html.Event) {
            setState({
                delivery: state.delivery.with({
                    pickupLocation: (cast evt.target).value,
                }),
            });
        }
        var pickupMethodItems = [
            Door,
            HangOutside,
            Street,
        ]
            .map(v -> v.info())
            .map(info -> jsx('
                <MenuItem key=${info.id} value=${info.id}>${info.name}</MenuItem>
            '));
        function onPickupMethodChange(evt, elm) {
            setState({
                delivery: state.delivery.with({
                    pickupMethod: (cast evt.target).value,
                }),
            });
        }
        var customerTg = if (state.delivery.customer.tg != null) {
            if (state.delivery.customer.tg.username != null)
                jsx('
                    <Typography>
                        Telegram username: <a href=${"https://t.me/" + state.delivery.customer.tg.username} target="_blank">@${state.delivery.customer.tg.username}</a>
                    </Typography>
                ');
            else
                jsx('
                    <Typography>
                        Telegram ID: ${Std.string(state.delivery.customer.tg.id)}
                    </Typography>
                ');
        } else {
            jsx('
                <TelegramLoginButton
                    botName=${props.tgBotName}
                    dataOnauth=${handleTelegramResponse}
                />
            ');
        }
        return return jsx('
            <Container maxWidth=${SM}>
                <Grid container>
                    <Typography>
                        * 必填項目
                    </Typography>
                </Grid>
                <Grid container>
                    <Grid item xs=${12}>
                        ${orderContent}
                    </Grid>
                </Grid>
                <Divider variant=${Middle} />
                <Grid container>
                    <Grid item xs=${12}>
                        <Typography variant=${H5} gutterBottom>
                            有關運費
                        </Typography>
                        <Typography paragraph>
                            設定運費嘅原則:<br/>
                            ${dollar}25 - 步行15分鐘或以內<br/>
                            ${dollar}35 - 步行15至20分鐘<br/>
                            ${dollar}40 - 距離較遠需要車手負責外賣<br/>
                            價格會因應實際情況(如長樓梯)調整。
                        </Typography>
                        <Typography paragraph>
                            落單後，平台會因應地址及價目表計算運費，外賣員送餐前會經tg同你確認一次價錢。
                        </Typography>
                    </Grid>
                    <Grid item xs=${12}>
                        <TextField
                            label="交收地址"
                            required
                            value=${state.delivery.pickupLocation != null ? state.delivery.pickupLocation: ""}
                            onChange=${onAddressChange}
                        />
                    </Grid>
                    <Grid item xs=${12}>
                        <FormControl required>
                            <InputLabel id="select-pickup-method">
                                交收方法
                            </InputLabel>
                            <Select
                                labelId="select-pickup-method"
                                value=${state.delivery.pickupMethod != null ? state.delivery.pickupMethod : ""}
                                onChange=${onPickupMethodChange}
                            >
                                ${pickupMethodItems}
                            </Select>
                        </FormControl>
                    </Grid>
                    <Grid item xs=${12}>
                        ${customerTg}
                    </Grid>
                </Grid>
            </Container>
        ');
    }
}