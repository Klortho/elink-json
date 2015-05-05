(function($) {
  var samples = [
  ];

  $(document).ready(function() {
    var samples_div = $("#samples");
    var containers = {
      'xml': [],
      'json': []
    }
    var xml_containers = [];
    var json_containers = [];

    for (var i = 0; i < 10; ++i) {
      samples_div.append("<h2>Sample " + i + "</h2>");

      var row_div = $("<div class='table'><div class='row'>");
      samples_div.append(row_div);

      ['xml', 'json'].forEach(function(t) {
        var pre = $("<pre class='" + t + "'>");
        row_div.append(pre);
        var prism_lang = t == 'xml' ? 'markup' : 'javascript';
        containers[t][i] = 
          $("<code class='language-" + prism_lang + "'>")
            .html("Loading " + t + " ...");
        pre.append(containers[t][i]);

        (function(_t, _i) {
          $.ajax("sample-" + _i + "." + t)
            .done(function(content) {
              container = containers[_t][_i];
              container.text(content);
              Prism.highlightElement(container[0]);
            });
        })(t, i);
      })
    }
  });    
})(jQuery);
