# calvin-card-ha [![hacs\_badge](https://img.shields.io/badge/HACS-Custom-41BDF5.svg?style=for-the-badge)](https://github.com/hacs/integration) [![Buy Me A Coffee]("https://github.com/Brianfit/images/blob/main/coffee.jpg")](https://www.buymeacoffee.com/brianfit)

A HACS routine which pulls a different Calvin and Hobbes comic into your Home Assistant dashboard every day.

"Why can't I just grab the image in a picture entity from the RSS feed" you ask? Because browsers cache images, Spaceman Spiff. It's normally a feature, but when you want to point to a file that gets refreshed regularly, it's a bug. We need to trick the browser into thinking it hasn't seen the URL it's fetching the comic from, and we do that with this nifty trick, built right into the card:

```js
const imageUrl = `/local/calvin-card-ha/calvin.png?_ts=${new Date()}`;
this.content.innerHTML = `<img src="${imageUrl}" style="width: 100%;">`;
```

Get it? If not, it doesn't matter. Just think of it as Galaxoid and Nebular beaming a new comic into your dashboard from their alien spacecraft.

## Installation

[![Open your Home Assistant instance and show the repository in the frontend](https://my.home-assistant.io/badges/hacs_repository.svg)](https://my.home-assistant.io/redirect/hacs_repository/?owner=Brianfit&repository=calvin-card-ha)

You may want to add the following code or similar to make it look good in your setup:

```yaml
grid_options:
  columns: 24
  rows: 6
aspect_ratio: 32%
```

> ⚠️ **Important**
> If you just install the card, you'll only see the default comic. Every day. I mean it's a good one, but if you want to see it refresh, you need to create an automation!

Good news is it's easy. When the card installs, it creates a file called `calvin.sh`

You'll want to run that every 24 hours to get the latest comic. First, open up your `configuration.yaml` and add the following code:

```yaml
shell_command:
  run_calvin: "sh /config/www/community/calvin-card-ha/calvin.sh"
```

> ⚠️ **Important**
> Go to the Developers menu, click on "Check Configuration" and "Restart Home Assistant" (Really restart it, don't just reload the YAML. You're creating a new entity, and you won't have access to it until you restart Home Assistant.)

### Set up your automation

Go to the Settings Menu and choose "Automations and Scenes"

![Automations and Scenes](https://github.com/Brianfit/images/blob/main/automations%26scenes.jpg)

Click on the "Create Automation" button lower right.

![Create Automation](https://github.com/Brianfit/images/blob/main/create.jpg)

Click "Create New Automation"

![New Automation](https://github.com/Brianfit/images/blob/main/new.jpg)

Choose "Time"

![Choose Time](https://github.com/Brianfit/images/blob/main/time.jpg)

And choose a time to run every day, or for example a 12 hour interval.

![Action Clicks](https://github.com/Brianfit/images/blob/main/actionclicks.jpg)

Skip the optional middle bit of "And if" and click 'Add Action'

![Add Action](https://github.com/Brianfit/images/blob/main/actionpopup.jpg)

If you've properly set up your shell commands in `configuration.yaml` AND restarted HA (you really restarted, didn't just reload the YAML, right?) you should see an autocomplete when you type "shell". In the example above, my `configuration.yaml` looked like this:

![Multi Shell](https://github.com/Brianfit/images/blob/main/multishell.jpg)

NB: when you have more than one shell command, they need to be gathered under one header like the above. If you scatter them in your YAML the last one will be the only one loaded.

Click the plus sign to add `shell_command.run_calvin` to the action.

Every day at the time you specify, a JSON file and the image `calvin.png` will be downloaded, to then be fetched by the card using a unique date-stamped URL, thus foiling the evil image-caching plans of Spaceman Spiff's nemesis.

## Manual installation as a custom card

If you don't want to use the easy blue button up top to install your card, you can roll your own custom integration:

Right click the "Code" link in the upper left of this page and copy the URL. Go to HACS in your Home Assistant. Click on the three dots in the upper right.

![Three Dots](https://github.com/Brianfit/images/blob/main/threedots.jpg)

Click "Custom Repository" and paste the URL into the URL box.

![URL Lovelace](https://github.com/Brianfit/images/blob/main/urllovelace.jpg)

Choose "Lovelace" as the category.

> ⚠️ **Important**
> In a weird Hobbesian mind loop, your HACS integration is now downloaded, but it hasn't yet been downloaded.

Refresh your browser as instructed. If you now search HACS for "Calvin" you should see the custom repository among your list of "Downloaded" integrations. Click it. The GitHub `README.md` will pop up along with a big, friendly "Download" button with a fluffy tiger tummy that you can tickle. But just click the darn thing.

![Download Button](https://github.com/Brianfit/images/blob/main/downloadbutton.jpg)

And voila! You can now add a Calvin Card. Go to your dashboard and click the three dots, choose "Edit" and then "Add Card" - the blue button down at bottom right. You'll find a `Custom: Calvin Card` all the way at the bottom of the card choices.

## Credits

Calvin and Hobbes was created by Bill Watterson. This card relies on the outstanding work of Joseph Dykstra and the community that maintains [Comics RSS](https://www.comicsrss.com/). Please consider supporting them via [Patreon](https://www.patreon.com/bePatron?u=6855838) or [PayPal](https://paypal.me/artskydj). This HACS Card carries a Creative Commons BY-NC license - meaning you are free to share provided attribution is made and the work is not used for commercial purposes.

Thanks also to u/lau1406 and the folks in [this Reddit thread](https://www.reddit.com/r/homeassistant/comments/zwf4z1/i_integrated_calvin_comics_into_home_assistant/) who created a card as a camera element before HA changed the way that element works and broke it.

## License

<p align="center">
<img src="https://bob.bigw.org/ch/quote.jpg" alt="Charlie Brown and Snoopy approve." width="55%">
</p>

This card was made by Brian Fitzgerald under a Creative Commons BY-NC license. You are free to use or modify the code under two conditions: you don't sell it and you mention I made it.
This card delivers content made by Bill Watterson.

[![License: CC BY-NC 4.0](https://licensebuttons.net/l/by-nc/4.0/80x15.png)](https://creativecommons.org/licenses/by-nc/4.0/)

## Say Thanks

This is one of many open source projects I create or contribute to. I buy coffee for folks who do stuff for free that I love, and I love it when people show appreciation to me for doing stuff I love. If more of the world worked like the buy-me-a-coffee economy of generosity and appreciation and work for the love of creating something, well we'd all make Kurt Vonnegut proud.

<p align="center">
<a href="https://www.buymeacoffee.com/brianfit" target="_blank">
<img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width="217">
</a>
</p>






