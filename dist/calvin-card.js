class CALVINcard extends HTMLElement {
    config;
    content;
    lastFetchDate = null;

    setConfig(config) {
        this.config = config;
    }
//let's try an async fetch of data to try to crush this flicker bug
    async fetchData() {
        try {
            const response = await fetch('/local/community/calvin-card-ha/calvin_data.json', { cache: 'no-cache' });
            const data = await response.json();
            return data;
        } catch (error) {
            console.error('Failed to fetch Calvin data:', error);
            return null;
        }
    }

    getImageUrl() {
        const currentDate = new Date().getDate();
        return `/local/community/calvin-card-ha/calvin.png?_ts=${currentDate}`;
    }

    async updateContent() {
        const currentDate = new Date().getDate();

        // Only update if the date has changed or it's the first run
        if (this.lastFetchDate !== currentDate) {
            this.lastFetchDate = currentDate;
            
            const data = await this.fetchData();
            const imageUrl = this.getImageUrl();

            if (!this.content.querySelector('.image-container')) {
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
                        <img class="calvin-image" src="${imageUrl}" alt="Calvin and Hobbes">
                        ${data?.title ? `<div class="title-text">${data.title}</div>` : ''}
                    </div>
                `;
            } else {
                const img = this.content.querySelector('.calvin-image');
                if (img && img.src !== imageUrl) {
                    img.src = imageUrl;
                }
                
                if (data?.title) {
                    let titleDiv = this.content.querySelector('.title-text');
                    if (titleDiv) {
                        titleDiv.textContent = data.title;
                    }
                }
            }
        }
    }

    set hass(hass) {
        if (!this.content) {
            this.innerHTML = `
                <ha-card>
                    <div id="content"></div>
                </ha-card>`;
            this.content = this.querySelector('#content');
        }

        this.updateContent().catch(error => 
            console.error('Failed to update Calvin card:', error)
        );
    }

    getCardSize() {
        return 3;
    }
}

customElements.define('calvin-card', CALVINcard);

window.customCards = window.customCards || [];
window.customCards.push({
    type: "calvin-card",
    name: "calvin",
    description: "Your daily dose of Calvin and Hobbes"
});