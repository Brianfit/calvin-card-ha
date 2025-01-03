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
        }

        // Store the last update timestamp
        if (!this.lastUpdate || (Date.now() - this.lastUpdate) > 3 * 60 * 60 * 1000) { // 3 hours in milliseconds
            this.lastUpdate = Date.now(); // Update the timestamp
            this.imageUrl = `/local/community/calvin-card-ha/calvin.png?_ts=${this.lastUpdate}`;
        }

        console.log('Yes, Hobbes...');
        this.content.innerHTML = `<br /><img src="${this.imageUrl}" style="width: 100%;"><br />`;
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