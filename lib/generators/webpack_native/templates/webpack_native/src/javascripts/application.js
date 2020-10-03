// Do not remove this line, all your @import will goes into webpack_native/stylesheets/application.scss
import '../stylesheets/application.scss';
// the following line requires that images folder exists
require.context('../images', true, /\.(gif|jpeg|jpg|png|svg)$/i);

require("@rails/ujs").start();
require("turbolinks").start();

// your JavaScript code here...
// document.addEventListener('turbolinks:load', () => {
//   alert('hello webpackNative!')
// });
