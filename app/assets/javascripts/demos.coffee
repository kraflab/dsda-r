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
        categorySpan = 0
        categoryText = ""
        categoryIndex = 0
        index = 0
        while index < filter_body.rows.length
          deleteCount = 0
          row = filter_body.rows[index]
          rowLength = row.cells.length
          # full row with level
          if rowLength is 6
            levelIndex = index
            levelSpan = row.cells[0].rowSpan
            levelText = row.cells[0].innerHTML
            if row.cells[1].innerHTML in response.filter
              deleteCount = row.cells[1].rowSpan
            else
              categorySpan = row.cells[1].rowSpan
              categoryText = row.cells[1].innerHTML
              categoryIndex = index
          else if rowLength is 5 and row.cells[0]
            if row.cells[0].innerHTML in response.filter
              deleteCount = row.cells[0].rowSpan
            else
              categorySpan = row.cells[0].rowSpan
              categoryText = row.cells[0].innerHTML
              categoryIndex = index
          # wipe out category
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
            deleteCount = 0
            if rowLength > 3
              note = row.cells[rowLength - 2].innerHTML
              # check for tas and coop filtering
              if (response.hideTas and note.search("T") >= 0) or (response.hideCoop and note.search("P") >= 0)
                deleteCount = 1
                if index < filter_body.rows.length
                  # check for tag row
                  if filter_body.rows[index + 1].cells.length is 0
                    deleteCount += 2
                newLevelSpan = levelSpan - deleteCount
                newCategorySpan = categorySpan - deleteCount
                if newCategorySpan > 0
                  if index != categoryIndex
                    cellID = 0
                    cellID = 1 if categoryIndex is levelIndex
                    filter_body.rows[categoryIndex].cells[cellID].innerHTML = categoryText
                    filter_body.rows[categoryIndex].cells[cellID].rowSpan = newCategorySpan
                  else
                    x = filter_body.rows[index + deleteCount].insertCell(0)
                    x.innerHTML = categoryText
                    x.rowSpan = newCategorySpan
                    x.className = "no-stripe-panel"
                if newLevelSpan > 0
                  if index != levelIndex
                    filter_body.rows[levelIndex].cells[0].innerHTML = levelText
                    filter_body.rows[levelIndex].cells[0].rowSpan = newLevelSpan
                  else
                    x = filter_body.rows[index + deleteCount].insertCell(0)
                    x.innerHTML = levelText
                    x.rowSpan = newLevelSpan
                    x.className = "no-stripe-panel"
                filter_body.rows[index].remove() for [1..deleteCount]
            if deleteCount is 0
              index += 1
    xmlhttp.send null
