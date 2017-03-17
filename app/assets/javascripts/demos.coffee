$ ->
  $("#addNewTag").on "click", ->
    $("#tag_fields").append($("#new_tag_form").html())
  
  $("#addNewPlayer").on "click", ->
    $("#player_fields").append($("#new_player_form").html())
  
  getRunTime = (row) ->
    [..., lastCell] = row.cells
    hours = mins = secs = tics = 0
    timeText = lastCell.childNodes[1].innerHTML
    [timeText, tics] = timeText.split(".") if timeText.search(".") >= 0
    timeText = timeText.split(":")
    timeText.unshift("0") if timeText.length < 3
    if timeText.length < 3
      [mins, secs] = timeText
    else
      [hours, mins, secs] = timeText
    ((hours * 60 + mins) * 60 + secs) * 100 + tics
  
  parseCategory = (body, category) ->
    subIndex = category.index
    subRow = category.row
    while true
      subRowLength = subRow.cells.length
      runTime = getRunTime(subRow)
      note = subRow.cells[subRowLength - 2].innerHTML
      if note.search("T") >= 0
        if note.search("P") >= 0
          if category.coopTas is 0
            category.coopTas = runTime
            category.coopTasIndex = subIndex
        else
          if category.tas is 0
            category.tas = runTime
            category.tasIndex = subIndex
      else if note.search("P") >= 0
        if category.coop is 0
          category.coop = runTime
          category.coopIndex = subIndex
      else
        if category.rta is 0
          category.rta = runTime
          category.rtaIndex = subIndex
      subIndex += 1
      subRow = body.rows[subIndex]
      if subRow.cells.length is 0 or subRow.cells.length > 4
        break
    console.log category
  
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
        uvSpeed = {row: null, index: 0, span: 0, rta: 0, tas: 0, coop: 0, coopTas: 0, rtaIndex: 0, tasIndex: 0, coopIndex: 0, coopTasIndex: 0}
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
            uvSpeed = {row: null, index: -1, span: 0, rta: 0, tas: 0, coop: 0, coopTas: 0, rtaIndex: 0, tasIndex: 0, coopIndex: 0, coopTasIndex: 0}
            if row.cells[1].innerHTML in response.filter
              deleteCount = row.cells[1].rowSpan
            else
              categorySpan = row.cells[1].rowSpan
              categoryText = row.cells[1].innerHTML
              categoryIndex = index
              # store uv speed records
              if categoryText is "UV Speed"
                uvSpeed.index = categoryIndex
                uvSpeed.span = categorySpan
                uvSpeed.row = filter_body.rows[index]
                parseCategory(filter_body, uvSpeed)
          else if rowLength is 5 and row.cells[0]
            if row.cells[0].innerHTML in response.filter
              deleteCount = row.cells[0].rowSpan
            else
              categorySpan = row.cells[0].rowSpan
              categoryText = row.cells[0].innerHTML
              categoryIndex = index
              if categoryText is "UV Speed"
                uvSpeed.index = categoryIndex
                uvSpeed.span = categorySpan
                uvSpeed.row = filter_body.rows[index]
                parseCategory(filter_body, uvSpeed)
              # check for pacifist times to crosslist in uv speed
              else if categoryText is "UV Pacifist" and uvSpeed.index >= 0
                console.log "entering pacifist ->"
                subIndex = index
                subRow = filter_body.rows[subIndex]
                while true
                  subRowLength = subRow.cells.length
                  runTime = getRunTime(subRow)
                  note = subRow.cells[subRowLength - 2].innerHTML
                  insertIndex = -1
                  if note.search("T") >= 0
                    if note.search("P") >= 0
                      if (runTime < uvSpeed.coopTas or uvSpeed.coopTas is 0) and !response.hideTas and !response.hideCoop
                        uvSpeed.coopTas = -1
                        insertIndex = uvSpeed.coopTasIndex
                    else
                      if (uvSpeed.tas is 0) and !response.hideTas
                        uvSpeed.coopTas = -1
                        insertIndex = uvSpeed.coopTasIndex
                  else if note.search("P") >= 0
                    if (runTime < uvSpeed.coop or uvSpeed.coop is 0) and !response.hideCoop
                      uvSpeed.coop = -1
                      insertIndex = uvSpeed.coopIndex
                  else
                    if runTime < uvSpeed.rta or uvSpeed.rta is 0
                      uvSpeed.rta = -1
                      insertIndex = uvSpeed.rtaIndex
                  if insertIndex >= 0
                    cloneRow = filter_body.rows[subIndex].cloneNode(true)
                    cloneRow.cells[0].remove() while cloneRow.cells.length > 4
                    for cell in cloneRow.cells
                      cell.style = "font-style: italic;"
                    firstChild = cloneRow.firstChild
                    if insertIndex is uvSpeed.index
                      while uvSpeed.row.cells.length > 4
                        shiftCell = uvSpeed.row.cells[0].cloneNode(true)
                        shiftCell.rowSpan += 1
                        uvSpeed.row.cells[0].remove()
                        cloneRow.insertBefore(shiftCell, firstChild)
                    filter_body.insertBefore(cloneRow, filter_body.rows[insertIndex])
                    uvSpeed.row = filter_body.rows[uvSpeed.index]
                    uvSpeed.span += 1
                    console.log "nothing"
                    index += 1
                    subIndex += 1
                  subIndex += 1
                  subRow = filter_body.rows[subIndex]
                  if subRow.cells.length is 0 or subRow.cells.length > 4
                    break
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
