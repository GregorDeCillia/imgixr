// https://stackoverflow.com/questions/1714786/
function toQueryString(x) {
  let keys = Object.keys(x), values = Object.values(x), query = [];
  for (let i = 0; i < keys.length; i++) {
    query.push(`${keys[i]}=${values[i]}`);
  }
  return query.join('&');
}

function imgxrSource(x, height, width) {
  let query = x.query;
  query.h = height;
  query.w = width;
  query = toQueryString(x.query);
  return x.url + '?' + query;
}

HTMLWidgets.widget({
  name: 'imgixr_widget',
  type: 'output',
  factory: function(el, width, height) {
    var img;
    var object;
    return {
      renderValue: function(x) {
        img = document.createElement('img');
        object = x;
        img.src = imgxrSource(x, height, width);
        el.appendChild(img);
        //el.innerText = img.src;
        return el;
      },
      resize: function(width, height) {
        img.src = imgxrSource(object, height, width);
      }
    };
  }
});
