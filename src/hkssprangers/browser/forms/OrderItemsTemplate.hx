package hkssprangers.browser.forms;

import mui.core.styles.Styles;
import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;

typedef OrderItemsTemplateProps = Dynamic;

class OrderItemsTemplate extends ReactComponentOf<OrderItemsTemplateProps, Dynamic> {
    static final RemoveButton = Styles.styled(mui.core.Fab)({
        color: "#EF4444",
        background: "#F3F4F6",
        position: Absolute,
        top: -5,
        right: -20,
        zIndex: 10,
    });

    static final Card = Styles.styled(mui.core.Card)({
        overflow: Visible,
    });

    static function DefaultArrayItem(props, removable) {
        var removeBtn = if (removable) {
            jsx('
                <RemoveButton
                    className="array-item-add"
                    disabled=${props.disabled || props.readonly}
                    onClick=${props.onDropIndexClick(props.index)}
                    size="small"
                >
                    <i className="fas fa-trash"></i>
                </RemoveButton>
            ');
        } else {
            null;
        };
        return jsx('
            <Card key=${props.key} className="mb-5">
                <CardContent className="relative">
                    ${removeBtn}
                    ${props.children}
                </CardContent>
            </Card>
        ');
    }

    override function render():ReactFragment {
        var items = if (props.items != null) {
            props.items.map(p -> DefaultArrayItem(p, true));
        } else {
            null;
        }
        return jsx('
            <div key=${'array-item-list-${props.idSchema.field("$id")}'}>
                <div>
                    ${items}
                </div>
                <div>
                    <Button
                        variant=${Outlined}
                        className="array-item-add"
                        color=${Primary}
                        onClick=${props.onAddClick}
                        disabled=${props.disabled || props.readonly}
                    >
                        <i className="fas fa-plus mr-1"></i>
                        叫多樣
                    </Button>
                </div>
            </div>
        ');
    }
}