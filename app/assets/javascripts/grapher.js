/*
*
* This file handles all the ranking and ordering of project members
* as well as graphs and stuff. Analytics, that kind of thing.
*
*/

$(document).ready(function() {
	
	$('ul.updatepersonlist>li').tsort('span.updatepersoncount',{order:'desc'});
	
	var project_sparkline_numbers = []
	$('ul#project_sparkline_numbers > li').each(function(i,elem) {
		project_sparkline_numbers.push($(elem).text());
		});
	console.log(project_sparkline_numbers)
	$(".project_sparkline").sparkline(project_sparkline_numbers, {type: 'bar', barWidth: 10, chartRangeMin: 0, barColor: '#008'});
	});