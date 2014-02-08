function chartBars(q, d, splitBwth) {
	nv.addGraph(function() {
		var chart = nv.models.multiBarChart()
		
		chart.xAxis.tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) })
		chart.yAxis.tickFormat(d3.format(',.3s'))
		chart.margin({top:0, right:0, bottom:10, left:40}) 
		chart.stacked(true)
		
		if (splitBwth == true) {
			chart.tooltipContent(function(key, y, e, graph) {
				console.log(graph)
				yFormat = d3.format(",.3")
				index = graph.pointIndex
				date = new Date(graph.series.values[index].x)
	 			dateStr = (date.getDate())+'.'+(date.getMonth()+1)+'.'+date.getFullYear()
				y = Math.round(d[0].values[index].y/1000000)/1000
				y0 = Math.round(d[1].values[index].y/1000000)/1000
				yTotal = Math.round((y+y0)*1000)/1000
				return '<table><thead><tr><th colspan="2">'+dateStr+'</th></tr></thead><tbody<tr><th>Domestic</th><td>'+yFormat(y0)+' GB'+'</td></tr><tr><th>Non-Domestic</th><td>'+yFormat(y)+' GB'+'</td></tr></tbody><tfoot><tr><th>Total</th><td>'+yFormat(yTotal)+' GB'+'</td></tr></tfoot>'
			})
		}
		
		d3.select(q).datum(d).transition().duration(500).call(chart)
		nv.utils.windowResize(chart.update)
		
		return chart
	})
}

window.bwthData = [
	{
	key: "Non-domestic Traffic",
	values: [
		{ x : 1388534400000, y : 1106484552 },
		{ x : 1388620800000, y : 1360941706 },
		{ x : 1388707200000, y : 1037673934 },
		{ x : 1388793600000, y : 1024357817 },
		{ x : 1388880000000, y : 1330432553 },
		{ x : 1388966400000, y : 1039983105 },
		{ x : 1389052800000, y : 905637060 },
		{ x : 1389139200000, y : 1018578944 },
		{ x : 1389225600000, y : 1217196886 },
		{ x : 1389312000000, y : 1022177043 },
		{ x : 1389398400000, y : 1226000723 },
		{ x : 1389484800000, y : 1325887578 },
		{ x : 1389571200000, y : 1414630103 },
		{ x : 1389657600000, y : 1313305724 },
		{ x : 1389744000000, y : 925090977 },
		{ x : 1389830400000, y : 1430129743 },
		{ x : 1389916800000, y : 905261931 },
		{ x : 1390003200000, y : 1038686438 },
		{ x : 1390089600000, y : 885133288 },
		{ x : 1390176000000, y : 1230514951 },
		{ x : 1390262400000, y : 1193150949 },
		{ x : 1390348800000, y : 1389169967 },
		{ x : 1390435200000, y : 1208798894 },
		{ x : 1390521600000, y : 1213845682 },
		{ x : 1390608000000, y : 1166368685 },
		{ x : 1390694400000, y : 873456485 },
		{ x : 1390780800000, y : 1047918716 },
		{ x : 1390867200000, y : 906066849 },
		{ x : 1390953600000, y : 1392575168 },
		{ x : 1391040000000, y : 983239788 },
		{ x : 1391126400000, y : 1332356183 }
	] },
	{
	key: "Domestic traffic",
	values: [
		{ x : 1388534400000, y : 1489316345 },
		{ x : 1388620800000, y : 1689864168 },
		{ x : 1388707200000, y : 2733623290 },
		{ x : 1388793600000, y : 2468258409 },
		{ x : 1388880000000, y : 2219173718 },
		{ x : 1388966400000, y : 1607648420 },
		{ x : 1389052800000, y : 1414025837 },
		{ x : 1389139200000, y : 1417540768 },
		{ x : 1389225600000, y : 2180296486 },
		{ x : 1389312000000, y : 1555367629 },
		{ x : 1389398400000, y : 2671801666 },
		{ x : 1389484800000, y : 1925167468 },
		{ x : 1389571200000, y : 2140285643 },
		{ x : 1389657600000, y : 2297172901 },
		{ x : 1389744000000, y : 1331139377 },
		{ x : 1389830400000, y : 1547087027 },
		{ x : 1389916800000, y : 2435503138 },
		{ x : 1390003200000, y : 1844142674 },
		{ x : 1390089600000, y : 2264842239 },
		{ x : 1390176000000, y : 2175582645 },
		{ x : 1390262400000, y : 2527885488 },
		{ x : 1390348800000, y : 1830706046 },
		{ x : 1390435200000, y : 2681065040 },
		{ x : 1390521600000, y : 2715147427 },
		{ x : 1390608000000, y : 2755989963 },
		{ x : 1390694400000, y : 2076668838 },
		{ x : 1390780800000, y : 1657449108 },
		{ x : 1390867200000, y : 2477815252 },
		{ x : 1390953600000, y : 2372315335 },
		{ x : 1391040000000, y : 1372946663 },
		{ x : 1391126400000, y : 2585271608 }
	] }
]

$( document ).ready(function() {
	chartBars('.chart1 svg', window.bwthData);
	chartBars('.chart2 svg', window.bwthData);
	
})
