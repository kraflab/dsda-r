module StaticPagesHelper
  def get_docs()
    [
      {
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
      {
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
      {
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
