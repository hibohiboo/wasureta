import * as jQuery from 'jquery';

(function ($) {
  $(function () {
    // レギュレーションの切り替え
    $('input', $('.regulation')).on('change', e => {
      const $elm = $(e.target);
      const isChecked = $elm.prop('checked');
      const selector = '.' + $elm.val();

      $(selector).hide();

      if (isChecked) {
        $(selector).show();
      }
    });

  }); // end of document ready
})(jQuery); // end of jQuery name space
