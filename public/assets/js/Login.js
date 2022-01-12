var text = this.document.URL.split('=')[1];
if(text)
    text = text.split('%40')[0];
if(text)
    if(text === "admin")
        document.location.href = "/admin";
    else if(text === "bidder")
        document.location.href = "/bidder-profile";
    else if(text === "seller")
        document.location.href = "/seller-profile"