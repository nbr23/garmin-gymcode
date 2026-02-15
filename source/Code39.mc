module Code39 {

    // Code 39 patterns for digits 0-9.
    // Each character has 9 elements (5 bars + 4 spaces, alternating bar/space).
    // Narrow = 1, Wide = 3 (ratio 1:3). Packed as a 9-digit integer.
    var DIGIT_PATTERNS = [
        111331311, // 0
        311311113, // 1
        113311113, // 2
        313311111, // 3
        111331113, // 4
        311331111, // 5
        113331111, // 6
        111311313, // 7
        311311311, // 8
        113311311  // 9
    ];

    // Start/stop character (*)
    var STAR_PATTERN = 131131311;

    // Encode a numeric string. Returns an array of packed patterns
    // (start *, data digits, stop *).
    function encode(data) {
        var len = data.length();
        var values = new [len + 2];
        values[0] = STAR_PATTERN;
        for (var i = 0; i < len; i++) {
            var d = data.substring(i, i + 1).toNumber();
            values[i + 1] = DIGIT_PATTERNS[d];
        }
        values[len + 1] = STAR_PATTERN;
        return values;
    }

    // Unpack a 9-digit packed pattern into an array of widths.
    function getBarWidths(pattern) {
        var w = new [9];
        for (var i = 8; i >= 0; i--) {
            w[i] = pattern % 10;
            pattern = pattern / 10;
        }
        return w;
    }

    // Total modules for the full barcode (symbols + inter-character gaps).
    function getTotalModules(values) {
        var total = 0;
        for (var i = 0; i < values.size(); i++) {
            var w = getBarWidths(values[i]);
            for (var j = 0; j < w.size(); j++) {
                total += w[j];
            }
        }
        // 1-module narrow gap between each pair of characters
        total += values.size() - 1;
        return total;
    }
}
