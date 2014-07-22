   graph_kplot.addHandler(function(type, e) {
      var data = e.evtData;
      if(type === 'click') {
         return alert("You click on car with mpg: " + data.mpg.in[0]);
      }
   })