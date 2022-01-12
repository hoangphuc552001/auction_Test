(function(){
    function readURL(input) {

        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('.avatar-bg').css({
                    'background':'url('+e.target.result+')',
                    'background-size':'cover',
                    'background-position': '50% 50%'
                });
            };

            reader.readAsDataURL(input.files[0]);
        }
    }
    
    function toggleAlert(clasz, display){
        $(".alert")
            .removeClass("display")
            .removeClass("alert-info")
            .removeClass("alert-success")
            .removeClass("alert-danger")
            .addClass(clasz);
        if(display){
            $(".alert").addClass("display")
        }
        if(clasz === "alert-success"){
            $(".alert > span").text('Profile saved');
        }else if(clasz === "alert-danger"){
            $(".alert > span").text('Profile reset');
        }
    }

    $("input.form-control[name=avatar-file]").change(function(){
        readURL(this);
    });
    
    $('#profile').delegate('form', 'submit', function (e) {
        var inst = this;
        var formData = new FormData($(this)[0]);

        $(inst).find("button[type = submit]").addClass("loading").prop("disabled", true);
        toggleAlert("alert-success", true);
        
        setTimeout(function(){
            $(inst).find("button[type = submit]").removeClass("loading").prop("disabled", false);
            toggleAlert("alert-success");
        },1000);
        
        return false;
    });
    
    $('#profile').delegate('form', 'reset', function (e) {
        var inst = this;
        var formData = new FormData($(this)[0]);

        $(inst).find("button[type = reset]").addClass("loading").prop("disabled", true);
        toggleAlert("alert-danger",true);
        
        setTimeout(function(){
            $(inst).find("button[type = reset]").removeClass("loading").prop("disabled", false);
            toggleAlert("alert-danger");
        },1000);
        
        return false;
    });
})

var namemodal = document.getElementById('nameModal');
var emailmodal = document.getElementById('emailModal');
var dobmodal = document.getElementById('dobModal');

// Get the button that opens the modal
var namebtn = document.getElementById('nameBtn');
var emailbtn = document.getElementById('emailBtn');
var dobbtn = document.getElementById('dobBtn');

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

// When the user clicks on the button, open the modal
namebtn.onclick = function() {
  modal.style.display = "block";
};
emailbtn.onclick = function() {
    modal.style.display = "block";
};
dobbtn.onclick = function() {
modal.style.display = "block";
};

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
  modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}

var today = new Date();
var dd = today.getDate();
var mm = today.getMonth()+1; //January is 0!
var yyyy = today.getFullYear();
if(dd<10){
        dd='0'+dd
    } 
    if(mm<10){
        mm='0'+mm
    } 
today = yyyy+'-'+mm+'-'+dd;
document.getElementById('dobInput').setAttribute("max", today);
document.getElementById('dobInput').setAttribute("value", today);