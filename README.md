# calvin-card-ha [![hacs_badge](https://img.shields.io/badge/HACS-Custom-41BDF5.svg?style=for-the-badge)](https://github.com/hacs/integration) <a href="https://www.buymeacoffee.com/brianfit" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height:25px!important; width:100px!important;" ></a>

A HACS routine which pulls a different Calvin and Hobbes comic into your Home Assistant dashboard every day. 

"Why can't I just grab the image in a picture entity from the RSS feed" you ask?  Because browsers cache images, Spaceman Spiff. It's normally a feature, but when you want to point to a file that gets refreshed regularly, it's a bug. We need to trick the browser into thinking it hasn't seen the url it's fetching the comic from, and we do that with this nifty trick, built right into the card:

        const imageUrl = `/local/calvin-card-had/calvin.png?_ts=${new Date()}`;
        this.content.innerHTML = `<img src="${imageUrl}" style="width: 100%;">`;

Get it? If not, it doesn't matter. Just think of it as Galaxoid and Nebular beaming a new comic into your dashboard from their alien spacecraft. 

## Installation

Unless and until this card becomes a HACS default and findable within the Home Assistand Community Store Search, you'll need to install it as a custom repository. Right click the "Code" link in the upper left of this page and copy the URL. Go to HACS your Home Assistant. Click on the the three dots in the upper right. Click "Custom Repository" and paste the url into the url box. Choose "Lovelace" as the category. Download the card files with the "Download" button lower right and voila! You can now add a Calvin Card to your dashboard (you'll find it all the way at the bottom of the card choices behind the + sign.) You probably want to add the following code or similar to make it look good in your setup: 

> [!IMPORTANT]
> <strong> There are multiple files the install should download into your /config/www/community/calvin-card-ha but users are reporting only calvin-card.js and calvin-card.js.gz are showing up. If this is the case, you'll need to download the following files from this repository and manually install them in that directory: calvin.png, calvin_json.data, and calvin.sh - I'm working to fix this!
</strong>


```
grid_options:
  columns: 24
  rows: 6
aspect_ratio: 32%
```

> [!IMPORTANT]
> <strong> If you just install the card, you'll only see the default comic. Every day. I mean it's a good one, but if you want to see it refresh, you need to create an automation! </strong>

Good news is it's easy. When the card installs, it creates a file called calvin.sh

You'll want to run that every 24 hours to get the latest comic. First, open up your configuration.yaml and add the following code:

```
shell_command:
   run_calvin: "sh /config/www/community/calvin-card-ha/calvin.sh"
```


> [!IMPORTANT]
> Go to the Developers menu, click on "Check Configuration" and "Restart Home Assistant" (Really restart it, don't just reload the YAML. You're creating a new entity, and you won't have access to it until you restart Home Assistant.)

### Set up your automation

Got to the Settings Menu and choose "Automations and Scenes"

<a href="#"><img src = "https://github.com/Brianfit/images/blob/main/automations%26scenes.jpg">
</a>

Click on the "Create Automation" button lower right. 

<a href="#">
<img src="https://github.com/Brianfit/images/blob/main/create.jpg" height="25%" width=25%>
</a>

Click "Create New Automation"
<a href="#">
<img src="https://github.com/Brianfit/images/blob/main/new.jpg" height="50%" width="50%">
</a>


Choose "Time"

<a href="#">
<img src = "https://github.com/Brianfit/images/blob/main/time.jpg" height="50%" width="50%">
</a>

And choose a time to run every day, or for example a 12 hour interval. 

<a href="#">
<img src="https://github.com/Brianfit/images/blob/main/actionclicks.jpg" height="50%" width="50%">
</a>

Skip the optional middle bit of "And if" and click 'Add Action' 

<a href="#">
<img src = "https://github.com/Brianfit/images/blob/main/actionpopup.jpg" height="50%" width="50%">
</a>

If you've properly set up your shell commands in configuration.yaml AND restarted HA (you really restarted, didn't just reload the yaml, right?) you should see an autocomplete when you type "shell". In the example above, my configuration.yaml looked like this:

<a href="#">
<img src = "https://github.com/Brianfit/images/blob/main/multishell.jpg">
</a>

NB: when you have more than one shell command, they need to be gathered under one header like the above. If you scatter them in your yaml the last one will be the only one loaded. 

Click the plus sign to add `shell_command.run_calvin` to the action. 


Every day at the time you specify, a json file and the image calvin.png will be downloaded, to then be fetched by the card using a unique date-stamped URL, thus foiling the evil image-caching plans of Spaceman Spiff's nemesis. 
> [!NOTE]
> Mouseover the comic to see the alt-text below the image

## Credits

Calvin and Hobbes was created by Bill Watterson. This card relies on the outstanding work of Joseph Dykstra and the community that maintains <a href="https://www.comicsrss.com/">Comics RSS</a>, please consider supporting them via  <a href="https://www.patreon.com/bePatron?u=6855838">Patreon</a> or <a href="https://paypal.me/artskydj">PayPal</a>.  This HACS Card carries a Creative Commons BY NC license - meaning you are free to share provided attribution is made and the work is not used for commercial purposes. 

Thanks also to u/lau1406 and the guys and gals in <a href="https://www.reddit.com/r/homeassistant/comments/zwf4z1/i_integrated_calvin_comics_into_home_assistant/">this Reddit thread </a> who created a card as camera element before HA changed the way that element works and broke it. 

## License
<p align="center">
<img src="https://bob.bigw.org/ch/quote.jpg" alt="Charlie Brown and Snoopy approve." height="55%" width="55%">
</p>
This card was made by Brian Fitzgerald under a Creative Commons BY-NC license. You are free to use or modify the code under two conditions: you don't sell it and you mention I made it. 
This card delivers content made by Bill Watterson. 

[![License: CC BY-NC 4.0](https://licensebuttons.net/l/by-nc/4.0/80x15.png)](https://creativecommons.org/licenses/by-nc/4.0/)

## Say Thanks
This is one of many open source projects I create or contribute to. I buy coffee for folks who do stuff for free that I love, and I love it when people show appreciation to me for doing stuff I love. If more of the world worked like the buy-me-a-coffee economy of generosity and appreciation and work for the love of creating something, well we'd all make Kurt Vonnegut proud. 

<p align="center">
<a href="https://www.buymeacoffee.com/brianfit" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
</p>





