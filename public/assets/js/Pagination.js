$( ".page" ).hide();
$('.last-page').html(document.getElementsByClassName("page-item").length - 2);
$('.page-item').eq(1).addClass('active').siblings().removeClass('active');
$( ".page" ).eq(0).show();

$('.page-item').click(function() {
    var index = $(this).index() - 1;
    if($(this).index() === 0) {
        if($('.active').index() > 1) {
            index = $('.active').index() - 1;
            $('.page-item').eq(index).addClass('active').siblings().removeClass('active');
            index--;
        }
        else
            return;
    }
    else if($(this).index() > $('.page').length) {
        if($('.active').index() < $('.page').length) {
            index = $('.active').index() + 1;
            $('.page-item').eq(index).addClass('active').siblings().removeClass('active');
            index--;
        }
        else
            return;
    }
    else
        $(this).addClass('active').siblings().removeClass('active');

    $( ".page" ).hide();
    $( ".page" ).eq(index).show()

    index++;

    $('.page-item').hide();
    $('.page-item').eq(index).show();
    var offset = 7;
    for(var i = 1; index - i > -1 && offset > 0; i++, offset--) {
        $('.page-item').eq(index - i).show();
    }
    offset += 7;
    for(var i = 1; index + i < $('.page-item').length && offset > 0; i++, offset--) {
        $('.page-item').eq(index + i).show();
    }
  });
