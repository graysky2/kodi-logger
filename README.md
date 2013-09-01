## Description
xbmc-logger is a simple perl script that will keep a log of everything you watch on xbmc.

## Installation
Copy the script to a public directory such as /usr/local/bin and make sure it is executable.
```
cp /path/to/xbmc-logger.pl /usr/local/bin/xbmc-logger
chmod 755 /usr/local/bin/xbmc-logger
```

## Usage
To use xbmc-logger, simply call the script as the user that runs xbmc as some regular interval (once every 5 min for example) which is easily accomplished in your crontab:

```
crontab -l
*/5 * * * *	/usr/local/bin/xbmc-logger
```
The extracted output is saved to $HOME/.xbmc/xbmc-logger.log and simply shows the date/time and file name that was viewed.

## Example log
```
Thu Jul 18 10:50:01 2013 /media/DVD_Rips/Sopranos/Season_3/3x01-Mr._Ruggerios_Neighborhood.mkv
Thu Jul 18 12:50:01 2013 /media/DVD_Rips/Sopranos/Season_3/3x02-Proshai_Livushka.mkv
Thu Jul 18 22:50:01 2013 /media/DVD_Rips/Sopranos/Season_3/3x03-Fortunate_Son.mkv
Fri Jul 19 20:20:01 2013 /media/DVD_Rips/Movies/There_Will_Be_Blood.mkv
Sat Jul 20 20:30:02 2013 /media/DVD_Rips/Movies/The_Girl_With_the_Dragon_Tattoo_2011.mkv
```
