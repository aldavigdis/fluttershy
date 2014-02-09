function chartData(q, d, hideY) {
	nv.addGraph(function() {
		var chart = nv.models.multiBarChart()
		
		chart.xAxis.tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) })
		chart.yAxis.tickFormat(d3.format(',.3s'))
		chart.stacked(true)
		if (hideY == true) {
			chart.showYAxis(false)
			chart.margin({top:10, right:0, bottom:10, left:0}) 
		}
		else {
			chart.margin({top:10, right:0, bottom:10, left:40}) 
		}
		
		if (d.length == 2) {
			chart.tooltipContent(function(key, y, e, graph) {
				console.log(graph)
				yFormat = d3.format(",.3")
				index = graph.pointIndex
				date = new Date(graph.series.values[index].x)
	 			dateStr = (date.getDate())+'.'+(date.getMonth()+1)+'.'+date.getFullYear()
				x = d[0].key
				x0 = d[1].key
				y = Math.round(d[0].values[index].y/1000000)
				y0 = Math.round(d[1].values[index].y/1000000)
				yTotal = Math.round((y+y0))
				return '<table><thead><tr><th colspan="2">'+dateStr+'</th></tr></thead><tbody<tr><th>'+x+'</th><td>'+yFormat(y)+' MB'+'</td></tr><tr><th>'+x0+'</th><td>'+yFormat(y0)+' MB'+'</td></tr></tbody><tfoot><tr><th>Total</th><td>'+yFormat(yTotal)+' MB'+'</td></tr></tfoot>'
			})
		}
		else {
			chart.tooltipContent(function(key, y, e, graph) {
				console.log(graph)
				yFormat = d3.format(",.3")
				index = graph.pointIndex
				date = new Date(graph.series.values[index].x)
	 			dateStr = (date.getDate())+'.'+(date.getMonth()+1)+'.'+date.getFullYear()
				y = Math.round(d[0].values[index].y/1000)/1000
				yFromatted = Math.round(y*1000)/1000
				return '<h4>'+dateStr+'</h4><p>'+yFromatted+' MB</p>'
			})
		}
		
		d3.select(q).datum(d).transition().duration(500).call(chart)
		nv.utils.windowResize(chart.update)
		
		return chart
	})
}

function chartMinutes(q, d, hideY, hideLegend) {
	nv.addGraph(function() {
		var chart = nv.models.multiBarChart()
		
		chart.xAxis.tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) })
		chart.yAxis.tickFormat(d3.format(",.3"))
		chart.stacked(true)
		if (hideY == true) {
			chart.showYAxis(false)
			chart.margin({top:10, right:0, bottom:10, left:0}) 
		}
		else {
			chart.margin({top:10, right:0, bottom:10, left:40}) 
		}
		
		if (d.length == 1) {
			chart.showLegend(false)
		}
		
		if (hideLegend == true) {
			chart.showLegend(false)
		}
		
		chart.tooltipContent(function(key, y, e, graph) {
			yFormat = d3.format("")
			index = graph.pointIndex
			date = new Date(graph.series.values[index].x)
 			dateStr = (date.getDate())+'.'+(date.getMonth()+1)+'.'+date.getFullYear()
			y = Math.round(d[0].values[index].y)
			return '<p>'+y+'</p>'
		})
		
		d3.select(q).datum(d).transition().duration(500).call(chart)
		nv.utils.windowResize(chart.update)
		
		return chart
	})
}

function chartInterger(q, d, hideY, hideLegend) {
	nv.addGraph(function() {
		var chart = nv.models.multiBarChart()
		
		chart.xAxis.tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) })
		chart.yAxis.tickFormat(d3.format(',.0'))
		chart.stacked(true)
		if (hideY == true) {
			chart.showYAxis(false)
			chart.margin({top:10, right:0, bottom:10, left:0}) 
		}
		else {
			chart.margin({top:10, right:0, bottom:10, left:40}) 
		}
		
		if (d.length == 1) {
			chart.showLegend(false)
		}
		
		if (hideLegend == true) {
			chart.showLegend(false)
		}
		
		chart.tooltipContent(function(key, y, e, graph) {
			yFormat = d3.format(",.3s")
			index = graph.pointIndex
			date = new Date(graph.series.values[index].x)
 			dateStr = (date.getDate())+'.'+(date.getMonth()+1)+'.'+date.getFullYear()
			y = Math.round(d[0].values[index].y)
			return '<p>'+y+'</p>'
		})
		
		d3.select(q).datum(d).transition().duration(500).call(chart)
		nv.utils.windowResize(chart.update)
		
		return chart
	})
}
