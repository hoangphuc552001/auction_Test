window.onresize = function() {WidthResize()};

var list = document.getElementsByClassName("list");
var names = document.getElementsByClassName("name");
var information = document.getElementsByClassName("information");
var filter =  document.getElementById("filter");
var catalog = document.getElementById("catalog");
var holder = document.getElementById("holder");
var toggle = document.getElementById("togglefilter");
var order = document.getElementById("order");
var centerlimit = screen.width * 0.40;

window.onload = function() { 
    var size = window.innerWidth / screen.width;
    if(size > 0.4) {
        filter.style.display = "block";
        toggle.style.display = "none";
        catalog.classList.remove("col-12");
        for(let item of information) {
            item.style.width = screen.width * 0.08 + "px";
        }
    }
    else {
        filter.style.display = "none";
        toggle.style.display = "inline-block";
        catalog.classList.add("col-12");
        if(list[0].offsetWidth / 4.1 > 96) {
            for(let item of information) {
                item.style.width = list[0].offsetWidth / 4.1 + "px";
            }
        }
        else {
            for(let item of information) {
                item.style.width = "96px";
            }
        }   
    }

    size = 0.1 * information[0].offsetWidth;
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

    if(this.document.URL.split('=')[1])
        this.document.getElementById("search").value = this.document.URL.split('=')[1];
    Sort();
}

function WidthResize() {
    var size = window.innerWidth / screen.width;
    if(size > 0.4) {
        filter.style.display = "block";
        toggle.style.display = "none";
        catalog.classList.remove("col-12");
        for(let item of information) {
            item.style.width = screen.width * 0.08 + "px";
        }
    }
    else {
        filter.style.display = "none";
        toggle.style.display = "inline-block";
        catalog.classList.add("col-12");
        if(list[0].offsetWidth / 4.1 > 96) {
            for(let item of information) {
                item.style.width = list[0].offsetWidth / 4.1 + "px";
            }
        }
        else {
            for(let item of information) {
                item.style.width = "96px";
            }
        }   
    }
    

    size = 0.1 * information[0].offsetWidth;
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

function OpenFilter() {
    if(filter.style.display === "none") {
        catalog.classList.remove("width75");
        filter.style.display = "inline-block";
        holder.style.width = Window.innerWidth - 19 + "px";
    }
    else
        filter.style.display = "none";
}