
window.onresize = function() {WidthResize()};

var widthresize = document.getElementsByClassName("center");
var welcome = document.getElementById("welcome");
var information = document.getElementsByClassName("information");
var list = document.getElementsByClassName("list");
var names = document.getElementsByClassName("name");
var centerlimit = screen.width * 0.60;

window.onload = function() {
    for(var i = 0; i < widthresize.length; i++) {
        widthresize[i].style.width = centerlimit + 'px';
    }

    welcome.style.fontSize = 0.02 * window.innerWidth + 14 + "px";
    WidthResize();
  
    window.history.replaceState({}, "Auction", "index.html");
}

function WidthResize() {
    if(window.innerWidth < 3200) {
        welcome.style.fontSize = 0.02 * window.innerWidth + 14 + "px";
    }
    if(window.innerWidth < centerlimit) {
      for(let item of widthresize) {
          item.style.marginLeft = "3px"; 
          item.style.width = window.innerWidth - 20 + "px";
      }
    }
    else {
      for(let item of widthresize) {
          item.style.marginLeft = (window.innerWidth / 2) - (centerlimit / 2) + "px";
          item.style.width = centerlimit + "px";
      }
    }
       
    if(window.innerWidth > centerlimit) {
        for(let item of information) {
            item.style.width = centerlimit / 5.2 + "px";
        }
    }
    else {
        if(list[0].offsetWidth / 5.2 > 64 && list[0].offsetWidth / 5.2 < centerlimit / 5.2) {
            for(let item of information) {
                item.style.width = list[0].offsetWidth / 5.2 + "px";
            }
        }
        else {
            for(let item of information) {
                item.style.width = "64px";
            }
        }   
    }
    
    var size = 0.1 * information[0].offsetWidth;
    if(size > 8) {
        for(let item of list) {
            item.style.fontSize = size + "px";
        }
        
        for(var i = 0; i < names.length; i++)
        {
            names[i].style.fontSize = size + 3 + "px";
        }
    }
    else {
        for(let item of list) {
            item.style.fontSize = "8px";
        }
        for(var i = 0; i < names.length; i++)
        {
            names[i].style.fontSize = "11px";
        }
    }
    
}
