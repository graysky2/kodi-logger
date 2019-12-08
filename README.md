## Description
Keeps track of every video you watch on Kodi (XBMC).

## Dependencies
* bash >=4.0
* coreutils
* gawk
* sed

## Installation and Setup
Copy `kodi18.logger.sh`to a public directory such as `/usr/local/bin/` and make it executable.
```
% cp /path/to/kodi18-logger.sh /usr/local/bin/kodi18-logger.sh
% chmod 755 /usr/local/bin/kodi18-logger.sh
```

The script expects to have write access to `/var/log/kodi-watched.log` so you will need to manually create this file and change the ownership of it to the user who shall run the script:

```
# touch /var/log/kodi-watched.log
# chown myuser:mygroup /var/log/kodi-watched.log
```

* Optionally change the `LOG` variable to reflect another path (this is the log file Kodi generates).
* Optionally change the `FINAL` variable to reflect another path (this is final we generate with all the watched content).

## Usage
To use kodi-logger, simply call the script at some regular interval (once an hour for example) which is easily accomplished with a crontab:

```
crontab -l
0 * * * *	/usr/local/bin/kodi18-logger.sh
```

The extracted output is saved to the directory you specify in the script itself and simply shows the date/time and file name that was viewed.

## Example log
```
Thu Jul 18 10:50:01 AM 2013 /media/DVD_Rips/Sopranos/Season_3/3x01-Mr._Ruggerios_Neighborhood.mkv
Thu Jul 18 12:50:01 PM 2013 /media/DVD_Rips/Sopranos/Season_3/3x02-Proshai_Livushka.mkv
Thu Jul 18 10:50:01 PM 2013 /media/DVD_Rips/Sopranos/Season_3/3x03-Fortunate_Son.mkv
Fri Jul 19 08:20:01 PM 2013 /media/DVD_Rips/Movies/There_Will_Be_Blood.mkv
Sat Jul 20 08:30:02 PM 2013 /media/DVD_Rips/Movies/The_Girl_With_the_Dragon_Tattoo_2011.mkv
```
