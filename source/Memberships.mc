using Toybox.Application;

module Memberships {
    const STORAGE_KEY = "memberships";

    function stored() {
        var entries = Application.Storage.getValue(STORAGE_KEY);
        return entries == null ? [] : entries;
    }

    function all() {
        var entries = [];
        entries.addAll(BuildConfig.MEMBERSHIPS);
        entries.addAll(stored());
        return entries;
    }

    function isStored(index) {
        return index >= BuildConfig.MEMBERSHIPS.size();
    }

    function add(name, code) {
        var entries = stored();
        entries.add([name, code]);
        Application.Storage.setValue(STORAGE_KEY, entries);
        return BuildConfig.MEMBERSHIPS.size() + entries.size() - 1;
    }

    function remove(index) {
        var entries = stored();
        var i = index - BuildConfig.MEMBERSHIPS.size();
        var kept = entries.slice(0, i);
        kept.addAll(entries.slice(i + 1, null));
        Application.Storage.setValue(STORAGE_KEY, kept);
    }
}
