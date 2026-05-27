using Toybox.WatchUi;

class GymCodeDelegate extends WatchUi.BehaviorDelegate {
    hidden var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onNextPage() {
        _view.next();
        return true;
    }

    function onPreviousPage() {
        _view.previous();
        return true;
    }
}
