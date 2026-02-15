using Toybox.WatchUi;
using Toybox.Graphics;

(:glance)
class GymCodeGlanceView extends WatchUi.GlanceView {

    function initialize() {
        GlanceView.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(
            0,
            dc.getHeight() / 2,
            Graphics.FONT_GLANCE,
            "Gym Barcode",
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
