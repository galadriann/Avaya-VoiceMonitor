# Avaya-VoiceMonitor
This is a small contribution based on benroy@uw.edu's definity_ossi.pm  

This is a first page I contribute.  My project involves the creation of a Web page to monitor and display multiple Avaya Communication Manager's page.  

This script pull realtime trunk usage data from multiple CM and stores it on a Mysql Database for further treatment.  

I use this data to generate graphs of trunk usage.  

Installation:  
1. you need to install Perl with the "Expect" package.  This is only possible under Linux.  
2. in the pbx_connection_auth.xml file, setup your connection parameters for your multiple PBX.   
3. create a Mysql Database (I called mine "voice") and create a table with following fields :  
`id` INT autoincrement  
`location` TEXT   => will contain the location as defined in pbx_connection_auth.xml  
`trunk` INT => trunk group number  
`trunksize` INT => trunk group size, number of trunks in the trunk group  
`usage` INT => trunks used  
`datetaken` DATETIME => date and time when the value was taken  

4. update the trunkmonitor.pl script with parameters for your Mysql Database.  
run the trunkmonitor.pl script using all your locations as argument :  
trunkmonitor.pl L1 L2 L3  

ensure the data is pulled properly and is updated on the Mysql Database  

* I provided a pbx.pl script that will allow you to test the connection ..  it will accept any command normally sent via ASA.   (display station, list trunk).   Note that the output is in OSSI format (Field and value).  
if the scripts runs then you are good to go.  

I scheduled mine via crontab to run every minute.  

good luck.
