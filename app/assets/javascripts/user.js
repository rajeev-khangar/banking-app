$(document).on('ready page:load turbolinks:load', function(){
  submitTimeField();
});

var submitTimeField = function(){
  $(".datetimepicker" ).datetimepicker({
    format: 'YYYY-MM-DD HH:mm',
    ignoreReadonly: true,
    allowInputToggle: true
  })
}   