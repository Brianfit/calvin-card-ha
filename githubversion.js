class CALVINcard extends HTMLElement {

    config;
    content;

    // required
    setConfig(config) {
        this.config = config;
    }


set hass(hass) {
    if (!this.content) {
        this.innerHTML = `
            <ha-card>
                <div id="content"></div>
            </ha-card>`;
        this.content = this.querySelector('#content');
        this.imageElement = document.createElement('img');
        this.imageElement.style.width = '100%';
        this.content.appendChild(this.imageElement);
    }

    const now = Date.now();
    const refreshInterval = 3 * 60 * 60 * 1000; // 3 hours in milliseconds

    if (!this.lastUpdate || (now - this.lastUpdate) > refreshInterval) {
        this.lastUpdate = now;
        this.imageUrl = `/local/community/calvin-card-ha/calvin.png?_ts=${this.lastUpdate}`;
    }

    if (this.imageElement.src !== this.imageUrl) {
        this.imageElement.src = this.imageUrl;
        console.log('Image updated:', this.imageUrl);
    } else {
        console.log('Image not updated; using existing URL.');
    }
}

    getCardSize() {
        return ;
    }
}

window.customCards = window.customCards || [];
window.customCards.push({
    type: "calvin-card",
    name: "calvin",
    description: "Your daily dose of Calvin and Hobbes." // optional
});

customElements.define('calvin-card', CALVINcard);