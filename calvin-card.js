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
        const imageUrl = `/local/community/calvin-card-ha/calvin.png?_ts=${new Date().getTime()}`;
        console.log('Yes, Hobbes...')
        this.content.innerHTML = `<br /><img src="${imageUrl}" style="width: 100%;"><br />`;
    }

    getCardSize() {
        return 12;
    }
}

window.customCards = window.customCards || [];
window.customCards.push({
    type: "calvin-card",
    name: "calvin",
    description: "Your daily dose of Calvin and Hobbes." // optional
});

customElements.define('calvin-card', CALVINcard);