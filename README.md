## /gamble
a mod for factorio
https://mods.factorio.com/mod/slashgamble

---------------------
# Overview
Adds the /gamble <all | half | random | \[amount]> chat command. 

Default currency is coins. Currency can be changed in mod settings.

Odds Breakdown:
Roll 00 - 09: Win 0.00x
Roll 10 - 19: Win 0.25x
Roll 20 - 29: Win 0.33x
Roll 30 - 39: Win 0.50x
Roll 40 - 49: Win 1.00x
Roll 50 - 59: Win 1.50x
Roll 60 - 69: Win 2.00x
Roll 70 - 79: Win 2.50x
Roll 80 - 89: Win 3.00x
Roll 90 - 94: Win 4.00x
Roll 95 - 99: Win 5.00x
Roll 100: Win 10.00x

---------------------
# Features
- Smart Bet Detection: Gambling parameters are parsed via search, so "/gamble all!" will work the same as "/gamble all". Search priority is "all" > "half" > "random" > <number>
- Smart Notifications: Only successful bets are broadcast to the server, all other notifications (not enough currency, invalid bet, etc) are just sent to the player who attempted to gamble
- Overflow Protection: If you win more than you can carry, you will be given the maximum amount possible and the rest will be spilled on the ground around you
- Spam Protection: A per-player command cooldown is enforced. Cooldown can be changed in mod settings. Default cooldown is 15 seconds
- Custom Currency: Currency can be changed in mod settings. Default currency is Coins

---------------------
# Gallery

---------------------
## Companion Mods

---------------------
# Compatibility
There are currently no known mod compatibility issues. To report a compatibility issue, please make a post on the discussion page.

---------------------
# License
/gamble © 2023 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
