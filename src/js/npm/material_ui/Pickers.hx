package js.npm.material_ui;

import react.*;

@:jsRequire("@material-ui/pickers", "MuiPickersUtilsProvider")
extern class MuiPickersUtilsProvider extends ReactComponent {}

@:jsRequire("@material-ui/pickers", "DatePicker")
extern class DatePicker extends ReactComponent {}

@:jsRequire("@material-ui/pickers", "TimePicker")
extern class TimePicker extends ReactComponent {}

@:jsRequire("@material-ui/pickers", "DateTimePicker")
extern class DateTimePicker extends ReactComponent {}

@:jsRequire("@date-io/moment")
extern class MomentUtils extends ReactComponent {}
