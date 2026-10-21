const CALVIN_BASE = '/local/community/calvin-card-ha/';
// How often an open dashboard checks for a newly downloaded comic.
// The check only reads a tiny JSON file; the image is re-downloaded only when it has changed.
const CALVIN_CHECK_INTERVAL_MS = 15 * 60 * 1000;

class CALVINcard extends HTMLElement {
    config;
    content;
    lastVersion = null;
    timer = null;
    checking = false;

    setConfig(config) {
        this.config = config;
    }

    connectedCallback() {
        // Poll while the card is on screen, and check right away when a
        // sleeping tablet or background tab becomes visible again.
        if (!this.timer) {
            this.timer = setInterval(() => this.checkForNewComic(), CALVIN_CHECK_INTERVAL_MS);
        }
        this.onVisible = () => {
            if (document.visibilityState === 'visible') this.checkForNewComic();
        };
        document.addEventListener('visibilitychange', this.onVisible);
        if (this.content) this.checkForNewComic();
    }

    disconnectedCallback() {
        clearInterval(this.timer);
        this.timer = null;
        document.removeEventListener('visibilitychange', this.onVisible);
    }

    async fetchData() {
        try {
            const response = await fetch(`${CALVIN_BASE}calvin_data.json?_=${Date.now()}`, { cache: 'no-store' });
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return await response.json();
        } catch (error) {
            console.error('Failed to fetch Calvin data:', error);
            return null;
        }
    }

    // A value that changes whenever calvin.sh downloads a new comic.
    // Falls back to the caption, then to today's date, for older data files.
    getVersion(data) {
        if (data?.updated) return String(data.updated);
        if (data?.alt_text) return data.alt_text;
        return new Date().toDateString();
    }

    render() {
        this.content.innerHTML = `
            <style>
                .image-container {
                    position: relative;
                    width: 100%;
                }
                .calvin-image {
                    width: 100%;
                    display: block;
                }
                .title-text {
                    padding: 8px;
                    text-align: center;
                    font-size: 0.9em;
                    color: var(--primary-text-color);
                }
            </style>
            <div class="image-container">
                <img class="calvin-image" alt="Calvin and Hobbes">
                <div class="title-text" hidden></div>
            </div>
        `;
    }

    async checkForNewComic() {
        if (!this.content || this.checking) return;
        this.checking = true;
        try {
            const data = await this.fetchData();
            const version = this.getVersion(data);
            if (version === this.lastVersion) return;
            this.lastVersion = version;

            if (!this.content.querySelector('.image-container')) this.render();

            const img = this.content.querySelector('.calvin-image');
            img.src = `${CALVIN_BASE}calvin.png?v=${encodeURIComponent(version)}`;
            img.alt = data?.alt_text || 'Calvin and Hobbes';

            const titleDiv = this.content.querySelector('.title-text');
            titleDiv.textContent = data?.title || '';
            titleDiv.hidden = !data?.title;
        } finally {
            this.checking = false;
        }
    }

    set hass(hass) {
        if (!this.content) {
            this.innerHTML = `
                <ha-card>
                    <div id="content"></div>
                </ha-card>`;
            this.content = this.querySelector('#content');
            this.checkForNewComic().catch(error =>
                console.error('Failed to update Calvin card:', error)
            );
        }
    }

    getCardSize() {
        return 3;
    }
}

if (!customElements.get('calvin-card')) {
    customElements.define('calvin-card', CALVINcard);
}

window.customCards = window.customCards || [];
window.customCards.push({
    type: "calvin-card",
    name: "calvin",
    description: "Your daily dose of Calvin and Hobbes"
});
