function Bid() {
    if(!isNaN(document.getElementById("offer").value) && document.getElementById("offer").value != "") {
        var current = parseFloat(document.getElementById("current").innerHTML);
        var offer = parseFloat(document.getElementById("offer").value);
        var cap = parseFloat(document.getElementById("cap").innerHTML.split(" ")[1]);
        var bids = parseInt(document.getElementById("bids").innerHTML.split(" ")[1]);
        
        if(offer <= current)
            alert("Offer is too low!");
        else if(offer >= cap) {
            document.getElementById("current").innerHTML = cap + '$';
            document.getElementById("holder").innerHTML = 'Bidder: Erod Nelps (9.2 Rated)';
            document.getElementById("name").innerHTML += ' (Sold)';
            document.getElementById("bids").innerHTML = 'Bids: ' + (bids + 1) + ' Times';
            document.getElementById("offer").disabled = true;
            alert("Bought!");
        }
        else {
            document.getElementById("current").innerHTML = offer + '$';
            document.getElementById("holder").innerHTML = 'Bidder: Erod Nelps (9.2 Rated)';
            document.getElementById("bids").innerHTML = 'Bids: ' + (bids + 1) + ' Times';
            alert("Complete!");
        }
    }

    document.getElementById("offer").value = "";
}