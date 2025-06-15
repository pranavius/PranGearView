# PranGearView
*A lightweight, customizable way to view your equipped gear*

## Highlights
- Allows for a wide range of text customization (size, color, outline, and more to come!)
- Lets you know when items are missing sockets, gems, and enchants
- Can show gear information when inspecting players
- Provides an interface for customizing the order of secondary and tertiary stats under the *Enchancements* category based on class and specialization
- Shows abbreviated names for item enchants to reduce visual clutter
- Allows quick showing/hiding of enchant text if you are only concerned with the quality of the enchant (Dragonflight enchants and onward)
- Indicates when equipped items have embellishments
- Option to expand Character Info window so that gear information is more easily readable
- DataBroker integration for quick access to options via minimap icon or other DataBroker AddOns

## Summary
**PranGearView** allows you to display customized information about your character in the Character Info window. If you want to know what item level each equipped item is, whether any sockets, gems, or enchants are missing, or what each equipped item's durability is, then this AddOn will serve you well. It is designed to be used on top of Blizzard's default Character Info window with the goal of not needing to install entire UI packs to have this information available.

As mentioned earlier, this AddOn was developed to work on Blizzard's default Character Info UI, so this may cause unexpected interactions when run with other AddOns or UI packs. If you would like to report any issues, please reach out with a description of the problem along with a list of all AddOns that were enabled when this was observed. Screenshots can also be helpful in troubleshooting and fixing these types of issues.

### Current Locales/Languages Supported:
- English (US and GB)
- Portuguese (BR)
- Russian (RU) [*partial*]

## Usage
You can use the options window to modify all available options. To open the options window from the Chat window, type the slash command `/pgv`.

### Options Window
- **Item Level**: Display item levels for equipped items
- **Upgrade Track**: Display upgrade tracks for eqipped items
- **Gems**: Display gem and socket information for equipped items
- **Enchants**: Display enchant information for equipped items
- **Durability**: Display durability percentages for equipped items

#### Customization Options
- **Item Level**: Change text size, outline, and color
- **Upgrade Track**: Change text size, outline, and color
- **Gems**: Change icon size, show missing gems and sockets, only show missing gems and sockets for max level characters
- **Enchants**: Change text size, text outline, show missing enchants, only show missing enchants for max level characters, change text color
- **Durability**: Change text size
- **Inspect Window**: Choose which information (if any) to display when inspecting other players
- **Character Stats**: Set stat order based on class and specialization
- **Other Options**: Show minimap icon, Increase the size of the Character Info window, place item levels on equipment, show embellishments, hide shirt & tabard info, show debugging messages (you should never need to enable this)

### Slash Commands
All slash commands can be invoked using the prefix `/prangearview` or `/pgv`. Examples listed here use `/pgv` for brevity.

- `/pgv`: Opens the Options window
- `/pgv help`: List all available slash commands for the AddOn
- `/pgv ilvl`: Toggle showing item level
  - This is the same as clicking the **Item Level** checkbox in the Options window
- `/pgv track`: Toggle showing upgrade track
  - This is the same as clicking the **Upgrade Track** checkbox in the Options window
- `/pgv gems`: Toggle showing gem info
  - This is the same as clicking the **Gems** checkbox in the Options window
- `/pgv ench`: Toggle showing enchant info
  - This is the same as clicking the **Enchants** checkbox in the Options window
- `/pgv dur`: Toggle showing durability info
  - This is the same as clicking the **Durability** checkbox in the Options window
- `/pgv etext`: Toggle showing enchant text in the Character Info window
  - This is the same as clicking the **Show Enchant Text** or **Hide Enchant Text** button in the Character Info window
- `/pgv inspect`: Toggle showing gear info when inspecting another player
  - This is the same as clicking the **Show Gear Info on Inspect** checkbox under the **Inspect Window** section of the Options window
- `/pgv expand`: Toggle using a larger Character Info window to view gear info
  - This is the same as clicking the **Larger Character Info Window** checkbox under the **Other Options** section of the Options window
- `/pgv minimap`: Show/hide the minimap icon
  - This is the same as clicking the **Show Minimap Icon** checkbox under the **Other Options** section of the Options window

## Planned Updates
The goal of this AddOn is to provide maximum customization capabilities on the default Blizzard UI. There is much more work to be done to help achieve this, including some of the items listed below. Suggestions and feedback on customization features are always welcome.

- Increased language support (*Looking for translators!*)
- Customizable borders for gear icons and backgrounds for the character model
- Per-spec gear "wishlist" to track items you want to obtain
- Displaying additional useful stats (such as GCD) in Character Stats pane
- Reordering all stats in the Character Stats pane

## Development
To report any bugs or request additional features, please open a new issue in the [GitHub repository](https://github.com/pranavius/PranGearView/issues). Before doing so, please review the list of currently open issues to see if there is already one that matches yours.

If you would like to contribute to development, please clone the repository locally and open a pull request with your proposed changes.

## Contact
**Twitter/X**: [PranaviusWoW](https://x.com/pranaviuswow)

**GitHub**: [Pranavius](https://github.com/pranavius)

**Email**: [pranavius1@gmail.com](mailto:pranavius1@gmail.com)