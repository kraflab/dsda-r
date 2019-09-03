$ ->
  if $("#twitch-embed").length > 0
    new Twitch.Embed("twitch-embed", {
      width: "100%",
      height: 480,
      channel: "doomspeeddemos",
      theme: "light"
    })
