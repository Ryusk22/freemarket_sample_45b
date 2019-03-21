$(document).ready(function() {
  var form = $("#charge-form");
  Payjp.setPublicKey('pk_test_46e0715c69e5c4ec9239df4c');
  $(document).on("click", "#submit-button", function(e) {

    e.preventDefault();
    form.find("input[type=submit]").prop("disabled", true);

    var card = {
        number: $("#payment_card_no").val(),
        cvc: $("#payment_card_cvc").val(),
        exp_month: $("#payment_expiration_date_1i").val(),
        exp_year: $("#payment_expiration_date_2i").val(),
    };
    Payjp.createToken(card, function(s, response) {
      if (response.error) {
        form.find('.charge-errors').text(response.error.message);
        form.find('button').prop('disabled', false);
      }
      else {
        $(".number").removeAttr("name");
        $(".cvc").removeAttr("name");
        $(".exp_month").removeAttr("name");
        $(".exp_year").removeAttr("name");
        var token = response.id;

        form.append($('<input type="hidden" name="payjpToken" />').val(token));
        form.get(0).submit();
      }
    });
  });
});
