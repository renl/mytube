// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"


window.setTimeout(function() {
    $(".alert").slideUp()
}, 3000);

var csrf = document.querySelector("meta[name=csrf]").content;

$("#notes_post").click(function () {
    $.ajax({
	url: $("#video_notes").data("action"),
	type: "put",
	data: {"video_id": $("#video_notes").data("video_id"),
	       "notes": $("#video_notes").val()},
	headers: {"X-CSRF-TOKEN": csrf},
	dataType: "json",
	success: function(data) {
	    alert("Notes posted")
	}
    });
})


var tag = document.createElement('script');
tag.src = 'https://www.youtube.com/iframe_api';
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady() {
    player = new YT.Player('video-iframe', {
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
        }
    });
}

function onPlayerReady(event) {
    player.seekTo(30, true);
}
function onPlayerStateChange(event) {
}

function testapi() {
    alert("Current play time is: "+player.getCurrentTime());
    alert(player.getPlayerState());
    if (player.getPlayerState() != 1) {
	player.playVideo();
    }
    player.seekTo(30, true);
}

