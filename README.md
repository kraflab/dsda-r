# Doom Speed Demo Archive

The Doom Speed Demo Archive hosts speed demos recorded for doom engine games,
including the original works by id, related projects such as heretic, and custom
content created by the community.
DSDA is currently hosted at doomedsda.us by Andy Olivera, who, along with
Opulent, has served the doom demo community for well over a decade.
The archive currently stores over 42k demos, with 3.5k hours of content.

The goal of this project is to create a new dsda, from scratch, implementing
a variety of features and improvements, such as support for additional
categories, heretic / hexen demos, zandronum demos, and extra stats / options.

This repository is for the full stack of the site itself.  For the related
work in parsing the old archive and extracting new data, see the work
[here](https://github.com/oleksiykamenyev/DSDA_data_extraction).

Uses `Ruby  2.4.0`  
Uses `Rails 5.0.2`

## New Features
Heretic and Hexen support  
Zandronum demo support  
Extra site-wide stats (e.g., average demo time)  
Ranking / sorting by tics  
Category cross-listing (pacifist -> uv speed)  
Additional categories (e.g., stroller)  
Admin interface for submission / updates  
Live feed of recent demos  
List of level times for movies  
Date of recording  
Twitch / YouTube links for players  
Demo video links  
Record timelines:  
![timeline](http://i.imgur.com/0l1dKNy.png)  
Restful API ([repo](https://github.com/kraflab/dsda-r-api-client)):  

    kraflab:~/dsda-r-api-client $ ./dsda-client.rb
    => Starting DSDA API Client
    => Using ruby 2.4.0
    => Type 'exit' or 'quit' to close the client
    dsda-r: get wad aerified record "Map 01" "UV Speed"
    Issuing GET request... [ SUCCESS ]
    {
      demo: {
        time: 0:15.46,
        player: adrien
      }
    }
    No errors!

## Current Focus
Expand API capabilities  
Expand and clean up settings page  
Improve caching and database queries  
Adjust database indexing

## Contributors
Full stack: Kraflab  
Design: Kraflab, 4shockblast, elimzke
