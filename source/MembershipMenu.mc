using Toybox.WatchUi;

class MembershipMenu extends WatchUi.Menu2 {

    function initialize(view) {
        Menu2.initialize({:title => Rez.Strings.AppName});
        addItem(new WatchUi.MenuItem(Rez.Strings.AddCode, null, :add, null));
        var name = view.currentName();
        if (name != null && Memberships.isStored(view.currentIndex())) {
            addItem(new WatchUi.MenuItem(Rez.Strings.DeleteCode, name, :delete, null));
        }
    }
}

class MembershipMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden const NAME_CHARSET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";
    hidden const CODE_CHARSET = "0123456789";
    hidden var _view;
    hidden var _name;

    function initialize(view) {
        Menu2InputDelegate.initialize();
        _view = view;
    }

    function onSelect(item) {
        if (item.getId() == :add) {
            _switchToPicker(Rez.Strings.NamePrompt, NAME_CHARSET, method(:onNameEntered));
        } else if (item.getId() == :delete) {
            var message = WatchUi.loadResource(Rez.Strings.DeleteCode) + " " + _view.currentName() + "?";
            WatchUi.switchToView(
                new WatchUi.Confirmation(message),
                new DeleteConfirmationDelegate(_view.currentIndex()),
                WatchUi.SLIDE_IMMEDIATE
            );
        }
    }

    function onNameEntered(name) {
        _name = name;
        if (_name.length() == 0) {
            _name = WatchUi.loadResource(Rez.Strings.DefaultName) + " " + (Memberships.all().size() + 1);
        }
        _switchToPicker(Rez.Strings.CodePrompt, CODE_CHARSET, method(:onCodeEntered));
    }

    function onCodeEntered(code) {
        if (code.length() == 0) {
            return;
        }
        _view.select(Memberships.add(_name, code));
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    hidden function _switchToPicker(prompt, charset, onDone) {
        var picker = new CharPicker(prompt, charset, onDone);
        WatchUi.switchToView(picker, new CharPickerDelegate(picker), WatchUi.SLIDE_IMMEDIATE);
    }
}

class DeleteConfirmationDelegate extends WatchUi.ConfirmationDelegate {
    hidden var _index;

    function initialize(index) {
        ConfirmationDelegate.initialize();
        _index = index;
    }

    function onResponse(response) {
        if (response == WatchUi.CONFIRM_YES) {
            Memberships.remove(_index);
        }
        return true;
    }
}
