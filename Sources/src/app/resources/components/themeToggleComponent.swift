import Foundation

class ThemeToggleComponent {
    static let script = """
    document.getElementById('theme-toggle').addEventListener('change', function(e) {
        document.cookie = 'theme-override=' + e.target.checked + '; path=/; max-age=31536000';
    });
    """

    static func render(request: HTTPRequest?) -> String {
        let isOverride = request?.cookies["theme-override"] == "true"
        let checkedAttr = isOverride ? "checked" : ""

        return """
        <input type="checkbox" id="theme-toggle" class="theme-toggle-checkbox" \(checkedAttr)>
        <label for="theme-toggle" class="theme-toggle-label" aria-label="Toggle dark mode">
            <span class="theme-toggle-icon sun">☀️</span>
            <span class="theme-toggle-icon moon">🌙</span>
        </label>
        <script>\(script)</script>
        """
    }
}
