/*
*
* This file handles all the ranking and ordering of project members
* as well as graphs and stuff. Analytics, that kind of thing.
*
*/

$(document).ready(function() {
	
	$('ul.updatepersonlist>li').tsort('span.updatepersoncount',{order:'desc'});
		
	});