$(document).on("turbolinks:load", function() {
  var cbox = $("#article_no_expiration");
  var field = $(".article_expired_at");

  var changeExpiredAt = function() {
    if (cbox.prop("checked"))
      field.hide()
    else
      field.show()
  }

  cbox.bind("click", changeExpiredAt);

  changeExpiredAt();
});
