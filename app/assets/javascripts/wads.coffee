$ ->
# =========================
# Auto resize selectors based on the selected test
# =========================
  resize = (select) ->
    selected = select.options[select.selectedIndex]
    return unless selected?

    temp = document.createElement('span')
    temp.style.visibility = 'hidden'
    temp.style.whiteSpace = 'nowrap'
    temp.style.position = 'absolute'
    temp.style.font = getComputedStyle(select).font
    temp.innerText = selected.text
    document.body.appendChild(temp)

    select.style.width = (temp.offsetWidth + 2) + 'px'
    
    temp.remove()

  for select in document.querySelectorAll('select.fix-dropdown')
    resize(select)
    select.addEventListener('change', () => resize(select))

# =========================
# Draw chart
# =========================
  pad = (number) ->
    ("0" + number.toString()).slice(-2)

  chart = $("#myChart")
  if chart.length > 0
    console.log chart
    xmlhttp = new XMLHttpRequest
    xmlhttp.open "GET", "/record_timeline_json\?#{window.location.search.substring(1)}", true
    xmlhttp.onreadystatechange = ->
      if this.readyState is 4 and this.status is 200
        response = JSON.parse this.responseText
        unless response.error
          scatterChart = new Chart(chart, {
            type: 'line',
            data: {
              datasets: [{
                label: 'Record Timeline',
                fill: true,
                backgroundColor: 'rgba(42,159,214,0.3)',
                borderColor: '#2a9fd6',
                pointBackgroundColor: '#fff',
                pointBorderColor: '#fff',
                data: response.data
              }]
            },
            options: {
              title: { fontSize: 32, fontColor: '#fff' },
              elements: {
                line: {
                  tension: 0
                }
              },
              legend: {display: false},
              scales: {
                xAxes: [{
                  type: 'time',
                  position: 'bottom',
                  ticks: { fontSize: 16, fontColor: '#eee' },
                  gridLines: { color: 'rgba(255,255,255,0.3)' }
                }],
                yAxes: [{
                  ticks: {
                    fontSize: 16, fontColor: '#eee',
                    callback: (label, index, labels) ->
                      tics = label;
                      secs = Math.floor(tics / 100)
                      mins = Math.floor(secs / 60)
                      secs -= mins * 60
                      hours = Math.floor(mins / 60)
                      mins -= hours * 60
                      if hours > 0
                        hours.toString() + ":" + pad(mins) + ":" + pad(secs)
                      else
                        pad(mins) + ":" + pad(secs)
                  },
                  gridLines: { color: 'rgba(255,255,255,0.3)' }
                }],
              },
              tooltips: {
                titleFontSize: 16,
                bodyFontSize: 16,
                callbacks: {
                  label: (tooltipItem, data) ->
                    tics = tooltipItem.yLabel;
                    secs = Math.floor(tics / 100)
                    mins = Math.floor(secs / 60)
                    secs -= mins * 60
                    hours = Math.floor(mins / 60)
                    mins -= hours * 60
                    time =
                      if hours > 0
                        hours.toString() + ":" + pad(mins) + ":" + pad(secs)
                      else
                        pad(mins) + ":" + pad(secs)
                    time + " by " + response.players[tics]
                }
              }
            }
          })
    xmlhttp.send null
