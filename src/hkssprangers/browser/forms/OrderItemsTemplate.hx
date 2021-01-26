package hkssprangers.browser.forms;

import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;

typedef OrderItemsTemplateProps = Dynamic;

class OrderItemsTemplate extends ReactComponentOf<OrderItemsTemplateProps, Dynamic> {
    static function DefaultArrayItem(props) {
        var removeBtn = if (props.hasRemove) {
            jsx('
                <Button
                    className="array-item-add"
                    color=${Secondary}
                    disabled=${props.disabled || props.readonly}
                    onClick=${props.onDropIndexClick(props.index)}
                >
                    移除
                </Button>
            ');
        } else {
            null;
        }
        return jsx('
            <Card key=${props.key} className="my-2">
                <CardContent>
                    ${props.children}
                </CardContent>
                <CardActions>
                    ${removeBtn}
                </CardActions>
            </Card>
        ');
    }

    override function render():ReactFragment {
        var items = if (props.items != null) {
            props.items.map(p -> DefaultArrayItem(p));
        } else {
            null;
        }
        return jsx('
            <div key=${'array-item-list-${props.idSchema.field("$id")}'}>
                <h2>揀食咩</h2>
                <div>
                    ${items}
                </div>
                <div>
                    <Button
                        className="array-item-add"
                        color=${Primary}
                        onClick=${props.onAddClick}
                        disabled=${props.disabled || props.readonly}
                    >
                        叫多樣
                    </Button>
                </div>
            </div>
        ');
    }
}