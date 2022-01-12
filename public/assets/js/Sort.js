var offset = document.getElementById("offset").innerHTML;
var order = document.getElementById("order");
Sort();
function Sort() {
    var list = document.getElementsByClassName("product");
    list = Array.prototype.slice.call(list);
    var sortingorder = order.value;
    var first, second, text;
    list.sort(function (a, b) {
        if (sortingorder == 5) {
            first = parseInt(a.children[0].getElementsByTagName("p")[sortingorder].innerHTML);
            second = parseInt(b.children[0].getElementsByTagName("p")[sortingorder].innerHTML);
            return first - second;
        }
        else {
            text = a.children[0].getElementsByTagName("p")[sortingorder].innerHTML.toLowerCase();
            if (text.localeCompare('expired') == 0)
                first = -1;
            else if (text.indexOf('d') != -1) 
                first = parseInt(text) * 86400;
            else if (text.indexOf('h') != -1)
                first = parseInt(text) * 3600;
            else if (text.indexOf('m') != -1)
                first = parseInt(text) * 60;
            else
                first = parseInt(text);

            text = b.children[0].getElementsByTagName("p")[sortingorder].innerHTML.toLowerCase();
            if (text.localeCompare('expired') == 0)
                second = -1;
            else if (text.indexOf('d') != -1)
                second = parseInt(text) * 86400;
            else if (text.indexOf('h') != -1)
                second = parseInt(text) * 3600;
            else if (text.indexOf('m') != -1)
                second = parseInt(text) * 60;
            else
                second = parseInt(text);

            return second - first;
        }
    });

    $('.page').empty();

    for (var i = 0, len = list.length; i < len; i++) {
        $('.page')[parseInt(i / offset)].appendChild(list[i]);
    }
}