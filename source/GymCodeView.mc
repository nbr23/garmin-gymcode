using Toybox.WatchUi;
using Toybox.Graphics;

class GymCodeView extends WatchUi.View {
    // [name, numeric code] — FIXME set your memberships here
    private const MEMBERSHIPS = [
        ["Gym", ""],
        ["Pool", ""]
    ];

    hidden var _values  = null;
    hidden var _modules = 0;
    hidden var _index   = 0;

    function initialize() {
        View.initialize();
    }

    private function _loadCurrent() {
        if (MEMBERSHIPS.size() == 0) {
            return;
        }
        _values  = Code39.encode(MEMBERSHIPS[_index][1]);
        _modules = Code39.getTotalModules(_values);
    }

    function next() {
        if (MEMBERSHIPS.size() == 0) {
            return;
        }
        _index = (_index + 1) % MEMBERSHIPS.size();
        _loadCurrent();
        WatchUi.requestUpdate();
    }

    function previous() {
        if (MEMBERSHIPS.size() == 0) {
            return;
        }
        _index = (_index - 1 + MEMBERSHIPS.size()) % MEMBERSHIPS.size();
        _loadCurrent();
        WatchUi.requestUpdate();
    }

    function onShow() {
        _loadCurrent();

        // Force backlight on for barcode scanning
        if (Toybox has :Attention) {
            if (Toybox.Attention has :backlight) {
                Toybox.Attention.backlight(true);
            }
        }
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();

        if (_values == null) {
            return;
        }

        // Use the full screen width for the barcode.  Bars near the
        // edges will be clipped by the round display — that's fine,
        // the scanner only needs one horizontal scan line through the
        // center where every bar is fully visible.
        var quietZone    = 5; // narrow modules each side
        var totalUnits   = _modules + 2 * quietZone;

        // Bar height: nearly full screen. The round bezel clips the
        // corners; the centre strip stays intact for the scanner.
        var barHeight = (h * 80) / 100;
        var barY      = (h - barHeight) / 2;

        // Proportional pixel placement: map each unit edge to a pixel
        // position across the full screen width so bars get sub-unit
        // rounding distributed evenly (no cumulative error).
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        var units = quietZone; // start after left quiet zone
        for (var i = 0; i < _values.size(); i++) {
            var bw = Code39.getBarWidths(_values[i]);
            for (var j = 0; j < bw.size(); j++) {
                var x1 = (units * w) / totalUnits;
                units += bw[j];
                var x2 = (units * w) / totalUnits;
                if (j % 2 == 0) { // bar (black)
                    dc.fillRectangle(x1, barY, x2 - x1, barHeight);
                }
            }
            // Inter-character gap (1 narrow unit)
            if (i < _values.size() - 1) {
                units += 1;
            }
        }

        // Membership name above the barcode
        dc.drawText(
            w / 2,
            barY - dc.getFontHeight(Graphics.FONT_XTINY) - 2,
            Graphics.FONT_XTINY,
            MEMBERSHIPS[_index][0],
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function onHide() {
        if (Toybox has :Attention) {
            if (Toybox.Attention has :backlight) {
                Toybox.Attention.backlight(false);
            }
        }
    }
}
