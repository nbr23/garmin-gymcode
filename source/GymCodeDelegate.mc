using Toybox.WatchUi;

class GymCodeDelegate extends WatchUi.BehaviorDelegate {
    hidden var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onMenu() {
        WatchUi.pushView(MembershipMenu.create(_view), new MembershipMenuDelegate(_view), WatchUi.SLIDE_UP);
        return true;
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
