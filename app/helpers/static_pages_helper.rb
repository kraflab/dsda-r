module StaticPagesHelper
  def get_docs()
    [
      {
        endpoint: 'GET /api/demos/records',
        description: 'Returns the record demo for a specific run',
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
