import Foundation

class ColoursCss: Page {
    let title: String = "Colours CSS"
    lazy var route: Route = .init(
        path: "/colours.css",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request _: HTTPRequest?) -> Data {
        let css = """
        /* ============================================
           LIGHT MODE - Default & System Preference
           ============================================ */
        :root {
            /* Background colours */
            --bg-page: #f5f5f5;
            --bg-card: white;
            --bg-card-secondary: #f9f9f9;
            --bg-card-hover: #f0f0f0;
            --bg-code: #f4f4f4;
            --bg-social-icon: #fafafa;

            /* Text colours */
            --text-primary: #333;
            --text-secondary: #666;
            --text-tertiary: #777;
            --text-muted: #888;
            --text-content: #444;
            --text-hover: #555;
            --text-code: #e83e8c;

            /* Link colours */
            --link-primary: #0066cc;
            --link-hover: #004499;
            --link-bg-hover: rgba(0, 102, 204, 0.1);

            /* Border colours */
            --border-light: #eee;
            --border-medium: #e0e0e0;
            --border-dark: #d0d0d0;
            --border-darker: #b0b0b0;

            /* Shadow colours */
            --shadow-light: rgba(0, 0, 0, 0.1);
            --shadow-medium: rgba(0, 0, 0, 0.15);
            --shadow-text: rgba(0, 0, 0, 0.15);
            --shadow-overlay: rgba(0, 0, 0, 0.15);
            --shadow-overlay-hover: rgba(0, 0, 0, 0.3);

            /* Theme state for toggle icon */
            --theme-sun-opacity: 1;
            --theme-sun-rotation: 0deg;
            --theme-moon-opacity: 0;
            --theme-moon-rotation: -90deg;

            /* Icon filter for dark mode */
            --icon-filter: none;
        }

        /* ============================================
           DARK MODE - System Preference
           ============================================ */
        @media (prefers-color-scheme: dark) {
            :root {
                --bg-page: #1a1a1a;
                --bg-card: #2d2d2d;
                --bg-card-secondary: #252525;
                --bg-card-hover: #3a3a3a;
                --bg-code: #2d2d2d;
                --bg-social-icon: #252525;

                --text-primary: #e0e0e0;
                --text-secondary: #b0b0b0;
                --text-tertiary: #999;
                --text-muted: #888;
                --text-content: #c0c0c0;
                --text-hover: #d0d0d0;
                --text-code: #f472b6;

                --link-primary: #66b3ff;
                --link-hover: #99ccff;
                --link-bg-hover: rgba(102, 179, 255, 0.1);

                --border-light: #3a3a3a;
                --border-medium: #444;
                --border-dark: #555;
                --border-darker: #666;

                --shadow-light: rgba(0, 0, 0, 0.3);
                --shadow-medium: rgba(0, 0, 0, 0.4);
                --shadow-text: rgba(0, 0, 0, 0.3);
                --shadow-overlay: rgba(0, 0, 0, 0.3);
                --shadow-overlay-hover: rgba(0, 0, 0, 0.5);

                --theme-sun-opacity: 0;
                --theme-sun-rotation: 90deg;
                --theme-moon-opacity: 1;
                --theme-moon-rotation: 0deg;

                --icon-filter: invert(1);
            }
        }

        /* ============================================
           MANUAL OVERRIDE - Toggle checkbox
           Checkbox checked = opposite of system pref
           ============================================ */

        /* Light system + checked = force dark */
        @media (prefers-color-scheme: light) {
            body:has(.theme-toggle-checkbox:checked) {
                --bg-page: #1a1a1a;
                --bg-card: #2d2d2d;
                --bg-card-secondary: #252525;
                --bg-card-hover: #3a3a3a;
                --bg-code: #2d2d2d;
                --bg-social-icon: #252525;

                --text-primary: #e0e0e0;
                --text-secondary: #b0b0b0;
                --text-tertiary: #999;
                --text-muted: #888;
                --text-content: #c0c0c0;
                --text-hover: #d0d0d0;
                --text-code: #f472b6;

                --link-primary: #66b3ff;
                --link-hover: #99ccff;
                --link-bg-hover: rgba(102, 179, 255, 0.1);

                --border-light: #3a3a3a;
                --border-medium: #444;
                --border-dark: #555;
                --border-darker: #666;

                --shadow-light: rgba(0, 0, 0, 0.3);
                --shadow-medium: rgba(0, 0, 0, 0.4);
                --shadow-text: rgba(0, 0, 0, 0.3);
                --shadow-overlay: rgba(0, 0, 0, 0.3);
                --shadow-overlay-hover: rgba(0, 0, 0, 0.5);

                --theme-sun-opacity: 0;
                --theme-sun-rotation: 90deg;
                --theme-moon-opacity: 1;
                --theme-moon-rotation: 0deg;

                --icon-filter: invert(1);
            }
        }

        /* Dark system + checked = force light */
        @media (prefers-color-scheme: dark) {
            body:has(.theme-toggle-checkbox:checked) {
                --bg-page: #f5f5f5;
                --bg-card: white;
                --bg-card-secondary: #f9f9f9;
                --bg-card-hover: #f0f0f0;
                --bg-code: #f4f4f4;
                --bg-social-icon: #fafafa;

                --text-primary: #333;
                --text-secondary: #666;
                --text-tertiary: #777;
                --text-muted: #888;
                --text-content: #444;
                --text-hover: #555;
                --text-code: #e83e8c;

                --link-primary: #0066cc;
                --link-hover: #004499;
                --link-bg-hover: rgba(0, 102, 204, 0.1);

                --border-light: #eee;
                --border-medium: #e0e0e0;
                --border-dark: #d0d0d0;
                --border-darker: #b0b0b0;

                --shadow-light: rgba(0, 0, 0, 0.1);
                --shadow-medium: rgba(0, 0, 0, 0.15);
                --shadow-text: rgba(0, 0, 0, 0.15);
                --shadow-overlay: rgba(0, 0, 0, 0.15);
                --shadow-overlay-hover: rgba(0, 0, 0, 0.3);

                --theme-sun-opacity: 1;
                --theme-sun-rotation: 0deg;
                --theme-moon-opacity: 0;
                --theme-moon-rotation: -90deg;

                --icon-filter: none;
            }
        }

        /* ============================================
           THEME TOGGLE STYLING
           ============================================ */
        .theme-toggle-checkbox {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .theme-toggle-label {
            position: fixed;
            top: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            background: var(--bg-card);
            border-radius: 50%;
            box-shadow: 0 2px 10px var(--shadow-light);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            z-index: 1000;
        }

        .theme-toggle-label:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 15px var(--shadow-medium);
        }

        .theme-toggle-icon {
            font-size: 24px;
            position: absolute;
            transition: opacity 0.2s ease, transform 0.3s ease;
        }

        .theme-toggle-icon.sun {
            opacity: var(--theme-sun-opacity);
            transform: rotate(var(--theme-sun-rotation));
        }

        .theme-toggle-icon.moon {
            opacity: var(--theme-moon-opacity);
            transform: rotate(var(--theme-moon-rotation));
        }
        """
        return HTTPResponse.cssResponse(cssBody: css)
    }
}
