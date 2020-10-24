package hkssprangers.browser;

import mui.core.*;
import js.Browser.*;
import haxe.Timer;

typedef CopyButtonProps = {
    final title:String;
    final text:String;
};

typedef CopyButtonState = {
    final openMessage:Bool;
}

class CopyButton extends ReactComponentOf<CopyButtonProps, CopyButtonState> {
    function new(props) {
        super(props);
        state = {
            openMessage: false,
        };
    }

    function onClickCopy():Void {
        CopyToClipboard.call(props.text, {
            format: "text/plain",
            onCopy: function (d) {
                setState({
                    openMessage: true,
                });
                Timer.delay(() -> setState({ openMessage: false }), 4000);
            },
        });
    }

    override function render():ReactFragment {
        return jsx('
            <Tooltip
                title="成功複製"
                arrow
                open=${state.openMessage}
                disableFocusListener
                disableHoverListener
                disableTouchListener
            >
                <IconButton onClick=${onClickCopy}>
                    <i className="far fa-clipboard"></i>
                </IconButton>
            </Tooltip>
        ');
    }
}