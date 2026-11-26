using Toybox.Graphics;
using Toybox.WatchUi;

class CharacterFactory extends WatchUi.PickerFactory {
    hidden const DONE = -1;
    hidden var _charset;

    function initialize(charset) {
        PickerFactory.initialize();
        _charset = charset;
    }

    function getSize() {
        return _charset.length() + 1;
    }

    function getValue(index) {
        if (index == _charset.length()) {
            return DONE;
        }
        return _charset.substring(index, index + 1);
    }

    function getDrawable(index, selected) {
        var text = Rez.Strings.Ok;
        if (index < _charset.length()) {
            text = getValue(index);
            if (text.equals(" ")) {
                text = "_";
            }
        }
        return new WatchUi.Text({
            :text  => text,
            :color => Graphics.COLOR_WHITE,
            :font  => Graphics.FONT_LARGE,
            :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY  => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }

    function isDone(value) {
        return value == DONE;
    }
}
