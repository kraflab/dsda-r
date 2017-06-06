$ ->
  items = $("div#compareMoviesDropdowns div.btn-group ul li")
  dropdowns = $("div#compareMoviesDropdowns div.btn-group button")
  itemCount = items.length / 2
  indices = [0, 1]
  items.on "click", ->
    index = items.index this
    listNumber = if index < itemCount then 0 else 1
    indices[listNumber] = index - listNumber * itemCount
    dropdowns[listNumber].innerHTML = this.innerText + "<span class=\"caret\"></span>"

    xmlhttp = new XMLHttpRequest
    xmlhttp.open "GET", "/compare_movies_json\?#{window.location.search.substring(1)}&index_0=#{indices[0]}&index_1=#{indices[1]}", true
    xmlhttp.onreadystatechange = ->
      if this.readyState is 4 and this.status is 200
        response = JSON.parse this.responseText
        if response.error is true
          console.log "Comparison failed!"
        else
          rows = $("table tbody")[0].rows
          index = 0
          for arr in response.times
            $(rows[index].cells[0]).toggleClass("better-time", arr[2] < 0)
            rows[index].cells[0].innerText = arr[0]
            $(rows[index].cells[1]).toggleClass("better-time", arr[2] > 0)
            rows[index].cells[1].innerText = arr[1]
            rows[index].cells[2].innerText = arr[2]
            index += 1

    xmlhttp.send null
