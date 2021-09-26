function ddnsUdate(myemail, mykey){
  var CClient = require('cloudflare');
  var client = new CFClient({
    email: myemail,
    key: mykey
});


};