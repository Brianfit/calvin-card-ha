class CALVINcard extends HTMLElement {
    config;
    content;
    lastFetchDate = null; // Initialize as null to ensure the first run triggers a fetch

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

        // Debounce the image update to avoid flickering
        this.updateImage();
    }

    updateImage() {
        const currentDate = new Date().getDate();

        // Check if the current date is different from the last fetch date or if it's the first run
        if (this.lastFetchDate !== currentDate) {
            this.lastFetchDate = currentDate; // Update the last fetch date
            const imageUrl = `/local/community/calvin-card-ha/calvin.png?_ts=${currentDate}`;
            
            // Don't set the source unless the image URL has changed. Flicker suspect?
            if (this.imageElement.src !== imageUrl) {
                this.imageElement.src = imageUrl;
                console.log('Image updated:', imageUrl);
            } else {
                console.log('Image not updated; using existing URL. (Debounced)');
            }
        }
    }

    getCardSize() {
        return 3;
    }
}

window.customCards = window.customCards || [];
window.customCards.push({
    type: "calvin-card",
    name: "calvin",
    description: "Your daily dose of Calvin and Hobbes." // optional
});

customElements.define('calvin-card', CALVINcard);