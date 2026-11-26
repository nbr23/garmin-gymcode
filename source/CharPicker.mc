using Toybox.Graphics;
using Toybox.WatchUi;

class CharPicker extends WatchUi.Picker {
    hidden var _factory;
    hidden var _title;
    hidden var _prompt;
    hidden var _onDone;
    hidden var _text = "";

    function initialize(prompt, charset, onDone) {
        _factory = new CharacterFactory(charset);
        _prompt  = WatchUi.loadResource(prompt);
        _onDone  = onDone;
        _title   = new WatchUi.Text({
            :text  => _prompt,
            :color => Graphics.COLOR_WHITE,
            :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY  => WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        Picker.initialize({:title => _title, :pattern => [_factory]});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    function accept(value) {
        if (_factory.isDone(value)) {
            _onDone.invoke(_text);
            return;
        }
        _text += value;
        _title.setText(_text);
    }

    function back() {
        if (_text.length() == 0) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return;
        }
        _text = _text.substring(0, _text.length() - 1);
        _title.setText(_text.length() == 0 ? _prompt : _text);
    }
}

class CharPickerDelegate extends WatchUi.PickerDelegate {
    hidden var _picker;

    function initialize(picker) {
        PickerDelegate.initialize();
        _picker = picker;
    }

    function onAccept(values) {
        _picker.accept(values[0]);
        return true;
    }

    function onCancel() {
        _picker.back();
        return true;
    }
}
