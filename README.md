# Lighthouse

Lighthouse is NRG 948's in-house scouting and data analysis mobile app.

## Usage
The app is divided into four main data-collection "layouts," each with different purposes. 
There are also pages for viewing and editing saved data, viewing and analyzing saved data, 
and uploading data to a server. 

### Atlas
Designed for mapping where the robot went during a match, and what it did, but not when it did. 
This is essentially to understand the robot's role. 

### Chronos
Designed for mapping out where the robot went during what time, to gather data on cycle times, 
paths, etc. Note that this is not currently used by NRG. 

### Pit
For the initial talking-to-teams and gathering data at the start of an event. 

### Human Player
For tracking human player performance. Also not really used by NRG. 

### Data Viewer
Allows you to see graphs, numbers, and other data from scouting. 

## Server / Database
All data is uploaded to a server, which combines all the data and gives it to 
any Lighthouse instances that request it (thus allowing the data viewer to work). 

Server was previously written in Java / Springboot, but a python-based rewrite is planned. 