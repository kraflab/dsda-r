$ ->
  $("#addNewTag").on "click", ->
    $("#tag_fields").append($("#new_tag_form").html())
  
  $("#addNewPlayer").on "click", ->
    $("#player_fields").append($("#new_player_form").html())
  
  filter_body = $(".category-filter")[0]
  if filter_body
    xmlhttp = new XMLHttpRequest
    xmlhttp.open "GET", "/category_filter", true
    xmlhttp.onreadystatechange = ->
      if this.readyState is 4 and this.status is 200
        response = JSON.parse this.responseText
        levelSpan = 0
        levelText = ""
        levelIndex = 0
        index = 0
        while index < filter_body.rows.length
          deleteCount = 0
          row = filter_body.rows[index]
          # full row with level
          if row.cells.length == 6
            levelIndex = index
            levelSpan = row.cells[0].rowSpan
            levelText = row.cells[0].innerHTML
            if row.cells[1].innerHTML in response.filter
              deleteCount = row.cells[1].rowSpan
          else if row.cells[0] and row.cells[0].innerHTML in response.filter
            deleteCount = row.cells[0].rowSpan
          
          if deleteCount > 0
            newSpan = levelSpan - deleteCount
            if newSpan > 0
              if index != levelIndex
                filter_body.rows[levelIndex].cells[0].innerHTML = levelText
                filter_body.rows[levelIndex].cells[0].rowSpan = newSpan
              else
                x = filter_body.rows[index + deleteCount].insertCell(0)
                x.innerHTML = levelText
                x.rowSpan = newSpan
                x.className = "no-stripe-panel"
            levelSpan = newSpan
            filter_body.rows[index].remove() for [1..deleteCount]
          else
            index += 1
    xmlhttp.send null
