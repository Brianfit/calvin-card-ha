# Calvin Card
A simple Lovelace card to display daily Calvin & Hobbes comics.

![Screenshot](https://raw.githubusercontent.com/Brianfit/images/main/screenshot.png)

## Installation
This card is available in [HACS](https://hacs.xyz/) under "Frontend". NB: You will also need to set up an automation to fetch the new card every day. Instructions included.

## Usage
```yaml
type: 'custom:calvin-card'
grid_options:
  columns: 24
  rows: 6
aspect_ratio: 32%
