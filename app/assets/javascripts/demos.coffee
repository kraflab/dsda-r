$ ->
  levelRowLength = 7
  categoryRowLength = 6
  demoRowLength = 5
  noteDelta = 3
  timeDelta = 2
  engineDelta = 4
  crossListTargets = ["UV Speed", "SM Speed"]

  $("#addNewTag").on "click", ->
    $("#tag_fields").append($("#new_tag_form").html())

  $("#addNewPlayer").on "click", ->
    $("#player_fields").append($("#new_player_form").html())

  $("a.hidden-tag").mouseover ->
    $(this).removeClass "hidden-tag"
    cell = this
    xmlhttp = new XMLHttpRequest
    xmlhttp.open "GET", "/demos/#{this.id}/hidden_tag", true
    xmlhttp.onreadystatechange = ->
      if this.readyState is 4 and this.status is 200
        cell.title = this.responseText
    xmlhttp.send null

  getText = (cell) ->
    $.trim cell.innerText

  toI = (str) ->
    parseInt(str, 10)

  filtered = (row, filter) ->
    rowLength = row.cells.length
    note = row.cells[rowLength - noteDelta].innerHTML
    (filter.tas and note.search("T") >= 0) or (filter.coop and note.search("P") >= 0)

  getRunTime = (row) ->
    lastCell = row.cells[row.cells.length - timeDelta]
    hours = mins = secs = tics = 0
    timeText = lastCell.innerText
    [timeText, tics] = timeText.split(".") if timeText.search("\\.") >= 0
    timeText = timeText.split(":")
    timeText.unshift("0") if timeText.length < 3
    if timeText.length < 3
      [mins, secs] = timeText
    else
      [hours, mins, secs] = timeText
    ((toI(hours) * 60 + toI(mins)) * 60 + toI(secs)) * 100 + toI(tics)

  crossListPacifist = (body, destination, index, filter) ->
    shiftCount = 0
    subIndex = index
    subRow = body.rows[subIndex]
    while true
      subRowLength = subRow.cells.length
      runTime = getRunTime(subRow)
      note = subRow.cells[subRowLength - noteDelta].innerHTML
      insertIndex = -1
      if !filtered(subRow, filter)
        if note.search("T") >= 0
          if note.search("P") >= 0
            if (runTime < destination.coopTas or destination.coopTas is 0) and !filter.tas and !filter.coop
              destination.coopTas = -1
              insertIndex = destination.coopTasIndex
          else
            if (runTime < destination.tas or destination.tas is 0) and !filter.tas
              destination.tas = -1
              insertIndex = destination.tasIndex
        else if note.search("P") >= 0
          if (runTime < destination.coop or destination.coop is 0) and !filter.coop
            destination.coop = -1
            insertIndex = destination.coopIndex
        else
          if runTime < destination.rta or destination.rta is 0
            destination.rta = -1
            insertIndex = destination.rtaIndex
      if insertIndex >= 0
        cloneRow = body.rows[subIndex].cloneNode(true)
        cloneRow.cells[0].remove() while cloneRow.cells.length > demoRowLength
        for cell in cloneRow.cells
          cell.style = "font-style: italic;"
        firstChild = cloneRow.firstChild
        if insertIndex is destination.index
          while destination.row.cells.length > demoRowLength
            shiftCell = destination.row.cells[0].cloneNode(true)
            shiftCell.rowSpan += 1
            destination.row.cells[0].remove()
            cloneRow.insertBefore(shiftCell, firstChild)
        else
          if destination.row.cells.length is levelRowLength
            destination.row.cells[1].rowSpan += 1
          if destination.row.cells.length > demoRowLength
            destination.row.cells[0].rowSpan += 1
        body.insertBefore(cloneRow, body.rows[insertIndex])
        destination.row = body.rows[destination.index]
        destination.rtaIndex += 1 if destination.rtaIndex >= insertIndex
        destination.tasIndex += 1 if destination.tasIndex >= insertIndex
        destination.coopTasIndex += 1 if destination.coopTasIndex >= insertIndex
        destination.coopIndex += 1 if destination.coopIndex >= insertIndex
        destination.span += 1
        shiftCount += 1
        subIndex += 1
      subIndex += 3
      subRow = body.rows[subIndex]
      if subRow is undefined or subRow.cells.length > demoRowLength
        break
    shiftCount

  parseCategory = (body, category, reference, filter) ->
    category.index = reference.index
    category.span = reference.span
    category.row = body.rows[reference.index]
    subIndex = category.index
    subRow = category.row
    while true
      subRowLength = subRow.cells.length
      runTime = getRunTime(subRow)
      note = subRow.cells[subRowLength - noteDelta].innerHTML
      if !filtered(subRow, filter)
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
      subIndex += 3
      subRow = body.rows[subIndex]
      if subRow is undefined or subRow.cells.length > demoRowLength
        break
    category.rtaIndex = category.index if category.rtaIndex is 0
    category.tasIndex = category.index if category.tasIndex is 0
    category.coopIndex = category.index if category.coopIndex is 0
    category.coopTasIndex = category.index if category.coopTasIndex is 0

  filter_body = $(".demo-filter")[0]
  if filter_body
    filter = undefined # Cookies.get("demo_filter")
    if filter is undefined
      filter = {category: [], tas: false, coop: false}
    else
      # cookie has converted space to +, so convert back
      filter = filter.replace "+", " "
      filter = JSON.parse filter
    level = {span: 0, text: "", index: 0}
    category = {span: 0, text: "", index: 0}
    uvSpeed = {row: null, index: 0, span: 0, rta: 0, tas: 0, coop: 0, coopTas: 0, rtaIndex: 0, tasIndex: 0, coopIndex: 0, coopTasIndex: 0}
    index = 0
    while index < filter_body.rows.length
      deleteCount = 0
      row = filter_body.rows[index]
      rowLength = row.cells.length
      # full row with level
      if rowLength is levelRowLength
        level = {span: row.cells[0].rowSpan, text: row.cells[0].innerText, index: index}
        uvSpeed = {row: null, index: -1, span: 0, rta: 0, tas: 0, coop: 0, coopTas: 0, rtaIndex: 0, tasIndex: 0, coopIndex: 0, coopTasIndex: 0}
        category = {span: row.cells[1].rowSpan, text: getText(row.cells[1]), index: index}
        if category.text in filter.category
          deleteCount = row.cells[1].rowSpan
        else
          # store uv speed records
          if crossListTargets.indexOf(category.text) isnt -1
            parseCategory(filter_body, uvSpeed, category, filter)
      else if rowLength is categoryRowLength and row.cells[0]
        category = {span: row.cells[0].rowSpan, text: getText(row.cells[0]), index: index}
        if category.text in filter.category
          if category.text is "Pacifist" and uvSpeed.index >= 0
            shiftCount = crossListPacifist(filter_body, uvSpeed, index, filter)
            index += shiftCount
            level.span += shiftCount
          deleteCount = row.cells[0].rowSpan
        else
          if crossListTargets.indexOf(category.text) isnt -1
            parseCategory(filter_body, uvSpeed, category, filter)
          # check for pacifist times to crosslist in uv speed
          else if category.text is "Pacifist" and uvSpeed.index >= 0
            shiftCount = crossListPacifist(filter_body, uvSpeed, index, filter)
            index += shiftCount
            level.span += shiftCount
            category.index += shiftCount
      # wipe out category
      if deleteCount > 0
        newSpan = level.span - deleteCount
        if newSpan > 0
          if index != level.index
            filter_body.rows[level.index].cells[0].innerText = level.text
            filter_body.rows[level.index].cells[0].rowSpan = newSpan
          else
            x = filter_body.rows[index + deleteCount].insertCell(0)
            x.innerText = level.text
            x.rowSpan = newSpan
            x.className = "no-stripe-panel"
        level.span = newSpan
        filter_body.rows[index].remove() for [1..deleteCount]
      else
        deleteCount = 0
        if rowLength >= demoRowLength
          if filtered(row, filter)
            deleteCount = 3
            newLevelSpan = level.span - deleteCount
            newCategorySpan = category.span - deleteCount
            if newCategorySpan > 0
              if index != category.index
                cellID = 0
                cellID = 1 if category.index is level.index
                filter_body.rows[category.index].cells[cellID].innerText = category.text
                filter_body.rows[category.index].cells[cellID].rowSpan = newCategorySpan
              else
                x = filter_body.rows[index + deleteCount].insertCell(0)
                x.innerText = category.text
                x.rowSpan = newCategorySpan
                x.className = "no-stripe-panel"
            if newLevelSpan > 0
              if index != level.index
                filter_body.rows[level.index].cells[0].innerText = level.text
                filter_body.rows[level.index].cells[0].rowSpan = newLevelSpan
              else
                x = filter_body.rows[index + deleteCount].insertCell(0)
                x.innerText = level.text
                x.rowSpan = newLevelSpan
                x.className = "no-stripe-panel"
            level.span = newLevelSpan
            filter_body.rows[index].remove() for [1..deleteCount]
        if deleteCount is 0
          index += 1
