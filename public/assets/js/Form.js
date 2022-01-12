window.onresize = function() {WidthResize()};

var header = document.getElementById("header");
var sticky = header.offsetTop;
var category = document.getElementById("category");
var widthresize = document.getElementsByClassName("center");
var fullform = document.getElementById("fullform");
var thinform = document.getElementById("thinform");
var centerlimit = screen.width * 0.40;

window.onload = function() { 
    for(var i = 0; i < widthresize.length; i++) {
    widthresize[i].style.width = centerlimit + 'px';
    }
    var size = window.innerWidth / screen.width;
    
    thinform.style.marginLeft = "5px";
    fullform.style.width = centerlimit + "px";
    fullform.style.marginLeft = (window.innerWidth / 2) - (centerlimit / 2) + 'px';

    if(window.innerWidth < centerlimit) {
    thinform.style.display = "block";
    fullform.style.display = "none";

    for(let item of widthresize) {
      item.style.marginLeft = "5px";
    }
    }
    else {
    thinform.style.display = "none";
    fullform.style.display = "block";

    for(let item of widthresize) {
      item.style.marginLeft = (window.innerWidth / 2) - (centerlimit / 2) + "px";  
    }
    }
}

function WidthResize() {
    if(window.innerWidth < centerlimit) {
        thinform.style.display = "block";
        fullform.style.display = "none";

        for(let item of widthresize) {
            item.style.marginLeft = "5px";  
        }
    }
    else {
        thinform.style.display = "none";
        fullform.style.display = "block";
        fullform.style.marginLeft = (window.innerWidth / 2) - (centerlimit / 2) + "px";

        for(let item of widthresize) {
            item.style.marginLeft = (window.innerWidth / 2) - (centerlimit / 2) + "px";  
        }
    }
}