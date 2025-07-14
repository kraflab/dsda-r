module StaticPagesHelper
  def get_docs()
    [
      { # GET /api/demos
        endpoint: 'GET /api/demos',
        description: 'This is the main endpoint to query demo lists. It can be used to get all demos from a wad for displaying tables, or getting the feed by sorting by last id.<br>
                      It doesnt crosslist the record, so you are better off using /api/demos/records if you just need the record of a certain category (for example Doom2 Map01 UV will give you a list without any record, since the first place is in the Pacifist category).',
        parameters: [
          { name: 'wad', required: false, type: 'string', description: "The wad's short name" },
          { name: 'level', required: false, type: 'string', description: "The level name" },
          { name: 'category', required: false, type: 'string', description: "The category name" },
          { name: 'only_records', required: false, type: 'bool', description: "Whether to only list demos that are records (default = <code>false</code>)" },
          { name: 'sort_by', required: false, type: 'string', description: "The field to sort the list by and in what direction.<br> The allowed fields are <code>id</code>, <code>time</code> and <code>date</code>. The direction can be <code>asc</code> or <code>desc</code>. (default = <code>time:asc</code>)" },
          { name: 'page', required: false, type: 'integer', description: "The page number (default = <code>1</code>)" },
          { name: 'per', required: false, type: 'integer', description: "How many demos to show per page (default = <code>50</code>, max = <code>200</code>)" }
        ],
        example_request: 'https://dsdarchive.com/api/demos?wad=plutonia&only_records=true&sort_by=date:asc&page=4',
        example_response: <<~JSON
        {
          "demos": [
            {
              "id": 65897,
              "players": [
                "aconfusedhuman"
              ],
              "time": "1:32.94",
              "category": "NM 100S",
              "level": "Map 08",
              "wad": "plutonia",
              "engine": "DSDA-Doom v0.19.7cl4",
              "date": "2021-09-12T23:28:06.000Z",
              "tic_record": true,
              "undisputed_record": false,
              "second_barrier": false,
              "tas": false,
              "guys": 1,
              "suspect": false,
              "cheated": false,
              "notes": [],
              "file": "http://dsdarchive.com/files/demos/plutonia/55364/pl08ns132.zip",
              "video_url": "https://www.youtube.com/watch?v=C16SKN69pWU"
            },

            ...
          ],
          "page": "4",
          "per": 50,
          "total_pages": 7,
          "total_demos": 335
        }
        JSON
      },
      { # GET /api/demos/{id}
        endpoint: 'GET /api/demos/{id}',
        description: 'Returns a specific demo details',
        parameters: [
          { name: 'id', required: true, type: 'integer', description: "The demo's id" },
        ],
        example_request: 'https://dsdarchive.com/api/demos/68170',
        example_response: <<~JSON
        {
          "id": 68170,
          "players": [
            "almostmatt1"
          ],
          "time": "0:07.74",
          "category": "Other",
          "level": "E1M1",
          "wad": "doom",
          "engine": "XDRE v2.22a",
          "date": "2021-11-02T01:30:44.000Z",
          "tic_record": false,
          "undisputed_record": false,
          "second_barrier": false,
          "tas": true,
          "guys": 1,
          "suspect": false,
          "cheated": false,
          "notes": [
            "Nomo. Uses player 3 starting position."
          ],
          "file": "http://dsdarchive.com/files/demos/doom/57604/e1m1ox774.zip",
          "video_url": null
        }
        JSON
      },
      { # GET /api/demos/records
        endpoint: 'GET /api/demos/records',
        description: 'Returns the record demo for a specific run (crosslisted).',
        parameters: [
          { name: 'wad', required: true, type: 'string', description: "The wad's short name" },
          { name: 'level', required: true, type: 'string', description: "The level name" },
          { name: 'category', required: true, type: 'string', description: "The category name" }
        ],
        example_request: 'https://dsdarchive.com/api/demos/records?wad=doom2&level=Map+01&category=UV+Speed',
        example_response: <<~JSON
        {
          "player": "4shockblast",
          "time": "0:04.97",
          "category": "Pacifist",
          "level": "Map 01",
          "wad": "doom2",
          "engine": "DSDA-Doom v0.27.5cl2",
          "date": "2024-04-06T03:46:50.000Z",
          "notes": ["Also Reality"],
          "file": "http://dsdarchive.com/files/demos/doom2/88132/pa01-497.zip"
        }
        JSON
      },
      { # GET /api/players/{username}
        endpoint: 'GET /api/players/{username}',
        description: 'Returns a specific players details',
        parameters: [
          { name: 'username', required: true, type: 'string', description: "The player's short and URL friendly username" },
        ],
        example_request: 'https://dsdarchive.com/api/players/xit_vono',
        example_response: <<~JSON
        {
          "username": "xit_vono",
          "name": "Xit Vono",
          "stats": {
            "demo_count": 1740,
            "total_demo_time": "153:39:19.78",
            "average_demo_time": "5:17.90",
            "longest_demo_time": "1:46:45.00"
          }
        }
        JSON
      },
      { # GET /api/wads/{short_name}
        endpoint: 'GET /api/wads/{short_name}',
        description: 'Returns a specific wad details',
        parameters: [
          { name: 'short_name', required: true, type: 'string', description: "The wad's short name" },
        ],
        example_request: 'https://dsdarchive.com/api/wads/gd',
        example_response: <<~JSON
        {
          "short_name": "gd",
          "name": "Going Down",
          "author": "mouldy",
          "iwad": "doom2",
          "file": "https://dsdarchive.com/files/wads/doom2/1472/gd.zip"
        }
        JSON
      }
    ]
  end
end
