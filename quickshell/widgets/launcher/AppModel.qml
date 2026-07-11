import Quickshell
import QtQuick

// Non-visual, reusable app-search model shared by every launcher variant.
// Set `search`; read `apps` (a ranked, filtered list of DesktopEntry).
QtObject {
    id: root

    property string search: ""

    // `keywords`/`categories` come through as string lists, so coerce every
    // field to a string before matching (String([]) joins with commas).
    function haystack(a) {
        return (String(a.name || "") + " " + String(a.genericName || "") + " " + String(a.comment || "") + " " + String(a.keywords || "")).toLowerCase();
    }

    readonly property var apps: {
        const all = DesktopEntries.applications.values.filter(a => !a.noDisplay);
        const q = root.search.trim().toLowerCase();

        if (q.length === 0)
            return all.slice().sort((x, y) => String(x.name).localeCompare(String(y.name)));

        const matches = all.filter(a => root.haystack(a).includes(q));

        // Prefix matches on the visible name rank first, then alphabetical.
        return matches.slice().sort((x, y) => {
            const xs = String(x.name).toLowerCase().startsWith(q) ? 0 : 1;
            const ys = String(y.name).toLowerCase().startsWith(q) ? 0 : 1;
            if (xs !== ys)
                return xs - ys;
            return String(x.name).localeCompare(String(y.name));
        });
    }

    function launch(index) {
        const list = root.apps;
        if (index >= 0 && index < list.length) {
            list[index].execute();
            return true;
        }
        return false;
    }
}
