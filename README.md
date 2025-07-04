# Doom Speed Demo Archive

The Doom Speed Demo Archive hosts speed demos recorded for doom engine games,
including the original works by id, related projects such as heretic, and custom
content created by the community.
The archive currently stores over 111k demos, with 8k hours of content.

This iteration of DSDA is hosted at [dsdarchive.com](https://dsdarchive.com)
The previous one was hosted at doomedsda.us by Andy Olivera, who, along with
Opulent, have served the doom demo community for well over a decade.

The goal of this project is to create a new dsda, from scratch, implementing
a variety of features and improvements, such as support for additional
categories, heretic / hexen demos, zandronum demos, and extra stats / options.

## New Features
- Heretic and Hexen support
- Zandronum demo support
- Extra site-wide stats (e.g., average demo time)
- Ranking / sorting by tics
- Category cross-listing (pacifist -> uv speed)
- Additional categories (e.g., stroller)
- Live feed of recent demos
- List of level times for movies
- Date of recording
- Twitch / YouTube links for players
- Demo video links
- API
- Record timelines
- Table views
- Movie comparisons
- And more to come

## Local Setup
The archive can be set up locally for testing purposes. The steps are relatively straightforward:

1) Install ruby 3.3
2) Make sure bundler is installed (`gem install bundler`)
3) Clone or download this repository
4) Move into the `dsda-r` directory
5) Run `bundle` to install all the gems (libraries) you need
6) Run `bundle exec rails db:reset` to set up the database
    - `bundle exec` means to run the following command using the predefined gem versions
    - `rails` is the web framework
    - `db:reset` resets the database, migrates it to the current schema, and adds seed data
7) Run `bundle exec rails s` to start the server (`s` means server)
8) Navigate a browser to `localhost:3000` (may take time to load)
9) Click on Wads to see the list of wads
10) Click on the one with lots of demos
11) Download one of the demos to confirm everything is set up
    - The files are plain text, so you can open the "zip" in any editor
