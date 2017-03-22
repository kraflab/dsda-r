$ ->
  pad = (number) ->
    ("0" + number.toString()).slice(-2)
  
  chart = $("#myChart")
  if chart
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
                backgroundColor: 'rgba(0,64,255,0.1)',
                borderColor: 'rgba(0,64,255,0.5)',
                pointBackgroundColor: 'rgba(0,0,0,1)',
                pointBorderColor: 'rgba(0,0,0,0)',
                data: response.data
              }]
            },
            options: {
              legend: {display: false},
              scales: {
                xAxes: [{
                  type: 'time',
                  position: 'bottom'
                }],
                yAxes: [{
                  ticks: {
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
                  }
                }],
              },
              tooltips: {
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
