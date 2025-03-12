[![Ko-fi Donate](https://img.shields.io/badge/Ko--fi-Donate%20-indianred?logo=kofi&logoColor=white)](https://ko-fi.com/asher_sky) [![GitHub Contribute](https://img.shields.io/badge/GitHub-Contribute-blue?logo=github)](https://github.com/jingleheimer-schmidt/slashgamble) [![Crowdin Translate](https://img.shields.io/badge/Crowdin-Translate-green?logo=crowdin)](https://crowdin.com/project/factorio-mods-localization) [![Mod Portal Download](https://img.shields.io/badge/Mod_Portal-Download-orange?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAMAAACecocUAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9bS4tUHewg4hCwOlkQFXHUKhShQqgVWnUwufQLmjQkKS6OgmvBwY/FqoOLs64OroIg+AHi4uqk6CIl/i8ptIjx4Lgf7+497t4B/kaFqWbXOKBqlpFOJoRsblUIvSKMIHoxjJjETH1OFFPwHF/38PH1Ls6zvM/9OXqUvMkAn0A8y3TDIt4gnt60dM77xFFWkhTic+Ixgy5I/Mh12eU3zkWH/TwzamTS88RRYqHYwXIHs5KhEk8RxxRVo3x/1mWF8xZntVJjrXvyF0by2soy12kOIYlFLEGEABk1lFGBhTitGikm0rSf8PAPOn6RXDK5ymDkWEAVKiTHD/4Hv7s1C5MTblIkAQRfbPtjBAjtAs26bX8f23bzBAg8A1da219tADOfpNfbWuwI6NsGLq7bmrwHXO4AA0+6ZEiOFKDpLxSA9zP6phzQfwt0r7m9tfZx+gBkqKvUDXBwCIwWKXvd493hzt7+PdPq7wdcTnKeyn2biAAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+MIBQ4nOKPzX44AAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAAAnFBMVEUAAAAAAAAAAAAAAABBPj5EQ0NBQUFCQkJYV1daWlpcXFxfXl19enl7enp6enp9fX2Rjo2Ojo6RkZGUk5OfnJufn5+goKCioqK5uLe3t7e5ubm6urrPz8/Pz8/R0NDT0tHT09PV1dXW1tXh4ODh4eHg4ODh4eHi4eHi4uLi4uLi4uLk4+Pk5OTl5eXm5ubm5ubn5ubn5+fp6en+/vsJa+h2AAAAMnRSTlMAAgMEEBIUFR0jJSY8PUBDU1daX2hucHOTlpicxcbIyc7R0unq6+vt7e7v8vT2+Pn6+p+as4UAAAABYktHRDM31XxeAAAAYUlEQVQIHQXBBQLCQBDAwJTF3b0Uh2IH+f/jmAGA5yYygG65OFpOOoMMmqrqJWCoaZt0FizPpnpUP+6Dh+YR5PqGwtSIWvK6gqn+dl8dBZxU1VZArz2+eZjf+xkA61dUgD8jzgwslUkzIwAAAABJRU5ErkJggg==)](https://mods.factorio.com/mod/slashgamble)

# Overview
Adds the `/gamble <all | half | random | [amount]>` chat command. 

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
- Smart Bet Detection: Parameters are parsed via search; `/gamble all!` works the same as `/gamble all`. Priority is "all" > "half" > "random" > [number]
- Smart Notifications: Only successful bets are broadcast to the server, all other notifications are just sent to the player who attempted to gamble
- Overflow Protection: If you win more than you can carry, the overflow will be spilled onto the ground around you
- Spam Protection: A per-player command cooldown is enforced. Cooldown can be changed in mod settings. Default cooldown is 15 seconds
- Custom Currency: Currency can be changed in mod settings. Default currency is Coins

---------------------
# Translation
Help translate /gamble to more languages: https://crowdin.com/project/factorio-mods-localization
Currently available locale:
- English (en)
- Ukrainian (uk)

---------------------
# Compatibility
There are currently no known mod compatibility issues. To report a compatibility issue, please make a post on the discussion page.

---------------------
# License
/gamble © 2023-2025 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
